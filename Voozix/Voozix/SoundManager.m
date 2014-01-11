//
//  SoundManager.m
//  Voozix
//
//  Created by K!N on 1/10/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "SoundManager.h"


@interface SoundManager()
@property (nonatomic, strong) NSMutableDictionary *sounds;
@property (nonatomic, strong) NSMutableDictionary *songs;
@end

@implementation SoundManager

- (NSMutableDictionary *)sounds {
    
    
    if (!_sounds) {
        _sounds = [[NSMutableDictionary alloc] init];
    }
    
    return _sounds;
}


- (NSMutableDictionary *)songs {
    
    
    if (!_songs) {
        _songs = [[NSMutableDictionary alloc] init];
    }
    
    return _songs;
}


- (id) init {
    
    if (self = [super init]) {
        
        // load all sounds
        SKAction *explosionSound = [SKAction playSoundFileNamed:@"explosion.wav" waitForCompletion:YES];
        SKAction *starCollectedSound = [SKAction playSoundFileNamed:@"star_collected.wav" waitForCompletion:YES];
        SKAction *powerupSound = [SKAction playSoundFileNamed:@"powerup.wav" waitForCompletion:YES];
        
        // load all songs
        SKAction *backgroundMusicSong = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"ds1.mp3" waitForCompletion:YES]];
        
        
        // add keys to corresponding sounds and songs
        // keys are wrapped around NSNumbers because only objects can act as keys
        [self.sounds setObject:explosionSound forKey:[NSNumber numberWithInt:EXPLOSION_SOUND]];
        [self.sounds setObject:starCollectedSound forKey:[NSNumber numberWithInt:STAR_COLLECTED_SOUND]];
        [self.sounds setObject:powerupSound forKey:[NSNumber numberWithInt:POWER_UP_SOUND]];
        
        [self.songs setObject:backgroundMusicSong forKey:[NSNumber numberWithInt:BACKGROUND_MUSIC]];
        
    }
    
    return self;
}



- (void)playSound:(SoundKey)soundKey {
    
    NSNumber *key = [NSNumber numberWithInt:soundKey];
    
    [self runAction:[self.sounds objectForKey:key]];
    
}


- (void)playSong:(SongKey)songKey {
    
    
    NSNumber *key = [NSNumber numberWithInt:songKey];
    
    [self runAction:[self.songs objectForKey:key]];
    
}




@end
