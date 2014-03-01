//
//  SCTapHintBehavior.m
//  SCCastroControls
//
//  Created by Sam Page on 23/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import "SCTapHintBehavior.h"

@implementation SCTapHintBehavior

- (id)initWithItem:(NSArray *)items
{
    if (self = [super init])
    {
        self.pushBehavior = [[UIPushBehavior alloc] initWithItems:items mode:UIPushBehaviorModeInstantaneous];
        [self addChildBehavior:self.pushBehavior];
        
        self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:items];
        [self addChildBehavior:self.gravityBehavior];
        
        self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
        [self addChildBehavior:self.collisionBehavior];
    }
    return self;
}

@end
