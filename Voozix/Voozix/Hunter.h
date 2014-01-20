//
//  Hunter.h
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

/**
 * @class Hunter
 *
 * @brief Advanced enemy that tries to catch the player
 *
 * Detailed doc
 */
@interface Hunter : SKSpriteNode
-(id)initWithPlayer:(Player *)player AndPosition:(CGPoint)position;
-(id)initWithPlayer:(Player *)player;
-(void)setRandomPosition;
-(void)update;
@end
