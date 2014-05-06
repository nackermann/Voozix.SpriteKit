//
//  Scoreboost.m
//  Voozix
//
//  Created by Norman Ackermann on 16.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 20;

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define IPHONE_SCALE_FACTOR isiPad ? 1.0f : 0.6f

#import "Scoreboost.h"

@implementation Scoreboost

- (id)init
{
    self = [super init];
    
    self.texture = [SKTexture textureWithImageNamed:@"powerup_multiplier2x"];
    CGSize scaledSize;
    CGFloat width = self.texture.size.width;
    CGFloat height = self.texture.size.height;
    width *= IPHONE_SCALE_FACTOR;
    height *= IPHONE_SCALE_FACTOR;
    scaledSize.width = width;
    scaledSize.height = height;
    self.size = scaledSize;
    
    return self;
}

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        Player *player = object;
        player.scoreBoost = YES;
        
        player.color = [SKColor colorWithRed:0.8 green:0.5 blue:0.0 alpha:1];
        player.colorBlendFactor = 1.0;
        
        [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(removeScoreBoost:) userInfo:player repeats:NO];
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
