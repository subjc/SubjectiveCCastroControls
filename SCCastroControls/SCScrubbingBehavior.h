//
//  SCScrubbingBehavior.h
//  SCCastroControls
//
//  Created by Sam Page on 23/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCScrubbingBehavior : UIDynamicBehavior

- (id)initWithItem:(id<UIDynamicItem>)item snapToPoint:(CGPoint)point;

@end
