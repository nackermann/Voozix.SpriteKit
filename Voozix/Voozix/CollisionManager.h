//
//  CollisionManager.h
//  Voozix
//
//  Created by K!N on 1/5/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyManager.h"
#import "HUDManager.h"
#import "SoundManager.h"
#import "PowerUpManager.h"

/**
 * @class CollisionManager
 *
 * @brief Handles collision events from SpriteKit and hands them over
 *
 * SpriteKit notifies our collision manager when collisions occur. The collision manager
 * will then check the types of the involved SKNodes and calls the appropriate didBeginContactWith methods
 */
@interface CollisionManager : NSObject <SKPhysicsContactDelegate>
@property (nonatomic, strong) EnemyManager *enemyManager;
@property (nonatomic, strong) HUDManager *hudManager;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) PowerUpManager *powerUpManager;
- (id)initWithScene:(SKScene*)scene;
@end
