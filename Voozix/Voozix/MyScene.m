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
#import "PowerUpManager.h"
#import "ShootingStar.h"
#import "Hunter.h"


@interface MyScene()
@property (nonatomic, strong) HUDManager *HUDManager;
@property (nonatomic, strong) CollisionManager *collisionManager;
@property (nonatomic, strong) EnemyManager *enemyManager;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) PowerUpManager *powerUpManager;
@property (nonatomic, strong) SKLabelNode *gameOverMessage;

@property (nonatomic, strong)NSDictionary *enemyPlayers;

@property (nonatomic, weak) Player *player;
@property (nonatomic, weak) Star *star;
@property (nonatomic) float starTimer;
@property (nonatomic, weak) Hunter *hunter;
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
        [self addChild:backgroundSprite]; // don't move this line ! background needs to be drawn first
        
        self.collisionManager.enemyManager = self.enemyManager;
        self.collisionManager.soundManager = self.soundManager;
        self.collisionManager.powerUpManager = self.powerUpManager;

        
        self.physicsWorld.contactDelegate = self.collisionManager;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        [self addChild:self.soundManager];
        
        self.starTimer = arc4random() % 2 + 2;
        

        
        // Currently disabled, music not stopping when changing to a scene, no solution found yet
        [self.soundManager playBackgroundMusic];

    }
    return self;
}

/**
 * This gets called when a touch begins and then notifies all objects
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.player touchesBegan:touches withEvent:event];
}

/**
 * This gets called during a touch and then notifies all objects
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.player touchesMoved:touches withEvent:event];

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

- (PowerUpManager *)powerUpManager {
    
    if (!_powerUpManager) {
        _powerUpManager = [[PowerUpManager alloc] initWithScene:self];
    }
    
    return _powerUpManager;
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

-(NSDictionary *)enemyPlayers
{
    if(!_enemyPlayers){
        NSMutableDictionary *enemysDict= [[NSMutableDictionary alloc]init];
        [enemysDict setObject:self.player forKey:self.player.name];
        _enemyPlayers = enemysDict;
    }
    return _enemyPlayers;
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

        
        while (sqrt(pow(self.player.position.x - myStar.position.x, 2)+ pow(self.player.position.y - myStar.position.y, 2)) < 300) {
            [myStar changePosition];
        }
        _star = myStar;
        
        
        if(self.hunter){
            [self.hunter removeFromParent];
        }
        
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
    [self.powerUpManager update];
    [self.HUDManager update];
    
    if (self.player.dead) {
        
        [self gameOver];

    }
    self.starTimer -= 1/currentTime * 10;
    NSLog(@"%g", self.starTimer);
    
    //Uncomment on Merge with Master
    if(self.starTimer <= ((arc4random() %4)+1)  && arc4random()%100 > 50 && !self.hunter /*&& (![PeerToPeerManager sharedInstance].isMatchActive || ( [PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstace].isHost */){
        
        NSArray *allPlayers = [self.enemyPlayers allKeys];
        NSString *choosenPlayerID = [allPlayers objectAtIndex: (arc4random()%[allPlayers count]) ];
        Player * choosenPlayer = [self.enemyPlayers objectForKey:choosenPlayerID];
        
        Hunter *h = [[Hunter alloc]initWithPlayer:choosenPlayer]; //Random Player
        self.hunter = h;
        [self addChild:_hunter];
        [self.hunter setRandomPosition];
        
        /*Uncomment on Merge with MAster must modify a bit the Message.h
         if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost){
         Message *m = [[Message alloc]init];
         m.position = _hunter.position;
         m.Arguments = [NSArray arrayWithObject:choosenPlayer];
         [[PeerToPeerManager sharedInstance] sendMessage:m];
         }
         */
        
    }else if(self.hunter){
        [self.hunter update];
    }
    
    if (self.starTimer <= 0) {
        ShootingStar *star = [[ShootingStar alloc] initWithScene:self];
        [self addChild:star];
        self.starTimer = arc4random() % 2 + 2;
        
    }
    
}

- (void)gameOver {
    
    SKView * skView = (SKView *)self.view;
    GameOverScene *gameOver = [GameOverScene sceneWithSize:skView.bounds.size];
    gameOver.scaleMode = SKSceneScaleModeAspectFill;
    gameOver.score = [self.player.score intValue];
    
    // Why no transition you ask? Because it doesn't work!
    [skView presentScene:gameOver];

}

- (void)willMoveFromView:(SKView *)view {
    
    NSLog(@"%@", @"bam");
    [self.soundManager stop];
}


@end
