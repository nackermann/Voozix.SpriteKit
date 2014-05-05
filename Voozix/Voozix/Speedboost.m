//
//  Speedboost.m
//  Voozix
//
//  Created by Norman Ackermann on 13.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 35;

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define IPHONE_SCALE_FACTOR isiPad ? 1.0f : 0.6f

#import "Speedboost.h"

@implementation Speedboost

- (id)init
{
    self = [super init];
    
    self.texture = [SKTexture textureWithImageNamed:@"powerup_speed"];
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
        player.playerSpeed = player.playerSpeed * 1.5;
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(removeSpeedBoost:) userInfo:player repeats:NO];
    }
    [super didBeginContactWith:object]; // remove etc.
}

- (void)removeSpeedBoost:(NSTimer*)theTimer
{
    Player *player = theTimer.userInfo;
    player.playerSpeed = player.playerSpeed * 0.6666666;
}

+ (NSNumber*)chanceToSpawn
{
    return [NSNumber numberWithInt:spawnChance];
}

@end
