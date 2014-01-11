//
//  EnemyBall.h
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 * @class EnemyBall
 *
 * @brief Standard ball enemy which moves in a straight pattern
 *
 * Spawns when the player collects a star. It receives a random direction (up, down, left, right) and velocity.
 */
@interface EnemyBall : SKSpriteNode
@property CGVector velocity;
- (void)update:(CFTimeInterval)currentTime;
- (id)initAtPosition:(CGPoint)position;
@end

