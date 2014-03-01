//
//  SCPlaybackItem.h
//  SCCastroControls
//
//  Created by Sam Page on 23/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCPlaybackItem : NSObject

@property (nonatomic, assign) NSTimeInterval elapsedTime;
@property (nonatomic, assign) NSTimeInterval totalTime;

- (NSString *)stringForElapsedTime;
- (NSString *)stringForRemainingTime;

@end
