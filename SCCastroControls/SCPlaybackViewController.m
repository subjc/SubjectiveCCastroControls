//
//  SCPlaybackViewController.m
//  SCCastroControls
//
//  Created by Sam Page on 22/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import "SCPlaybackViewController.h"
#import "SCControlsView.h"
#import "SCTimelineView.h"
#import "SCScrubbingBehavior.h"
#import "SCTapHintBehavior.h"

@interface SCPlaybackViewController () <UICollisionBehaviorDelegate, SCControlsViewDelegate>

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, strong) NSTimer *playbackTimer;

@property (nonatomic, strong) SCScrubbingBehavior *scrubbingBehavior;
@property (nonatomic, strong) SCTapHintBehavior *tapHintBehavior;

@property (nonatomic, strong) SCControlsView *controlsView;
@property (nonatomic, strong) SCTimelineView *timelineView;

@property (nonatomic, assign) CGPoint touchesBeganPoint;
@property (nonatomic, assign) NSTimeInterval elapsedTimeAtTouchesBegan;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, assign, getter = isTimelineScrubbing) BOOL timelineScrubbing;
@property (nonatomic, assign, getter = shouldCommitTimelineScrubbing) BOOL commitTimelineScrubbing;

@end

const CGFloat kViewHeight = 50.f;
const CGFloat kTimelineCollapsedHeight = 2.f;
const CGFloat kTimelineExpandedHeight = 22.f;
const CGFloat kKeylineHeight = 1.f;

@implementation SCPlaybackViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth([[UIScreen mainScreen] bounds]), kViewHeight)];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.controlsView = [[SCControlsView alloc] initWithFrame:self.view.bounds];
    self.controlsView.delegate = self;
    [self.view addSubview:self.controlsView];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.timelineView = [[SCTimelineView alloc] initWithFrame:CGRectMake(0.f, kTimelineExpandedHeight * -1, CGRectGetWidth(self.view.bounds), kTimelineExpandedHeight)];
    [self collapseTimelineViewAnimated:NO];
    [self.view addSubview:self.timelineView];
    
    UIView *keylineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kKeylineHeight * -1, CGRectGetWidth(self.view.bounds), kKeylineHeight)];
    keylineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25f];
    [self.view addSubview:keylineView];
    
    self.tapHintBehavior = [[SCTapHintBehavior alloc] initWithItem:@[self.controlsView]];
    self.tapHintBehavior.collisionBehavior.collisionDelegate = self;
    self.tapHintBehavior.collisionBehavior.translatesReferenceBoundsIntoBoundary = NO;

    self.scrubbingBehavior = [[SCScrubbingBehavior alloc] initWithItem:self.controlsView snapToPoint:self.view.center];
    [self.dynamicAnimator addBehavior:self.scrubbingBehavior];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.controlsView addGestureRecognizer:self.panGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.controlsView addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Public

- (void)setPlaybackItem:(SCPlaybackItem *)playbackItem
{
    _playbackItem = playbackItem;

    [self.timelineView updateForPlaybackItem:playbackItem];
    [self.controlsView updateForPlaybackItem:playbackItem];
}

#pragma mark - Playback timer

- (void)timerDidFire:(id)sender
{
    if (self.isTimelineScrubbing == NO && self.playbackItem.elapsedTime < self.playbackItem.totalTime)
    {
        self.playbackItem.elapsedTime += 1;
        [self.timelineView updateForPlaybackItem:self.playbackItem];
        [self.controlsView updateForPlaybackItem:self.playbackItem];
    }
}

#pragma mark - Timeline view

- (void)expandTimelineViewAnimated:(BOOL)animated
{
    self.timelineScrubbing = YES;
    self.timelineView.elapsedTimeLabel.alpha = 1.f;
    
    void (^timelineExpansionBlock)() = ^void() {
        self.timelineView.transform = CGAffineTransformIdentity;
    };
    
    void (^completionBlock)(BOOL finished) = ^void(BOOL finished) {
        self.commitTimelineScrubbing = YES;
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.2f
                              delay:0.f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:timelineExpansionBlock
                         completion:completionBlock];
    }
    else
    {
        timelineExpansionBlock();
        completionBlock(YES);
    }
}

- (void)collapseTimelineViewAnimated:(BOOL)animated
{
    self.timelineScrubbing = NO;
    self.timelineView.elapsedTimeLabel.alpha = 0.f;
    
    if (self.shouldCommitTimelineScrubbing == NO)
    {
        self.playbackItem.elapsedTime = self.elapsedTimeAtTouchesBegan;
        [self.timelineView updateForPlaybackItem:self.playbackItem];
        [self.controlsView updateForPlaybackItem:self.playbackItem];
    }
    
    void (^timelineCollapsingBlock)() = ^void() {
        
        CGAffineTransform timelineViewScaleTransform = CGAffineTransformMakeScale(1.f, kTimelineCollapsedHeight / kTimelineExpandedHeight);
        CGAffineTransform timelineViewTranslationTransform = CGAffineTransformMakeTranslation(0.f, kTimelineExpandedHeight / kTimelineCollapsedHeight);

        self.timelineView.transform = CGAffineTransformConcat(timelineViewScaleTransform, timelineViewTranslationTransform);
    };
    

    void (^completionBlock)(BOOL finished) = ^void(BOOL finished) {
        self.commitTimelineScrubbing = NO;
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.15f
                              delay:0.f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:timelineCollapsingBlock
                         completion:completionBlock];
    }
    else
    {
        timelineCollapsingBlock();
        completionBlock(YES);
    }
}

