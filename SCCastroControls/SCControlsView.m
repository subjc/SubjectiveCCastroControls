//
//  SCControlsView.m
//  SCCastroControls
//
//  Created by Sam Page on 22/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import "SCControlsView.h"

@interface SCControlsView ()
@property (nonatomic, strong) UIImageView *leftGrabHandleView;
@property (nonatomic, strong) UIImageView *rightGrabHandleView;
@end

const CGFloat kButtonWidth = 60.f;
const CGFloat kButtonEdgeInset = 60.f;
const CGFloat kGrabHandleInset = 10.f;

@implementation SCControlsView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playPauseButton addTarget:self action:@selector(playPauseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [self addSubview:self.playPauseButton];
        
        self.rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rewindButton addTarget:self action:@selector(rewindButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.rewindButton setImage:[UIImage imageNamed:@"rewind"] forState:UIControlStateNormal];
        [self addSubview:self.rewindButton];
        
        self.fastForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.fastForwardButton addTarget:self action:@selector(fastForwardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.fastForwardButton setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];     
        [self addSubview:self.fastForwardButton];
        
        self.elapsedTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.elapsedTimeLabel.textAlignment = NSTextAlignmentRight;
        self.elapsedTimeLabel.textColor = [UIColor whiteColor];
        self.elapsedTimeLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:self.elapsedTimeLabel];
        
        self.remainingTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.remainingTimeLabel.textColor = [UIColor whiteColor];
        self.remainingTimeLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:self.remainingTimeLabel];
        
        self.leftGrabHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grab_handle"]];
        self.leftGrabHandleView.alpha = 0.2f;
        [self addSubview:self.leftGrabHandleView];
        
        self.rightGrabHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grab_handle"]];
        self.rightGrabHandleView.alpha = 0.2f;
        [self addSubview:self.rightGrabHandleView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.playPauseButton sizeToFit];
    self.playPauseButton.frame = CGRectMake(CGRectGetMidX(self.bounds) - (kButtonWidth / 2.f), 0.f, kButtonWidth, CGRectGetHeight(self.bounds));
    
    [self.rewindButton sizeToFit];
    self.rewindButton.frame = CGRectMake(kButtonEdgeInset, 0.f, kButtonWidth, CGRectGetHeight(self.bounds));
    
    [self.fastForwardButton sizeToFit];
    self.fastForwardButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - kButtonWidth - kButtonEdgeInset, 0.f, kButtonWidth, CGRectGetHeight(self.bounds));
    
    self.elapsedTimeLabel.frame = CGRectMake(CGRectGetMinX(self.rewindButton.frame) - CGRectGetWidth(self.elapsedTimeLabel.bounds), 0.f, CGRectGetWidth(self.elapsedTimeLabel.bounds), CGRectGetHeight(self.bounds));
    
    self.remainingTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.fastForwardButton.frame), 0.f, CGRectGetWidth(self.remainingTimeLabel.bounds), CGRectGetHeight(self.bounds));
    
    self.leftGrabHandleView.frame = CGRectMake(kGrabHandleInset, CGRectGetMidY(self.bounds) - CGRectGetMidY(self.leftGrabHandleView.bounds), CGRectGetWidth(self.leftGrabHandleView.bounds), CGRectGetHeight(self.leftGrabHandleView.bounds));
    
    self.rightGrabHandleView.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.rightGrabHandleView.bounds) - kGrabHandleInset, CGRectGetMidY(self.bounds) - CGRectGetMidY(self.rightGrabHandleView.bounds), CGRectGetWidth(self.rightGrabHandleView.bounds), CGRectGetHeight(self.rightGrabHandleView.bounds));
}

#pragma mark - Public

- (void)updateForPlaybackItem:(SCPlaybackItem *)playbackItem
{
    self.elapsedTimeLabel.text = [playbackItem stringForElapsedTime];
    [self.elapsedTimeLabel sizeToFit];
    
    self.remainingTimeLabel.text = [playbackItem stringForRemainingTime];
    [self.remainingTimeLabel sizeToFit];
}

- (void)configureAlphaForScrubbingState
{
    self.playPauseButton.alpha = 0.5f;
    self.rewindButton.alpha = 0.5f;
    self.fastForwardButton.alpha = 0.5f;
    
    self.remainingTimeLabel.alpha = 0.f;
    self.elapsedTimeLabel.alpha = 0.f;
    
    self.leftGrabHandleView.alpha = 0.f;
    self.rightGrabHandleView.alpha = 0.f;
}

- (void)configureAlphaForDefaultState
{
    self.playPauseButton.alpha = 1.f;
    self.rewindButton.alpha = 1.f;
    self.fastForwardButton.alpha = 1.f;
    
    self.remainingTimeLabel.alpha = 1.f;
    self.elapsedTimeLabel.alpha = 1.f;
    
    self.leftGrabHandleView.alpha = 1.f;
    self.rightGrabHandleView.alpha = 1.f;
}

#pragma mark - Actions

- (void)playPauseButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [self.delegate controlsView:self didTapPlayButton:sender];
    }
    else
    {
        [self.delegate controlsView:self didTapPauseButton:sender];
    }
}

- (void)rewindButtonTapped:(UIButton *)sender
{
    [self.delegate controlsView:self didTapRewindButton:sender];
}

- (void)fastForwardButtonTapped:(UIButton *)sender
{
    [self.delegate controlsView:self didTapFastForwardButton:sender];
}

@end
