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
@property (nonatomic, strong) NSArray *powerUpTypes;
@property (nonatomic, strong) NSNumber *cumulativeChanceToSpawn;

@end

@implementation PowerUpManager

// part of the dynamic roulett wheel selection
- (NSNumber*)cumulativeChanceToSpawn
{
    if (_cumulativeChanceToSpawn == nil) {
        unsigned int temp = 0;
        for (PowerUp *powerUpType in self.powerUpTypes) {
            
            temp += [[[powerUpType class] chanceToSpawn] intValue];
        }
        _cumulativeChanceToSpawn = [NSNumber numberWithInt:temp];
    }
    return _cumulativeChanceToSpawn;
}

- (id)initWithScene:(SKScene *)scene
{
    self = [super init];
    self.myScene = scene;
    
    
    
    // Creates PowerUps in the given TimeInterval
    [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(createPowerUp:) userInfo:nil repeats:YES];
    
    return self;
}

- (void)createPowerUp:(NSTimer*)theTimer
{
    // dynamic roulett wheel selection
    
    PowerUp *powerUp;
    
    u_int32_t randomNumber = arc4random() % [self.cumulativeChanceToSpawn intValue]; // number 0-cumulativeChanceToSpawn for rouletteWheelSelection
    
    int temp = 0;
    for (PowerUp *powerUpType in self.powerUpTypes) {
        temp += [[[powerUpType class] chanceToSpawn] intValue];
        if (temp >= randomNumber) {
            powerUp = [[[powerUpType class] alloc] init];
            break;
        }
    }
    
    [self.myScene addChild:powerUp];
    [self.powerUps addObject:powerUp];
    [powerUp changePosition]; // only works after he is in his scene
    
    // Player has only limited time to collect the PowerUp
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(deletePowerUp:) userInfo:powerUp repeats:NO];
}

- (NSArray*)powerUpTypes
{
    if (_powerUpTypes == nil) {
        _powerUpTypes = [NSArray arrayWithObjects:  [Speedboost class],
                                                    [Scoreboost class],
                                                    [Immortal class],
                                                    [Tinier class],nil];
    }
    return _powerUpTypes;
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
