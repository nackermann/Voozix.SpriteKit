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
    player.playerSpeed = player.playerSpeed * 0.6666666; // I hope that it is correct, manuel check this !
}

- (NSNumber*)chanceToSpawn
{
    if (_chanceToSpawn == nil) {
        _chanceToSpawn = [NSNumber numberWithInt:spawnChance];
    }
    return _chanceToSpawn;
}

@end