//
//  SCControlsView.h
//  SCCastroControls
//
//  Created by Sam Page on 22/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPlaybackItem.h"

@class SCControlsView;

@protocol SCControlsViewDelegate <NSObject>

- (void)controlsView:(SCControlsView *)controlsView didTapPlayButton:(UIButton *)playButton;
- (void)controlsView:(SCControlsView *)controlsView didTapPauseButton:(UIButton *)playButton;
- (void)controlsView:(SCControlsView *)controlsView didTapRewindButton:(UIButton *)playButton;
- (void)controlsView:(SCControlsView *)controlsView didTapFastForwardButton:(UIButton *)playButton;

@end

@interface SCControlsView : UIView

@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) UIButton *rewindButton;
@property (nonatomic, strong) UIButton *fastForwardButton;

@property (nonatomic, strong) UILabel *elapsedTimeLabel;
@property (nonatomic, strong) UILabel *remainingTimeLabel;

@property (nonatomic, weak) id<SCControlsViewDelegate> delegate;

- (void)updateForPlaybackItem:(SCPlaybackItem *)playbackItem;

- (void)configureAlphaForScrubbingState;
- (void)configureAlphaForDefaultState;

@end