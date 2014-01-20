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

- (id)init
{
    self = [super init];
    
    self.texture = [SKTexture textureWithImageNamed:@"powerup_multiplier2x"];
	self.size = self.texture.size;
    
    return self;
}

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        Player *player = object;
        player.scoreBoost = YES;
        
        player.color = [SKColor colorWithRed:0.8 green:0.5 blue:0.0 alpha:1];
        player.colorBlendFactor = 1.0;
        
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(removeScoreBoost:) userInfo:player repeats:NO];
    }
    [super didBeginContactWith:object]; // remove etc.
}

- (void)removeScoreBoost:(NSTimer*)theTimer
{
    Player *player = theTimer.userInfo;
    player.scoreBoost = NO;
    player.colorBlendFactor = 0.0;
}

+ (NSNumber*)chanceToSpawn
{
    return [NSNumber numberWithInt:spawnChance];
}

@end
