//
//  CollisionManager.m
//  Voozix
//
//  Created by K!N on 1/5/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "CollisionManager.h"
#import "Player.h"
#import "Star.h"

static const uint32_t sprite1Category = 0x1 << 0;
static const uint32_t sprite2Category = 0x1 << 1;

@implementation CollisionManager

- (id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
//    if ([contact.bodyB.node.name isEqualToString:@"star"]) {
//        Star *star = (Star *)contact.bodyB.node;
//        //star.hidden = YES;
//        star.physicsBody = nil;
//        [star changePosition];
//        star.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:star.frame.size.width/2];
//        NSLog(@"%g, %g", star.position.x, star.position.y);
//        // star.hidden = NO;
//    }
    
    NSLog(@"%@", contact.bodyB.node.name);
    if ([contact.bodyB.node isKindOfClass:[Star class]]) {
        Star *star = (Star *)contact.bodyB.node;
        star.physicsBody = nil;
        [star changePosition];
        star.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:star.frame.size.width/2];
        star.physicsBody.dynamic = NO;
        star.physicsBody.categoryBitMask = sprite2Category;
        star.physicsBody.collisionBitMask = sprite1Category;
        star.physicsBody.contactTestBitMask = sprite1Category;
        [self.enemyManager createEnemy];
    }else if ([contact.bodyB.node isKindOfClass:[EnemyBall class]]){
        
        if ([contact.bodyA.node isKindOfClass:[Player class]]) {
            Player *player = (Player *)contact.bodyA.node;
            player.physicsBody = nil;
            player.position = CGPointMake(100, 100);
            player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
            player.physicsBody.categoryBitMask = sprite1Category;
            player.physicsBody.contactTestBitMask = sprite2Category;        }
        
    }
}


- (void)didEndContact:(SKPhysicsContact *)contact {
    
    
    
    
    
}

@end
