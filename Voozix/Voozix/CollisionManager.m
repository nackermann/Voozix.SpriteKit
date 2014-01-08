//
//  CollisionManager.m
//  Voozix
//
//  Created by K!N on 1/5/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "CollisionManager.h"
#import "ObjectCategories.h"
#import "Player.h"
#import "Star.h"
#import "EnemyBall.h"

@interface CollisionManager()
@property(nonatomic, strong) SKScene *myScene;
@end

@implementation CollisionManager

- (id)initWithScene:(SKScene*)scene
{
    self = [super init];
    
    self.myScene = scene;
    
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contact between objects: %@ and %@", contact.bodyA, contact.bodyB);
    
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
    if ((firstBody.categoryBitMask & PLAYER_OBJECT) != 0 &&
        (secondBody.categoryBitMask & STAR_OBJECT) != 0)
    {
        Player *player = (Player *)firstBody.node;
        Star *star = (Star *)secondBody.node;
        
        // Notify objects
        [player didBeginContactWith:star];
        [star didBeginContactWith:player];
        
        // Notify managers
        [self.enemyManager createEnemy];
        
    }
    else if ((firstBody.categoryBitMask & PLAYER_OBJECT) != 0 &&
             (secondBody.categoryBitMask & ENEMY_OBJECT) != 0)
    {
        Player *player = (Player *)firstBody.node;
        EnemyBall *enemyBall = (EnemyBall *)secondBody.node;
        
        // Notify objects
        [player didBeginContactWith:enemyBall]; // auch hier player loeschen statt veraendern
        
        // Notify managers
        [self.enemyManager removeAllEnemies];
    }
}


@end
