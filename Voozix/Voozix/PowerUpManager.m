//
//  PowerUpManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "PowerUpManager.h"
#import "PowerUp.h"
#import "Speedboost.h"
#import "Immortal.h"
#import "Tinier.h"
#import "Scoreboost.h"

@interface PowerUpManager()
@property (nonatomic, strong) SKScene *myScene;

@end

@implementation PowerUpManager

- (id)initWithScene:(SKScene *)scene
{
    self = [super init];
    self.myScene = scene;
    
    
    
    // Creates PowerUps in the given TimeInterval
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(createPowerUp:) userInfo:nil repeats:YES];
    
    return self;
}

- (void)createPowerUp:(NSTimer*)theTimer
{
    u_int32_t randomNumber = arc4random() % 101; // number 0-100 for rouletteWheelSelection
    PowerUp *powerUp;
    
    powerUp = [[Scoreboost alloc] init];
    
    // TODO Manuel, use objects chance to spawn
    if (randomNumber >= 80)
    {
        powerUp = [[Speedboost alloc] init];
    }
    else if (randomNumber >= 60)
    {
        powerUp = [[Tinier alloc] init];
    }
    else if (randomNumber >= 40)
    {
        powerUp = [[Scoreboost alloc] init]; // TODO no Score boost in early game !
    }
    else
    {
        powerUp = [[Immortal alloc] init];
    }
    
    [self.myScene addChild:powerUp];
    [self.powerUps addObject:powerUp];
    [powerUp changePosition]; // only works after he is in his scene
    
    // Player has only limited time to collect the PowerUp
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(deletePowerUp:) userInfo:powerUp repeats:NO];
}

- (NSMutableArray*)powerUps
{
    if (!_powerUps) {
        _powerUps = [[NSMutableArray alloc] init];
    }
    return _powerUps;
}

- (void)update
{
    for (PowerUp *powerUp in self.powerUps) {
        [powerUp update];
    }
}

- (void)deletePowerUp:(NSTimer*)theTimer
{
    if (theTimer.userInfo) {                        // Maybe it's already collected, but function call with nil pointer doesn't matter anyway in objective-c
        [theTimer.userInfo removeFromParent];
        [self.powerUps removeObject:theTimer.userInfo];
    }
}

@end
