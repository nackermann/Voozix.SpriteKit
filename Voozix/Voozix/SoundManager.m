

//
//  SoundManager.m
//  Voozix
//
//  Created by K!N on 1/10/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "SoundManager.h"
#import "AVFoundation/AVFoundation.h"


@interface SoundManager()
@property (nonatomic, strong) NSMutableDictionary *sounds;
@property (nonatomic, strong) NSMutableDictionary *songs;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation SoundManager

- (AVAudioPlayer *)player {
    
    if (!_player) {
        NSError *err;
        NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ds1.mp3" ofType:nil]];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
        
        if (err) {
            NSLog(@"%@", @"Error loading sound!");
        }
        
        [_player prepareToPlay];
        _player.numberOfLoops = -1;
        _player.volume = 1.0;
    }
    return _player;
}

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
        
        // add keys to corresponding sounds
        // keys are wrapped around NSNumbers because only objects can act as keys
        [self.sounds setObject:explosionSound forKey:[NSNumber numberWithInt:EXPLOSION_SOUND]];
        [self.sounds setObject:starCollectedSound forKey:[NSNumber numberWithInt:STAR_COLLECTED_SOUND]];
        [self.sounds setObject:powerupSound forKey:[NSNumber numberWithInt:POWER_UP_SOUND]];
        
    }
    
    return self;
}



- (void)playSound:(SoundKey)soundKey {
    
    NSNumber *key = [NSNumber numberWithInt:soundKey];
    
    [self runAction:[self.sounds objectForKey:key]];
    
}

- (void)playBackgroundMusic {
    [self.player play];
}

- (void)stop {
    
    [self.player stop];
    
}




@end
