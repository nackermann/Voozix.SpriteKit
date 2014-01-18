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
#import "PeerToPeerManager.h"


@interface MyScene()
@property (nonatomic, strong) HUDManager *HUDManager;
@property (nonatomic, strong) CollisionManager *collisionManager;
@property (nonatomic, strong) EnemyManager *enemyManager;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) SKLabelNode *gameOverMessage;

@property (nonatomic, strong) NSDictionary *enemyPlayers;

@property (nonatomic, weak) Player *player;
@property (nonatomic, strong) Star *star;

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
        
        self.collisionManager.enemyManager = self.enemyManager;
        self.collisionManager.soundManager = self.soundManager;
        
        self.physicsWorld.contactDelegate = self.collisionManager;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        [self addChild:backgroundSprite];
        [self addChild:self.soundManager];
        
        
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
            NSMutableDictionary *enemyPlayerDictonary = [NSMutableDictionary dictionary];
            for(NSString *peerName in peerNames){
                Player *p = [[Player alloc]initWithHUDManager:self.HUDManager];
                p.position = CGPointMake(50.f, 50.f);
                p.name = peerName;
                [enemyPlayerDictonary setObject:p forKey:p.name];
                [self addChild:p];
            }
            self.enemyPlayers = enemyPlayerDictonary;
        }
        
        // Currently disabled, music not stopping when changing to a scene, no solution found yet
        //[self.soundManager playSong:BACKGROUND_MUSIC];
        
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
        
        if([PeerToPeerManager sharedInstance].isHost || ![PeerToPeerManager sharedInstance].isMatchActive)
        {
            [self addChild:myStar];
            [myStar changePosition];
            
            
            if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost){
                Message *m =[[Message alloc]init];
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
        [self.HUDManager update];
    }else{
        self.waitForOtherPlayersLabel.text = [NSString stringWithFormat:@"Wait for other Players. %i left.", [PeerToPeerManager sharedInstance].waitForPeers];
        
    }
    
    if (self.player.dead) {
        
        [self gameOver];
        
    }
    
}

- (void)gameOver {
    
    if([PeerToPeerManager sharedInstance].isMatchActive){
        Message *m = [[Message alloc]init];
        m.messageType = matchEnded;
        [[PeerToPeerManager sharedInstance] sendMessage:m];
    }
    
    SKView * skView = (SKView *)self.view;
    GameOverScene *gameOver = [GameOverScene sceneWithSize:skView.bounds.size];
    gameOver.scaleMode = SKSceneScaleModeAspectFill;
    gameOver.score = [self.player.score intValue];
    
    // Why no transition you ask? Because it doesn't work!
    [skView presentScene:gameOver];
    
}

#pragma mark Delegate Methods

-(void)matchEnded
{
    [self gameOver];
}

-(void)receivedMessage:(Message *)message fromPlayerID:(NSString *)playerID
{
    Player *sendFromPlayer = (Player *)[self.enemyPlayers objectForKey:playerID];
    
    NSLog(@"Received %i Message from %@",message.messageType, playerID);
    
    switch(message.messageType){
        case matchEnded: [self gameOver]; break;
        case matchStarted: break;
        case StarCollected: [self.star removeFromParent]; break;
        case StarSpawned:
            self.star.position = message.position;
            [self addChild:self.star];
            break;
        case PowerUpSpawned:
            
            break;
        case PowerUpCollected: break;
        case playerMoved:
            sendFromPlayer.physicsBody.velocity = message.velocity;
            break;
        case EnemyBallSpawned:
            [self.enemyManager createEnemyWithMessage:message];
        default: break;
    }
}
-(void)matchStarted
{
    if(self.waitForOtherPlayersLabel) [self.waitForOtherPlayersLabel removeFromParent];
}

@end
