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

@interface MyScene()
@property (nonatomic, strong) HUDManager *myHUDManager;
@property (nonatomic, strong) Star *myStar;
@property (nonatomic,strong) Player *myPlayer;
@property (nonatomic, strong) CollisionManager *collisionManager;

@end


@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        CGPoint myPoint = CGPointMake(0.f, 0.f);
        backgroundSprite.anchorPoint = myPoint;
        backgroundSprite.position = myPoint;
        
        self.myStar = [[Star alloc] init];
        self.myStar.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        self.myPlayer = [[Player alloc] init];
        
        self.collisionManager = [[CollisionManager alloc] init];
        self.collisionManager.enemyManager = self.enemyManager;
        self.collisionManager.hudManager = self.myHUDManager;
        self.physicsWorld.contactDelegate = self.collisionManager;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        [self addChild:backgroundSprite];
        [self addChild:self.myPlayer];
        [self addChild:self.myStar];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // An einen Input Manager weitergeben?
    
    for (UITouch *touch in touches) {
        /*CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];*/

        

        CGPoint location = [touch locationInNode:self];
        
//        if ([self nodeAtPoint:location] == self.myStar)
//        {
//            [self.myStar changePosition];
//            [self.enemyManager createEnemy];
//        }
//        else
//        {
            [self.myPlayer moveToPosition:location];
        //}
    }
}

- (HUDManager*)myHUDManager
{
    if (_myHUDManager == nil) {
        _myHUDManager = [[HUDManager alloc] initWithScene:self];
    }
    return _myHUDManager;
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
    [self.myHUDManager update];
}

@end
