//
//  CollisionManager.h
//  Voozix
//
//  Created by K!N on 1/5/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyManager.h"

@interface CollisionManager : NSObject <SKPhysicsContactDelegate>
@property (nonatomic, strong) EnemyManager *enemyManager;
@end
