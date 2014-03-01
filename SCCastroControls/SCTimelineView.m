//
//  SCTimelineView.m
//  SCCastroControls
//
//  Created by Sam Page on 22/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import "SCTimelineView.h"

static CGFloat kLabelWidthPadding = 10.f;

@implementation SCTimelineView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        
        self.progressView = [[UIView alloc] initWithFrame:CGRectZero];
        self.progressView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.progressView];
        
        self.elapsedTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.elapsedTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.elapsedTimeLabel.font = [UIFont boldSystemFontOfSize:15.f];
        [self addSubview:self.elapsedTimeLabel];
    }
    return self;
}

#pragma mark - Public

- (void)updateForPlaybackItem:(SCPlaybackItem *)playbackItem
{
    [self updateProgressViewForPlaybackItem:playbackItem];
    [self updateElapsedTimeLabelForPlaybackItem:playbackItem];
}

#pragma mark - Private

- (void)updateProgressViewForPlaybackItem:(SCPlaybackItem *)playbackItem
{
    if (playbackItem.totalTime > 0.f)
    {
        CGFloat progress = playbackItem.elapsedTime / playbackItem.totalTime;
        self.progressView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds) * progress, CGRectGetHeight(self.bounds));
    }
}

- (void)updateElapsedTimeLabelForPlaybackItem:(SCPlaybackItem *)playbackItem
{
    self.elapsedTimeLabel.text = [playbackItem stringForElapsedTime];
    
    CGSize labelSize = [self.elapsedTimeLabel.text sizeWithAttributes:@{NSFontAttributeName:self.elapsedTimeLabel.font}];
    self.elapsedTimeLabel.frame = CGRectMake(CGRectGetMinX(self.elapsedTimeLabel.frame),
                                             CGRectGetMinY(self.elapsedTimeLabel.frame),
                                             labelSize.width + kLabelWidthPadding,
                                             CGRectGetHeight(self.bounds));
    
    if (CGRectGetWidth(self.elapsedTimeLabel.bounds) > CGRectGetWidth(self.progressView.bounds))
    {
        [self configureElapsedLabelOriginForPendingSegment];
    }
    else
    {
        [self configureElapsedLabelOriginForElapsedSegment];
    }
}

- (void)configureElapsedLabelOriginForElapsedSegment
{
    self.elapsedTimeLabel.textColor = [UIColor blackColor];
    self.elapsedTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame) - CGRectGetWidth(self.elapsedTimeLabel.bounds),
                                             CGRectGetMinY(self.elapsedTimeLabel.frame),
                                             CGRectGetWidth(self.elapsedTimeLabel.frame),
                                             CGRectGetHeight(self.elapsedTimeLabel.frame));
}

- (void)configureElapsedLabelOriginForPendingSegment
{
    self.elapsedTimeLabel.textColor = [UIColor whiteColor];
    self.elapsedTimeLabel.frame = CGRectMake(CGRectGetWidth(self.progressView.frame),
                                             CGRectGetMinY(self.elapsedTimeLabel.frame),
                                             CGRectGetWidth(self.elapsedTimeLabel.frame),
                                             CGRectGetHeight(self.elapsedTimeLabel.frame));
}

@end
