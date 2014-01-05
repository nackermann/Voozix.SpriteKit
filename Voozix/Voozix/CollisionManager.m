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

@implementation CollisionManager

- (id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    // Somehow the player always ends up being contact.bodyA ???
    // So i just checked the type of contact.bodyB XD
    
    
    NSLog(@"Contact between %@ and %@", contact.bodyA.node.name, contact.bodyB.node.name);
    
    // Collision with star
    if ([contact.bodyB.node isKindOfClass:[Star class]]) {
        
        Star *star = (Star *)contact.bodyB.node;
        
        // Delete PhysicsBody, so object can be repositioned
        star.physicsBody = nil;
        [star changePosition];
        self.hudManager.score++;
        
        // Recreate PhysicsBody
        star.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:star.size.width/2];
        star.physicsBody.dynamic = NO;
        star.physicsBody.categoryBitMask = STAR_OBJECT;
        star.physicsBody.contactTestBitMask = PLAYER_OBJECT;
        
        // Spawn enemy
        [self.enemyManager createEnemy];
        
        
    // Collision with enemy
    }else if ([contact.bodyB.node isKindOfClass:[EnemyBall class]]){
        
        if ([contact.bodyA.node isKindOfClass:[Player class]]) {
            
            Player *player = (Player *)contact.bodyA.node;
            
            // Delete PhysicsBody, so object can be repositioned
            player.physicsBody = nil;
            player.position = CGPointMake(100, 100);    // Position will be changed in the future
            self.hudManager.score = 0;
            
            // Recreate PhysicsBody
            player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
            player.physicsBody.categoryBitMask = PLAYER_OBJECT;
            player.physicsBody.contactTestBitMask = ENEMY_OBJECT | STAR_OBJECT;
        }
        
    }
}


- (void)didEndContact:(SKPhysicsContact *)contact {
    
    

}

@end
