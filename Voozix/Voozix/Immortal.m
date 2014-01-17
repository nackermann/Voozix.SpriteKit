//
//  Immortal.m
//  Voozix
//
//  Created by Norman Ackermann on 17.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 20;

#import "Immortal.h"

@implementation Immortal

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        Player *player = object;
        player.immortal = YES;
        
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(removeImmortal:) userInfo:player repeats:NO];
        SKAction *fadeAlphaDown = [SKAction fadeAlphaTo:0.5 duration:1];
        SKAction *fadeAlphaUp = [SKAction fadeAlphaTo:1.0 duration:1];
        [player runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeAlphaDown, fadeAlphaUp]]]];
        
    }
    [super didBeginContactWith:object]; // remove etc.
}

- (void)removeImmortal:(NSTimer*)theTimer
{
    Player *player = theTimer.userInfo;
    player.immortal = NO;
    [player removeAllActions];
    [player runAction:[SKAction fadeAlphaTo:1.0 duration:1]];
}

- (NSNumber*)chanceToSpawn
{
    if (_chanceToSpawn == nil) {
        _chanceToSpawn = [NSNumber numberWithInt:spawnChance];
    }
    return _chanceToSpawn;
}

@end