#pragma mark - UIPanGestureRecognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translationInView = [panGesture translationInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        [self.dynamicAnimator removeBehavior:self.scrubbingBehavior];
        
        self.touchesBeganPoint = translationInView;
        self.elapsedTimeAtTouchesBegan = self.playbackItem.elapsedTime;
        
        [self expandTimelineViewAnimated:YES];
        [self fadeOutControls];
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGFloat translatedCenterX = self.view.center.x + (translationInView.x - self.touchesBeganPoint.x);

        CGFloat scrubbingProgress = (translationInView.x - self.touchesBeganPoint.x) / CGRectGetWidth(self.view.bounds);
        NSTimeInterval timeAdjustment = self.playbackItem.totalTime * scrubbingProgress;
        
        self.playbackItem.elapsedTime = self.elapsedTimeAtTouchesBegan + timeAdjustment;
        [self.timelineView updateForPlaybackItem:self.playbackItem];
        [self.controlsView updateForPlaybackItem:self.playbackItem];
        
        self.controlsView.center = CGPointMake(translatedCenterX, self.controlsView.center.y);
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        [self.dynamicAnimator addBehavior:self.scrubbingBehavior];
        [self collapseTimelineViewAnimated:YES];
        [self fadeInControls];
    }
}

#pragma mark - View fading

- (void)fadeOutControls
{
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.controlsView configureAlphaForScrubbingState];
                     } completion:NULL];
}

- (void)fadeInControls
{
    [UIView animateWithDuration:0.15f
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.controlsView configureAlphaForDefaultState];
                     } completion:NULL];
}

#pragma mark - UITapGestureRecognizer

static CGFloat kCollisionBoundaryOffset = 10.f;

static CGFloat kPushMagnitude = 4.f;
static CGFloat kGravityMagnitude = 2.f;

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognized
{
    [self.tapHintBehavior.collisionBehavior removeAllBoundaries];
    
    [self.dynamicAnimator removeBehavior:self.scrubbingBehavior];
    [self.dynamicAnimator addBehavior:self.tapHintBehavior];
    
    CGPoint locationInView = [tapGestureRecognized locationInView:self.view];

    if (locationInView.x < CGRectGetMidX(self.view.bounds))
    {
        CGPoint leftCollisionPointTop = CGPointMake(kCollisionBoundaryOffset * -1, 0.f);
        CGPoint leftCollisionPointBottom = CGPointMake(kCollisionBoundaryOffset * -1, CGRectGetHeight(self.view.bounds));
        
        [self.tapHintBehavior.collisionBehavior addBoundaryWithIdentifier:@"leftCollisionPoint" fromPoint:leftCollisionPointTop toPoint:leftCollisionPointBottom];
        [self.tapHintBehavior.gravityBehavior setAngle:M_PI magnitude:kGravityMagnitude];
        [self.tapHintBehavior.pushBehavior setAngle:0.f magnitude:kPushMagnitude];
    }
    else
    {
        CGPoint rightCollisionPointTop = CGPointMake(CGRectGetWidth(self.view.bounds) + kCollisionBoundaryOffset, 0.f);
        CGPoint rightCollisionPointBottom = CGPointMake(CGRectGetWidth(self.view.bounds) + kCollisionBoundaryOffset, CGRectGetHeight(self.view.bounds));
        
        [self.tapHintBehavior.collisionBehavior addBoundaryWithIdentifier:@"rightCollisionPoint" fromPoint:rightCollisionPointTop toPoint:rightCollisionPointBottom];
        [self.tapHintBehavior.gravityBehavior setAngle:0.f magnitude:kGravityMagnitude];
        [self.tapHintBehavior.pushBehavior setAngle:M_PI magnitude:kPushMagnitude];
    }
    
    self.tapHintBehavior.pushBehavior.active = YES;
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    [self.dynamicAnimator addBehavior:self.scrubbingBehavior];
    [self.dynamicAnimator removeBehavior:self.tapHintBehavior];
}

#pragma mark - SCControlsViewDelegate

- (void)controlsView:(SCControlsView *)controlsView didTapPlayButton:(UIButton *)playButton
{
    self.playbackTimer = [NSTimer timerWithTimeInterval:1. target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.playbackTimer forMode:NSDefaultRunLoopMode];
}

- (void)controlsView:(SCControlsView *)controlsView didTapPauseButton:(UIButton *)playButton
{
    [self.playbackTimer invalidate];
}

- (void)controlsView:(SCControlsView *)controlsView didTapRewindButton:(UIButton *)playButton
{
    self.playbackItem.elapsedTime = fmax(0., self.playbackItem.elapsedTime - 30.);
    [self.timelineView updateForPlaybackItem:self.playbackItem];
    [self.controlsView updateForPlaybackItem:self.playbackItem];
}

- (void)controlsView:(SCControlsView *)controlsView didTapFastForwardButton:(UIButton *)playButton
{
    self.playbackItem.elapsedTime = fmin(self.playbackItem.totalTime, self.playbackItem.elapsedTime + 30.);
    [self.timelineView updateForPlaybackItem:self.playbackItem];
    [self.controlsView updateForPlaybackItem:self.playbackItem];
}

@end
