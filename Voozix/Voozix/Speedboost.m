//
//  Speedboost.m
//  Voozix
//
//  Created by Norman Ackermann on 13.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 20;

#import "Speedboost.h"

@implementation Speedboost

- (id)init
{
    self = [super init];
    self.spawnChance = [NSNumber numberWithInt: 40];
    
    return self;
}

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        Player *player = object;
        player.playerSpeed = player.playerSpeed * 1.5;
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(removeSpeedBoost:) userInfo:player repeats:NO];
    }
    [super didBeginContactWith:object]; // remove etc.
}

- (void)removeSpeedBoost:(NSTimer*)theTimer
{
    Player *player = theTimer.userInfo;
    // Restore old speed, currently using:
    // 300 * 1.5 = 450;
    // 450 * x = 300;
    // 300/450 = 2/3
    
    // In the near future, we should use the player's default velocity.
    player.playerSpeed = player.playerSpeed * 0.66666667;
}

- (NSNumber*)chanceToSpawn
{
    if (_chanceToSpawn == nil) {
        _chanceToSpawn = [NSNumber numberWithInt:spawnChance];
    }
    return _chanceToSpawn;
}

@end
