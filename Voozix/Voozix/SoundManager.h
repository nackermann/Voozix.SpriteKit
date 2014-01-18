//
//  SoundManager.h
//  Voozix
//
//  Created by K!N on 1/10/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, SoundKey) {
    
    EXPLOSION_SOUND,
    POWER_UP_SOUND,
    STAR_COLLECTED_SOUND,
    
};


/**
 * @class SoundManager
 *
 * @brief Responsible for playing sound effects and music
 *
 * Detailed doc
 */
@interface SoundManager : SKNode

- (void)playSound:(SoundKey)soundKey;
- (void)playBackgroundMusic;
- (void)stop;

@end
