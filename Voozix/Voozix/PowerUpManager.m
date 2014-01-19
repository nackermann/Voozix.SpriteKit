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
@property(nonatomic, strong) NSArray *prefabContainer;
@end

@implementation PowerUpManager

- (id)initWithScene:(SKScene *)scene
{
    self = [super init];
    self.myScene = scene;
    
    self.prefabContainer = [[NSArray alloc] initWithObjects: [[Speedboost alloc] init],
                                                             [[Tinier alloc] init],
                                                             [[Scoreboost alloc] init],
                                                             [[Immortal alloc] init], nil];
    
    // Creates PowerUps in the given TimeInterval
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(createPowerUp:) userInfo:nil repeats:YES];
    
    return self;
}

- (void)createPowerUp:(NSTimer*)theTimer
{
    u_int32_t randomNumber = arc4random() % 101; // number 0-100 for rouletteWheelSelection
    PowerUp *powerUp;
    
    powerUp = [[Scoreboost alloc] init];
    
    // TODO: Put this into a loop and interate through our powerups until we find the right one
    if ([NSNumber numberWithUnsignedInt:randomNumber] >= [[self.prefabContainer objectAtIndex:0] spawnChance])
    {
        powerUp = [[Speedboost alloc] init];
    }
    if ([NSNumber numberWithUnsignedInt:randomNumber] >= [[self.prefabContainer objectAtIndex:1] spawnChance])
    {
        powerUp = [[Tinier alloc] init];
    }
    if ([NSNumber numberWithUnsignedInt:randomNumber] >= [[self.prefabContainer objectAtIndex:2] spawnChance])
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
