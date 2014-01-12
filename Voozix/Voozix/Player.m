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
	self.name = @"player";
	// [super scene ist noch nicht gesetzt beim alloc, erst bei add child]
	
	[self.myHUDManager.players addObject:self];
	
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

/**
 * @brief Gets called when a touch begins and then notifies other objects 
 * @details [long description]
 * 
 * @param t [description]
 * @return [description]
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self.playerController touchesBegan:touches withEvent:event];
	self.physicsBody.velocity = [self.playerController getJoystickVelocity];
	
}

/**
 * @brief Gets called when during touch and then notifies other objects 
 * @details [long description]
 * 
 * @param t [description]
 * @return [description]
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self.playerController touchesMoved:touches withEvent:event];
	self.physicsBody.velocity = [self.playerController getJoystickVelocity];
}

/**
 * @brief Gets called when a touch ends and then notifies other objects 
 * @details [long description]
 * 
 * @param t [description]
 * @return [description]
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self.playerController touchesEnded:touches withEvent:event];
	self.physicsBody.velocity = [self.playerController getJoystickVelocity];
	
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
	if ([object isKindOfClass:[Star class]]) {
		self.score = [NSNumber numberWithInt:[self.score intValue]+1];
	}
	else if ([object isKindOfClass:[EnemyBall class]])
	{
		[self.myHUDManager.players removeObject:self];
		[self removeFromParent];
        [self.playerController removeFromParent];
	}
}

/**
 * Updates the player
 */
- (void)update
{
	
}

@end
