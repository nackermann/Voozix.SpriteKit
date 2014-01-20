//
//  Tinier.m
//  Voozix
//
//  Created by Norman Ackermann on 17.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 40;

#import "Tinier.h"

@implementation Tinier

- (id)init
{
    self = [super init];
    
    self.texture = [SKTexture textureWithImageNamed:@"powerup_shrink"];
	self.size = self.texture.size;
    
    return self;
}

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        Player *player = object;
        [player runAction:[SKAction scaleTo:0.5 duration:2]];
        
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(growPlayer:) userInfo:player repeats:NO];
    }
    [super didBeginContactWith:object]; // remove etc.
}

- (void)growPlayer:(NSTimer*)theTimer
{
    [theTimer.userInfo runAction:[SKAction scaleTo:1.0 duration:2]];
}

+ (NSNumber*)chanceToSpawn
{
    return [NSNumber numberWithInt:spawnChance];
}

@end
