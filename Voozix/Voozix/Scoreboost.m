//
//  Scoreboost.m
//  Voozix
//
//  Created by Norman Ackermann on 16.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 20;

#import "Scoreboost.h"

@implementation Scoreboost

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        Player *player = object;
        player.scoreBoost = YES;
        
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(removeScoreBoost:) userInfo:player repeats:NO];
    }
    [super didBeginContactWith:object]; // remove etc.
}

- (void)removeScoreBoost:(NSTimer*)theTimer
{
    Player *player = theTimer.userInfo;
    player.scoreBoost = NO;
}

- (NSNumber*)chanceToSpawn
{
    if (_chanceToSpawn == nil) {
        _chanceToSpawn = [NSNumber numberWithInt:spawnChance];
    }
    return _chanceToSpawn;
}

@end
