//
//  MyScene.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "MyScene.h"
#import "Star.h"
#import "HUDManager.h"
#import "Player.h"
#import "CollisionManager.h"
#import "PlayerController.h"
#import "ObjectCategories.h"

@interface MyScene()
@property (nonatomic, strong) HUDManager *HUDManager;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) CollisionManager *collisionManager;
@property (nonatomic, strong) EnemyManager *enemyManager;

@property (nonatomic, weak) Star *star;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = BACKGROUND_OBJECT;
        
        SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        CGPoint myPoint = CGPointMake(0.f, 0.f);
        backgroundSprite.anchorPoint = myPoint;
        backgroundSprite.position = myPoint;
        
        self.player = [[Player alloc] initWithHUDManager:self.HUDManager];
        self.collisionManager.enemyManager = self.enemyManager;
        
        self.physicsWorld.contactDelegate = self.collisionManager;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        [self addChild:backgroundSprite];
        [self addChild:self.player];
    }
    return self;
}

- (Star*)star
{
    if (!_star) {
        Star *myStar = [[Star alloc] init];
        [self addChild:myStar];
        [myStar changePosition];
        _star = myStar;
    }
    return _star;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    [self.player touchesBegan:touches withEvent:event];
    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.player touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.player touchesEnded:touches withEvent:event];
}

- (CollisionManager*)collisionManager
{
    if (_collisionManager == nil) {
        _collisionManager = [[CollisionManager alloc] initWithScene:self];
    }
    return _collisionManager;
}

- (HUDManager*)HUDManager
{
    if (_HUDManager == nil) {
        _HUDManager = [[HUDManager alloc] initWithScene:self];
    }
    return _HUDManager;
}

- (EnemyManager *)enemyManager {
    
    if (!_enemyManager) {
        _enemyManager = [[EnemyManager alloc] initWithScene:self];
    }
    
    return _enemyManager;
}


-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    // Update all managers
    [self.enemyManager update:currentTime];
    [self.HUDManager update];
    NSLog(@"%@", self.star);
}

@end
