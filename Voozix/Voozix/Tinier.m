//
//  Tinier.m
//  Voozix
//
//  Created by Norman Ackermann on 17.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 40;

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define IPHONE_SCALE_FACTOR isiPad ? 1.0f : 0.6f

#import "Tinier.h"

@implementation Tinier

- (id)init
{
    self = [super init];
    
    self.texture = [SKTexture textureWithImageNamed:@"powerup_shrink"];
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
        [player runAction:[SKAction scaleTo:0.4 duration:1.5f]];
        
        [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(growPlayer:) userInfo:player repeats:NO];
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
