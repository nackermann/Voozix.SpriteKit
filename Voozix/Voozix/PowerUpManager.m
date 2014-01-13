//
//  PowerUpManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "PowerUpManager.h"
#import "PowerUp.h"

@interface PowerUpManager()
@property (nonatomic, strong) NSMutableArray *powerUps; // wie immer auch hier wieder austragen, manu check das ich das spaeter gemacht hab xD

@property (nonatomic, strong) SKScene *myScene;

@end

@implementation PowerUpManager

- (id)initWithScene:(SKScene *)scene
{
    self = [super init];
    self.myScene = scene;
    
    [self createPowerUp]; // ma eins machen zum testen
    
    return self;
}

- (void)createPowerUp
{
    // ggf. was fuer ein powerUp soll es werden? wird erstmal random
    
    PowerUp *powerUp = [[PowerUp alloc] init];
    [self.myScene addChild:powerUp];
    [self.powerUps addObject:powerUp];
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

@end
