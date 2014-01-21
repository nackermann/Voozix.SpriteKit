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
#import "Message.h"
#import "PeerToPeerManager.h"


@interface MyScene()
@property (nonatomic, strong) HUDManager *HUDManager;
@property (nonatomic, strong) CollisionManager *collisionManager;
@property (nonatomic, strong) EnemyManager *enemyManager;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) PowerUpManager *powerUpManager;
@property (nonatomic, strong) SKLabelNode *gameOverMessage;

@property (nonatomic, strong) NSDictionary *allPlayers;

@property (nonatomic, weak) Player *player; //Also in the Dictonary
@property (nonatomic, strong) Star *star;
@property (nonatomic) float starTimer;

@property (nonatomic, strong) SKLabelNode *waitForOtherPlayersLabel;

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
        
        if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers > 0)
        {
            self.waitForOtherPlayersLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            self.waitForOtherPlayersLabel.fontSize = 30;
            [self.waitForOtherPlayersLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
            self.waitForOtherPlayersLabel.text = [NSString stringWithFormat:@"Wait for other Players. %i left.", [PeerToPeerManager sharedInstance].waitForPeers];
            
            CGPoint mid = CGPointMake( CGRectGetMidX(self.frame) , CGRectGetMidY(self.frame));
            self.waitForOtherPlayersLabel.position = mid;
            
            [self addChild:self.waitForOtherPlayersLabel];
        }
        
        if([PeerToPeerManager sharedInstance].isMatchActive)
        {
            NSArray *peerNames = [[PeerToPeerManager sharedInstance] ConnectedPeers];
            NSMutableDictionary *playerDict = [NSMutableDictionary dictionary];
            for(NSString *peerName in peerNames){
                Player *p = [[Player alloc]initWithHUDManager:self.HUDManager];
                p.position = CGPointMake(50.f, 50.f);
                p.name = peerName;
                [playerDict setObject:p forKey:p.name];
                [self addChild:p];
            }
            self.allPlayers = playerDict;
        }
        
        
        
        // Currently disabled, music not stopping when changing to a scene, no solution found yet
        [self.soundManager playBackgroundMusic];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    if([PeerToPeerManager sharedInstance].isMatchActive){
        Message *m = [[Message alloc] init];
        m.messageType = ReadyToStartMatch;
        [[PeerToPeerManager sharedInstance] sendMessage:m];
    }
}


