//
//  Immortal.m
//  Voozix
//
//  Created by Norman Ackermann on 17.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 30;

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define IPHONE_SCALE_FACTOR isiPad ? 1.0f : 0.6f

#import "Immortal.h"

@implementation Immortal

- (id)init
{
    self = [super init];
    
    self.texture = [SKTexture textureWithImageNamed:@"powerup_immortal"];
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
        player.immortal = YES;
        
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(removeImmortal:) userInfo:player repeats:NO];
        SKAction *fadeAlphaDown = [SKAction fadeAlphaTo:0.5 duration:1];
        SKAction *fadeAlphaUp = [SKAction fadeAlphaTo:1.0 duration:1];
        SKAction *immortalAnimation = [SKAction repeatActionForever:[SKAction sequence:@[fadeAlphaDown, fadeAlphaUp]]];
        [player runAction:immortalAnimation withKey:@"immortalAnimation"];
        
    }
    [super didBeginContactWith:object]; // remove etc.
}

- (void)removeImmortal:(NSTimer*)theTimer
{
    Player *player = theTimer.userInfo;
    player.immortal = NO;
    [player removeActionForKey:@"immortalAnimation"];
    [player runAction:[SKAction fadeAlphaTo:1.0 duration:1]];
}

+ (NSNumber*)chanceToSpawn
{
    return [NSNumber numberWithInt:spawnChance];
}

@end
