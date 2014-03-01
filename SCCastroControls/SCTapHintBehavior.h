//
//  SCTapHintBehavior.h
//  SCCastroControls
//
//  Created by Sam Page on 23/02/14.
//  Copyright (c) 2014 Subjective-C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTapHintBehavior : UIDynamicBehavior

- (id)initWithItem:(NSArray *)items;

@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;

@end
