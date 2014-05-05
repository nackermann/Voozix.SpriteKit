//
//  EnemyBall.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "EnemyBall.h"
#import "ObjectCategories.h"

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define IPHONE_SCALE_FACTOR isiPad ? 1.0f : 0.6f

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
        CGSize scaledSize;
        CGFloat width = self.texture.size.width;
        CGFloat height = self.texture.size.height;
        width *= IPHONE_SCALE_FACTOR;
        height *= IPHONE_SCALE_FACTOR;
        scaledSize.width = width;
        scaledSize.height = height;
        self.size = scaledSize;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:scaledSize.width/2];        self.physicsBody.categoryBitMask = ENEMY_OBJECT;
        self.physicsBody.collisionBitMask = PLAYER_OBJECT;
        self.physicsBody.contactTestBitMask = PLAYER_OBJECT | BACKGROUND_OBJECT;
        self.physicsBody.allowsRotation = NO;
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
    
    // Needs to be done so enemy doesn't lose velocity
    // Maybe theres a better solution, haven't found one yet
    self.physicsBody.velocity = self.velocity;
    
}

@end
