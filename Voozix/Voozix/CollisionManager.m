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
        Star *star = (Star *)secondBody.node;
        star.physicsBody = nil;
        
        [star changePosition];
        [self.enemyManager createEnemy];
        self.hudManager.score++;
        
        // Recreate PhysicsBody
        star.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:star.size.width/2];
        star.physicsBody.dynamic = NO;
        star.physicsBody.categoryBitMask = STAR_OBJECT;
        star.physicsBody.contactTestBitMask = PLAYER_OBJECT;
        
    }
    else if ((firstBody.categoryBitMask & PLAYER_OBJECT) != 0 &&
             (secondBody.categoryBitMask & ENEMY_OBJECT) != 0)
    {
        for (EnemyBall *enemy in self.enemyManager.enemies) {
            [enemy removeFromParent];
        }
        
        [self.enemyManager.enemies removeAllObjects];
        
        Player *player = (Player *)firstBody.node;
        player.physicsBody = nil;
        
        player.position = CGPointMake(self.myScene.frame.size.width/2+50, self.myScene.frame.size.height/2+50);
        self.hudManager.score = 0;
        
        // Recreate PhysicsBody
        player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
        player.physicsBody.categoryBitMask = PLAYER_OBJECT;
        player.physicsBody.contactTestBitMask = ENEMY_OBJECT | STAR_OBJECT;
        
    }
}


@end