/**
 * This gets called when a touch begins and then notifies all objects
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if( ([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers == 0) || ![PeerToPeerManager sharedInstance].isMatchActive)
    {
        [self.player touchesBegan:touches withEvent:event];
    }
}

/**
 * This gets called during a touch and then notifies all objects
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if( ([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers == 0) || ![PeerToPeerManager sharedInstance].isMatchActive)
    {
        [self.player touchesMoved:touches withEvent:event];
    }
    
}

/**
 * This gets called when a touch ends and then notifies all objects
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if( ([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers == 0) || ![PeerToPeerManager sharedInstance].isMatchActive)
    {
        [self.player touchesEnded:touches withEvent:event];
    }
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
        
        [self.allPlayers setValue:_player forKey: [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        
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
        if( ([PeerToPeerManager sharedInstance].isHost && [PeerToPeerManager sharedInstance].isMatchActive) || ![PeerToPeerManager sharedInstance].isMatchActive)
        {
            [self addChild:myStar];
            
            
            do {
                [myStar changePosition];
            }while (sqrt(pow(self.player.position.x - myStar.position.x, 2)+ pow(self.player.position.y - myStar.position.y, 2)) < 300);
            
            if([PeerToPeerManager sharedInstance].isMatchActive)
            {
                Message *m = [[Message alloc] init];
                m.messageType = StarSpawned;
                m.position = myStar.position;
                [[PeerToPeerManager sharedInstance] sendMessage:m];
            }
        }
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
    if(([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers == 0) ||
       ![PeerToPeerManager sharedInstance].isMatchActive)
    {
        
        [self.enemyManager update:currentTime];
        [self.player update];
        [self.star update];
        [self.powerUpManager update];
        [self.HUDManager update];
        
        self.starTimer -= 1/currentTime * 10;
        // NSLog(@"%g", self.starTimer);
        
        if (self.starTimer <= 0) {
            ShootingStar *star = [[ShootingStar alloc] initWithScene:self];
            
            if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)
            {
                Message *m = [[Message alloc] init];
                m.messageType = ShootingStarSpawned;
                m.position = star.position;
                m.velocity = star.physicsBody.velocity;
                m.args = [NSArray arrayWithObject:star.name];
                [[PeerToPeerManager sharedInstance] sendMessage:m];
            }
            
            [self addChild:star];
            self.starTimer = arc4random() % 2 + 2;
        }
        
    }
    if(!self.star.parent)
    {
        if(([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers == 0 && [PeerToPeerManager sharedInstance].isHost) ||
           ![PeerToPeerManager sharedInstance].isMatchActive)
        {
            [self addChild:self.star];
            
            do {
                [self.star changePosition];
            }while (sqrt(pow(self.player.position.x - self.star.position.x, 2)+ pow(self.player.position.y - self.star.position.y, 2)) < 300);
            
            if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)
            {
                Message *m = [[Message alloc] init];
                m.messageType = StarSpawned;
                m.position = self.star.position;
                [[PeerToPeerManager sharedInstance] sendMessage:m];
            }
            
        }
    }
    
    if (self.player.dead && ( ([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost) || ![PeerToPeerManager sharedInstance].isMatchActive) ){
        
        [self gameOver];
        
    }
}

- (void)gameOver {
    
    GameOverScene *gameOver = [GameOverScene sceneWithSize:  [[UIScreen mainScreen] bounds].size ];
    gameOver.scaleMode = SKSceneScaleModeAspectFill;
    gameOver.score = [self.player.score intValue];
    
    // Why no transition you ask? Because it doesn't work!
    [self.view presentScene:gameOver];
    
}

- (void)willMoveFromView:(SKView *)view {
    
    NSLog(@"%@", @"bam");
    [self.soundManager stop];
}

#pragma mark Delegate Methods

-(void)matchEnded
{
    [self gameOver];
}

-(void)receivedMessage:(Message *)message fromPlayerID:(NSString *)playerID
{
    Player *sendFromPlayer = (Player *)[self.allPlayers objectForKey:playerID];
    
    switch(message.messageType){
        case ReadyToStartMatch: break;
        case matchStarted: break;
        case matchEnded: [self gameOver]; break;
        case playerMoved:
            sendFromPlayer.physicsBody.velocity = message.velocity;
            break;
        case StarSpawned:
            if(self.star.parent) [self.star removeFromParent];
            self.star.position = message.position;
            [self addChild:self.star];
            break;
        case StarCollected: [self.star removeFromParent]; break;
        case ShootingStarSpawned:{
            ShootingStar *star = [[ShootingStar alloc] initWithScene:self];
            star.position = message.position;
            star.physicsBody.velocity = message.velocity;
            star.name = [message.args objectAtIndex:0];
            [self addChild:star];
            break;
        }
            
        case ShootingStarCollected:
            //How to remove it?!
            break;
        case PowerUpSpawned:
            [self.powerUpManager createPowerUpWithMessage:message];
            break;
        case PowerUpCollected:{
            PowerUp *p =[self.powerUpManager removePowerUpWithMessage:message];
            NSString *playerID =[message.args objectAtIndex:1];
            if(playerID){
                Player *pl = [self.allPlayers objectForKey: playerID];
                [pl didBeginContactWith:p];
                [p didBeginContactWith:pl];
            }
            break;
        }
            
        case EnemyBallSpawned:
            [self.enemyManager createEnemyWithMessage:message];
        default:
            NSLog(@"Undefined Message %i from %@", message.messageType, playerID);
            break;
    }
}
-(void)matchStarted
{
    if(self.waitForOtherPlayersLabel) [self.waitForOtherPlayersLabel removeFromParent];
}


@end
