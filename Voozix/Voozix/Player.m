//
//  Player.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Player.h"
#import "Star.h"
#import "EnemyBall.h"
#import "ObjectCategories.h"
#import "PowerUp.h"
#import "ShootingStar.h"
#import "Message.h"
#import "PeerToPeerManager.h"
#import "Hunter.h"

static const int PLAYER_SPEED = 300;

@interface Player()
@property (nonatomic, strong) HUDManager *myHUDManager;
@end

@implementation Player
/**
 * @brief Returns the player controller
 * @details [long description]
 *
 * @param  [description]
 * @return [description]
 */
- (PlayerController *)playerController {
	
	if (!_playerController) {
		_playerController = [[PlayerController alloc] init];
        [self.parent addChild:_playerController];
	}
	
	return _playerController;
}

/**
 * @brief Initializes the player itself and the HUD manager that is responsible for drawing his information
 * @details [long description]
 *
 * @param  [description]
 * @return [description]
 */
- (id)initWithHUDManager:(HUDManager*)hudmanager
{
	self = [super init];
	self.myHUDManager = hudmanager;
	
	self.texture = [SKTexture textureWithImageNamed:@"player"];
	self.size = self.texture.size;
	self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
	self.physicsBody.categoryBitMask = PLAYER_OBJECT;
    self.physicsBody.collisionBitMask = BACKGROUND_OBJECT;
	self.physicsBody.contactTestBitMask = ENEMY_OBJECT | STAR_OBJECT;
    self.physicsBody.restitution = 0.0;
	self.physicsBody.allowsRotation = NO;
    
	[self setup];
	return self;
}

/**
 * Sets private properties to identify itself
 */
- (void)setup
{
	// [super scene ist noch nicht gesetzt beim alloc, erst bei add child]
	[self.myHUDManager.players addObject:self];
    
    self.playerSpeed = PLAYER_SPEED;
    self.dead = NO;
    self.immortal = NO;
    self.scoreBoost = NO;
	
}

/**
 * @brief Returns the player's current score
 * @details [long description]
 *
 * @param t [description]
 * @return [description]
 */
- (NSNumber*)score
{
	if (_score == nil) {
		_score = [NSNumber numberWithInt:0];
	}
	return _score;
}

- (NSNumber*)starCount
{
	if (_starCount == nil) {
		_starCount = [NSNumber numberWithInt:0];
	}
	return _starCount;
}

/**
 * @brief Gets called when a touch begins and then notifies other objects
 * @details [long description]
 *
 * @param t [description]
 * @return [description]
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if (([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers == 0)
        ||![PeerToPeerManager sharedInstance].isMatchActive) {
        
        [self.playerController touchesBegan:touches withEvent:event];
        CGVector joystickVelocity = [self.playerController getJoystickVelocity];
        self.physicsBody.velocity = CGVectorMake(joystickVelocity.dx * self.playerSpeed, joystickVelocity.dy * self.playerSpeed);
        
        if([PeerToPeerManager sharedInstance].isMatchActive)
        {
            Message *m = [[Message alloc] init];
            m.messageType = playerMoved;
            m.velocity = self.physicsBody.velocity;
            [[PeerToPeerManager sharedInstance] sendMessage:m];
        }
    }
	
}

/**
 * @brief Gets called when during touch and then notifies other objects
 * @details [long description]
 *
 * @param t [description]
 * @return [description]
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if (([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers == 0)
        ||![PeerToPeerManager sharedInstance].isMatchActive) {
        
        [self.playerController touchesMoved:touches withEvent:event];
        CGVector joystickVelocity = [self.playerController getJoystickVelocity];
        self.physicsBody.velocity = CGVectorMake(joystickVelocity.dx * self.playerSpeed, joystickVelocity.dy * self.playerSpeed);
        
        if([PeerToPeerManager sharedInstance].isMatchActive)
        {
            Message *m = [[Message alloc] init];
            m.messageType = playerMoved;
            m.velocity = self.physicsBody.velocity;
            [[PeerToPeerManager sharedInstance] sendMessage:m];
        }
    }
    
}

/**
 * @brief Gets called when a touch ends and then notifies other objects
 * @details [long description]
 *
 * @param t [description]
 * @return [description]
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if (([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].waitForPeers == 0)
        ||![PeerToPeerManager sharedInstance].isMatchActive) {
        [self.playerController touchesEnded:touches withEvent:event];
        CGVector joystickVelocity = [self.playerController getJoystickVelocity];
        self.physicsBody.velocity = CGVectorMake(joystickVelocity.dx * self.playerSpeed, joystickVelocity.dy * self.playerSpeed);
        
        if([PeerToPeerManager sharedInstance].isMatchActive)
        {
            Message *m = [[Message alloc] init];
            m.messageType = playerMoved;
            m.velocity = self.physicsBody.velocity;
            [[PeerToPeerManager sharedInstance] sendMessage:m];
        }
    }
}

/**
 * @brief On collision event that is called by the collision manager when something collides with the player
 * @details [long description]
 *
 * @param d [description]
 * @return [description]
 */
- (void)didBeginContactWith:(id)object
{
	if ([object isKindOfClass:[Star class]])
    {
        if (self.scoreBoost)
        {
            self.score = [NSNumber numberWithInt:[self.score intValue]+2]; // changen zu multiplizierer
        }
        else
        {
            self.score = [NSNumber numberWithInt:[self.score intValue]+1];
        }
        self.starCount = [NSNumber numberWithInt:[self.score intValue]+1];
	}
	else if (([object isKindOfClass:[EnemyBall class]] || [object isKindOfClass:[Hunter class]] )&& self.immortal == NO)
	{
        self.dead = YES;
        self.physicsBody.velocity = CGVectorMake(0, 0);
	}
    else if ([object isKindOfClass:[ShootingStar class]])
    {
        self.score = [NSNumber numberWithInt:[self.score intValue]+10];
    }
    else if ([object isKindOfClass:[EnemyBall class]] && self.immortal == YES)
    {
        NSLog(@"%s", "Player.m: I'm immortal!");
    }
    else
    {
        NSLog(@"%@%@%@", @"Contact with: ", object, @" - probably a PowerUp");
    }
}

- (void)setPlayerSpeed:(int)playerSpeed {
    
    if (_playerSpeed != playerSpeed) {
        _playerSpeed = playerSpeed;
    }
}


/**
 * Updates the player
 */
- (void)update
{
	
}

@end
