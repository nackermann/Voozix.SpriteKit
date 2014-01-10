//
//  PlayerController.h
//  Voozix
//
//  Created by K!N on 1/7/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

/**
 * @class PlayerController
 *
 * @brief Visual joystick which controls the player
 *
 * Detailed doc
 */
#import <SpriteKit/SpriteKit.h>
@interface PlayerController : SKSpriteNode
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (CGVector)getJoystickVelocity;
@end
