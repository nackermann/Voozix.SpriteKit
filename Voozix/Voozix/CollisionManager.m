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
#import "ParticleManager.h"

@interface CollisionManager()
@property(nonatomic, strong) SKScene *myScene;
@property (nonatomic, strong) ParticleManager *particleManager;
@end

@implementation CollisionManager
/**
 * Initializes collision manager
 * @param  {SKScene*} Scene which contains all physics bodies
 * @return {id}
 */
- (id)initWithScene:(SKScene*)scene
{
    self = [super init];
    
    self.myScene = scene;
    
    return self;
}

/**
 * Handles every collision event by checking for object types and then properly notifying the colliding objects
 * @param {SKPhysicsContact *} contact
 */
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
        
        [self.soundManager playSound:STAR_COLLECTED_SOUND];
        
        Player *player = (Player *)firstBody.node;
        Star *star = (Star *)secondBody.node;
        
        [self.particleManager createStarSparksAtPosition:star.position];
        
        // Notify objects
        [player didBeginContactWith:star];
        [star didBeginContactWith:player];
        
        // Notify managers
        [self.enemyManager createEnemy];
        
    }
    else if ((firstBody.categoryBitMask & PLAYER_OBJECT) != 0 &&
             (secondBody.categoryBitMask & ENEMY_OBJECT) != 0)
    {
        [self.soundManager playSound:EXPLOSION_SOUND];
        
        Player *player = (Player *)firstBody.node;
        EnemyBall *enemyBall = (EnemyBall *)secondBody.node;
        
        // Notify objects
        [player didBeginContactWith:enemyBall]; // auch hier player loeschen statt veraendern
        
        // Notify managers
        [self.enemyManager removeAllEnemies];
    }
    
    else if ((firstBody.categoryBitMask & ENEMY_OBJECT) != 0 &&
             (secondBody.categoryBitMask & BACKGROUND_OBJECT) != 0)
    {
        EnemyBall *enemy = (EnemyBall *)firstBody.node;
        
        enemy.velocity = CGVectorMake(-enemy.velocity.dx, -enemy.velocity.dy);
        enemy.physicsBody.velocity = enemy.velocity;
    }
}

- (ParticleManager *)particleManager {
    
    if (!_particleManager) {
        _particleManager = [[ParticleManager alloc] initWithScene:self.myScene];
    }
    
    return _particleManager;
}


@end
