//
//  SCPlaybackItem.m
//  SCCastroControls
//
//  Created by Sam Page on 23/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import "SCPlaybackItem.h"

@implementation SCPlaybackItem

- (void)setElapsedTime:(NSTimeInterval)elapsedTime
{
    _elapsedTime = fmax(0.f, fmin(self.totalTime, elapsedTime));
}

#pragma mark - Time formatting

- (NSString *)stringForElapsedTime
{
    NSUInteger hours = [self hoursComponentForTimeInterval:self.elapsedTime];
    NSUInteger minutes = [self minutesComponentForTimeInterval:self.elapsedTime];
    NSUInteger seconds = [self secondsComponentForTimeInterval:self.elapsedTime];
    
    return [self stringForHours:hours minutes:minutes seconds:seconds];
}

- (NSString *)stringForRemainingTime
{
    NSUInteger hours = [self hoursComponentForTimeInterval:self.totalTime - self.elapsedTime];
    NSUInteger minutes = [self minutesComponentForTimeInterval:self.totalTime - self.elapsedTime];
    NSUInteger seconds = [self secondsComponentForTimeInterval:self.totalTime - self.elapsedTime];
    
    return [NSString stringWithFormat:@"-%@", [self stringForHours:hours minutes:minutes seconds:seconds]];
}

- (NSString *)stringForHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds
{
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%lu:%lu:%02lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
    }
    return [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
}

- (NSUInteger)hoursComponentForTimeInterval:(NSTimeInterval)timeInterval
{
    return ((NSUInteger)timeInterval / 60 / 60);
}

- (NSUInteger)minutesComponentForTimeInterval:(NSTimeInterval)timeInterval
{
    return ((NSUInteger)timeInterval / 60) % 60;
}

- (NSUInteger)secondsComponentForTimeInterval:(NSTimeInterval)timeInterval
{
    return (NSUInteger)timeInterval % 60;
}

@end
