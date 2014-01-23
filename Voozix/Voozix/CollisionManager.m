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
#import "PowerUp.h"
#import "ShootingStar.h"
#import "Message.h"
#import "PeerToPeerManager.h"

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
    //NSLog(@"Contact between objects: %@ and %@", contact.bodyA, contact.bodyB);
    
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
        
        if ([secondBody.node isKindOfClass:[Star class]]) {
            Star *star = (Star *)secondBody.node;
            
            
            if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)
            {
                Message *m = [[Message alloc] init];
                m.messageType = StarCollected;
                [[PeerToPeerManager sharedInstance] sendMessage:m];
                m.messageType = HunterDespawned;
                [[PeerToPeerManager sharedInstance] sendMessage:m];
            }
            
            
            
            [player didBeginContactWith:star];
            [star didBeginContactWith:player];
            
        }else if([secondBody.node isKindOfClass:[ShootingStar class]]) {
            ShootingStar *star = (ShootingStar *)secondBody.node;
            
            if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)
            {
                Message *m = [[Message alloc] init];
                m.messageType = ShootingStarCollected;
                m.args = [NSArray arrayWithObject:star.name];
                [[PeerToPeerManager sharedInstance] sendMessage:m];
            }
            [player didBeginContactWith:star];
            [star didBeginContactWith:player];
        }
        
        
        
        [self.particleManager createStarSparksAtPosition:contact.contactPoint];
        
        // Notify objects
        //        [player didBeginContactWith:star];
        //        [star didBeginContactWith:player];
        
        // Notify managers
        if(([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost) || ![PeerToPeerManager sharedInstance].isMatchActive){
            [self.enemyManager createEnemyWithPlayerPostion:player.position];
        }
        
    }
    else if ((firstBody.categoryBitMask & PLAYER_OBJECT) != 0 &&
             (secondBody.categoryBitMask & ENEMY_OBJECT) != 0)
    {
        
        if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)
        {
            Message *m = [[Message alloc] init];
            m.messageType = matchEnded;
            [[PeerToPeerManager sharedInstance] sendMessage:m];
        }
        
        [self.soundManager playSound:EXPLOSION_SOUND];
        
        Player *player = (Player *)firstBody.node;
        
          [player didBeginContactWith:secondBody.node];
        
        // Notify objects
        
        // Notify managers
        //[self.enemyManager removeAllEnemies]; // scene does this for us? if not check for memoy leaks
        
    }
    else if ((firstBody.categoryBitMask & ENEMY_OBJECT) != 0 &&
             (secondBody.categoryBitMask & BACKGROUND_OBJECT) != 0)
    {
        EnemyBall *enemy = (EnemyBall *)firstBody.node;
        
        enemy.velocity = CGVectorMake(-enemy.velocity.dx, -enemy.velocity.dy);
        enemy.physicsBody.velocity = enemy.velocity;
    }
    else if ((firstBody.categoryBitMask & PLAYER_OBJECT) != 0 &&
             (secondBody.categoryBitMask & POWERUP_OBJECT) != 0)
    {
        
        Player *player = (Player *)firstBody.node;
        PowerUp *powerUp = (PowerUp*)secondBody.node;
        if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)
        {
            Message *m = [[Message alloc] init];
            m.messageType = PowerUpCollected;
            m.args = [NSArray arrayWithObjects:powerUp.name, player.peerID, nil];
            [[PeerToPeerManager sharedInstance] sendMessage:m];
        }
        
        [player didBeginContactWith:powerUp]; // does he need to be notified? check it !
        [powerUp didBeginContactWith:player];
        

        
        [self.powerUpManager removePowerUpWithName:powerUp.name];
        
    }
    else
    {
        NSLog(@"%@",@"Something went wrong! CollisionManager.m");
    }
}

- (ParticleManager *)particleManager {
    
    if (!_particleManager) {
        _particleManager = [[ParticleManager alloc] initWithScene:self.myScene];
    }
    
    return _particleManager;
}


@end
