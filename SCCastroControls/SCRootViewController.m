//
//  SCRootViewController.m
//  SCCastroControls
//
//  Created by Sam Page on 22/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import "SCRootViewController.h"
#import "SCPlaybackViewController.h"

@interface SCRootViewController ()
@property (nonatomic, strong) SCPlaybackViewController *playbackViewController;
@end

@implementation SCRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.playbackViewController = [[SCPlaybackViewController alloc] initWithNibName:nil bundle:nil];
    [self.playbackViewController willMoveToParentViewController:self];
    [self addChildViewController:self.playbackViewController];
    [self.view addSubview:self.playbackViewController.view];
    [self.playbackViewController didMoveToParentViewController:self];
    
    self.playbackViewController.view.frame = CGRectMake(0.f,
                                                        CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.playbackViewController.view.bounds),
                                                        CGRectGetWidth(self.view.bounds),
                                                        CGRectGetHeight(self.playbackViewController.view.bounds));
    
    SCPlaybackItem *playbackItem = [[SCPlaybackItem alloc] init];
    playbackItem.totalTime = 60. * 10.;
    playbackItem.elapsedTime = 0.;
    
    self.playbackViewController.playbackItem = playbackItem;
}

@end
