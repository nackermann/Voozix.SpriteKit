//
//  EnemyBall.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "EnemyBall.h"
#import "ObjectCategories.h"

@implementation EnemyBall
/**
 * @brief Initializes the ball and requires assets. Does NOT initialize a physics body
 * @details [long description]
 * 
 * @param  [description]
 * @return [description]
 */
- (id)init {
    
    if (self = [super init]) {
        self.texture = [SKTexture textureWithImageNamed:@"enemy"];
        self.size = self.texture.size;
        [self setup];
    }
    
    return self;
}

/**
 * @brief Completely initializes the enemy ball and also sets the physics body
 * @details [long description]
 * 
 * @param  [description]
 * @return [description]
 */
- (id)initAtPosition:(CGPoint)position {
    
    if (self = [super init]) {
        self.texture = [SKTexture textureWithImageNamed:@"enemy"];
        self.position = position;
        self.size = self.texture.size;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = ENEMY_OBJECT;
        self.physicsBody.contactTestBitMask = PLAYER_OBJECT;
        [self setup];
    }
    
    return self;
}

/**
 * Sets properties to identify itself
 */
- (void)setup {
    
    self.name = @"enemy";
}

/**
 * @brief Handles movement of the enemy ball
 * @details [long description]
 * 
 * @param  [description]
 * @return [description]
 */
- (void)update:(CFTimeInterval)currentTime {
    
    CGPoint newPosition = self.position;
    newPosition.x += self.velocity.dx;
    newPosition.y += self.velocity.dy;
    
    self.position = newPosition;
    
}

@end
