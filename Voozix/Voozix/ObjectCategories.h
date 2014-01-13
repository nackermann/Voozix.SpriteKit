//
//  ObjectCategories.h
//  Voozix
//
//  Created by K!N on 1/5/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 * Collision categories for object categories
 */
static const uint32_t PLAYER_OBJECT = 0x1 << 0;
static const uint32_t STAR_OBJECT = 0x1 << 1;
static const uint32_t ENEMY_OBJECT = 0x1 << 2;
static const uint32_t BACKGROUND_OBJECT = 0x1 << 3;
static const uint32_t POWERUP_OBJECT = 0x1 << 4;