//
//  SCScrubbingBehavior.m
//  SCCastroControls
//
//  Created by Sam Page on 23/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import "SCScrubbingBehavior.h"

@implementation SCScrubbingBehavior

- (id)initWithItem:(id<UIDynamicItem>)item snapToPoint:(CGPoint)point;
{
    if (self = [super init])
    {
        UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
        dynamicItemBehavior.allowsRotation = NO;
        [self addChildBehavior:dynamicItemBehavior];
        
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:item snapToPoint:point];
        snapBehavior.damping = 0.35f;
        [self addChildBehavior:snapBehavior];
    }
    return self;
}

@end
