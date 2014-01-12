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
#import "SoundManager.h"
#import "GameOverScene.h"

@interface MyScene()
@property (nonatomic, strong) HUDManager *HUDManager;
@property (nonatomic, strong) CollisionManager *collisionManager;
@property (nonatomic, strong) EnemyManager *enemyManager;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) SKLabelNode *gameOverMessage;

@property (nonatomic, weak) Player *player;
@property (nonatomic, weak) Star *star;

@end

@implementation MyScene
/**
 * @brief Initializes the full scene and most of the objects (some are intialized by lazy-initialization).
 * @details [long description]
 * 
 * @param  [description]
 * @return [description]
 */
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.dynamic = NO;
        self.physicsBody.restitution = 0.0;
        self.physicsBody.categoryBitMask = BACKGROUND_OBJECT;
        
        SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        CGPoint myPoint = CGPointMake(0.f, 0.f);
        backgroundSprite.anchorPoint = myPoint;
        backgroundSprite.position = myPoint;
        
        self.collisionManager.enemyManager = self.enemyManager;
        self.collisionManager.soundManager = self.soundManager;
        
        self.physicsWorld.contactDelegate = self.collisionManager;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        [self addChild:backgroundSprite];
        [self addChild:self.soundManager];
        
        // Currently disabled, music not stopping when changing to a scene, no solution found yet
        //[self.soundManager playSong:BACKGROUND_MUSIC];

    }
    return self;
}

/**
 * This gets called when a touch begins and then notifies all objects
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.player.dead) {
        [self gameOver];
    }else {
        
        [self.player touchesBegan:touches withEvent:event];
    }
}

/**
 * This gets called during a touch and then notifies all objects
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.player.dead) {
        [self.player touchesMoved:touches withEvent:event];
    }
}

/**
 * This gets called when a touch ends and then notifies all objects
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.player touchesEnded:touches withEvent:event];
}

/**
 * Returns the collision manager which is responsible for the scene
 */
- (CollisionManager*)collisionManager
{
    if (_collisionManager == nil) {
        _collisionManager = [[CollisionManager alloc] initWithScene:self];
    }
    return _collisionManager;
}

/**
 * Returns the HUD manager which is responsible for the scene
 */
- (HUDManager*)HUDManager
{
    if (_HUDManager == nil) {
        _HUDManager = [[HUDManager alloc] initWithScene:self];
    }
    return _HUDManager;
}

/**
 * @brief Returns the enemy manager which is responsible for the scene
 * @details [long description]
 * 
 * @return [description]
 */
- (EnemyManager *)enemyManager {
    
    if (!_enemyManager) {
        _enemyManager = [[EnemyManager alloc] initWithScene:self];
    }
    
    return _enemyManager;
}

- (SoundManager *)soundManager {
    
    if (!_soundManager) {
        _soundManager = [[SoundManager alloc] init];
    }
    
    return _soundManager;
}

/**
 * @brief Returns the real player object (the one the player is controlling)
 * @details [long description]
 * 
 * @return [description]
 */
-(Player*)player
{
    if (!_player) {
        Player *myPlayer = [[Player alloc] initWithHUDManager:self.HUDManager];
        myPlayer.position = CGPointMake(50.f, 50.f);
        [self addChild:myPlayer];
        _player = myPlayer;
    }
    return _player;
}

/**
 * @brief Returns the current star object the player has to collect. There's only one - always!
 * @details [long description]
 * 
 * @param  [description]
 * @return [description]
 */
-(Star*)star
{
    if (!_star) {
        Star *myStar = [[Star alloc] init];
        [self addChild:myStar];
        [myStar changePosition];
        _star = myStar;
    }
    return _star;
}

/**
 * Update all objects that belong to the scene
 */
-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    // Update all managers
    [self.enemyManager update:currentTime];
    [self.player update];
    [self.star update];
    [self.HUDManager update];
    
    if (self.player.dead) {
        
        // Meant to call [self gameOver], but it's not working?! (scene still calls update after transition?)
        // Instead a game over message is displayed, scene transition occurs in touchesBegan-method
        if ([self childNodeWithName:@"GameOver"] != self.gameOverMessage) {
            [self addChild:self.gameOverMessage];
        }

    }
    
}

- (void)gameOver {
    
    SKView * skView = (SKView *)self.view;
    GameOverScene *gameOver = [GameOverScene sceneWithSize:skView.bounds.size];
    gameOver.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:gameOver transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];

}

- (SKLabelNode *)gameOverMessage {
    
    if (!_gameOverMessage) {
        _gameOverMessage = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        _gameOverMessage.name = @"GameOver";
        _gameOverMessage.fontColor = [SKColor yellowColor];
        _gameOverMessage.fontSize = 70;
        _gameOverMessage.text = @"GAME OVER";
        _gameOverMessage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    
    return _gameOverMessage;
}




@end
