//
//  SCTimelineView.h
//  SCCastroControls
//
//  Created by Sam Page on 22/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPlaybackItem.h"

@interface SCTimelineView : UIView

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *elapsedTimeLabel;

- (void)updateForPlaybackItem:(SCPlaybackItem *)playbackItem;

@end
