//
//  Star.h
//  Voozix
//
//  Created by K!N on 1/3/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 * @class Star
 *
 * @brief Goal object, player needs to collect this
 *
 * Detailed doc
 */
@interface Star : SKSpriteNode
- (void)didBeginContactWith:(id)object;
- (void)changePosition;
- (void)update;
@end
