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

@interface PowerUpManager()
@property (nonatomic, strong) SKScene *myScene;

@end

@implementation PowerUpManager

- (id)initWithScene:(SKScene *)scene
{
    self = [super init];
    self.myScene = scene;
    
    //[self createPowerUp:[Speedboost class]]; // ma eins machen zum testen
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(createPowerUp:) userInfo:[Speedboost class] repeats:YES];
    
    return self;
}

- (void)createPowerUp:(NSTimer*)theTimer
{
    
    PowerUp *powerUp = [[theTimer.userInfo alloc] init];
    [self.myScene addChild:powerUp];
    [self.powerUps addObject:powerUp];
    [powerUp changePosition]; // only works after he is in his scene
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(deletePowerUp:) userInfo:powerUp repeats:NO];
}

/*- (void)createPowerUp:(id)powerUpType
{
    // ggf. was fuer ein powerUp soll es werden? wird erstmal random
    
    PowerUp *powerUp = [[powerUpType alloc] init];
    [self.myScene addChild:powerUp];
    [self.powerUps addObject:powerUp];
}*/

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
