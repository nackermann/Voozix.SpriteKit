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

#import "Message.h"
#import "PeerToPeerManager.h"

typedef enum  {
    SpeedboostPowerUp,
    TinierPowerUp,
    ScoreboostPowerUp,
    ImmortalPowerUp,
} PowerUpType;

@interface PowerUpManager()
@property (nonatomic, strong) SKScene *myScene;

@end

@implementation PowerUpManager

- (id)initWithScene:(SKScene *)scene
{
    self = [super init];
    self.myScene = scene;
    
    if(![PeerToPeerManager sharedInstance].isMatchActive || ( [PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)){
    // Creates PowerUps in the given TimeInterval
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(createPowerUp:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)createPowerUp:(NSTimer*)theTimer
{
    u_int32_t randomNumber = arc4random() % 101; // number 0-100 for rouletteWheelSelection
    PowerUp *powerUp;
    
    powerUp = [[Scoreboost alloc] init];
    int type;
    
    // TODO Manuel, use objects chance to spawn
    if (randomNumber >= 80)
    {
        powerUp = [[Speedboost alloc] init];
        type = SpeedboostPowerUp;
    
    }
    else if (randomNumber >= 60)
    {
        powerUp = [[Tinier alloc] init];
        type =TinierPowerUp;
    }
    else if (randomNumber >= 40)
    {
        powerUp = [[Scoreboost alloc] init]; // TODO no Score boost in early game !
        type =ScoreboostPowerUp;
    }
    else
    {
        powerUp = [[Immortal alloc] init];
        type =ImmortalPowerUp;
    }
    
    [self.myScene addChild:powerUp];
    [self.powerUps addObject:powerUp];
    [powerUp changePosition]; // only works after he is in his scene
    
    if([PeerToPeerManager sharedInstance].isMatchActive){
        Message *m = [[Message alloc] init];
        m.position = powerUp.position;
    
        m.args = [NSArray arrayWithObject:[NSNumber numberWithInt:type]];
        [[PeerToPeerManager sharedInstance] sendMessage:m];
        
    }
    
    // Player has only limited time to collect the PowerUp
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(deletePowerUp:) userInfo:powerUp repeats:NO];
}

-(void)createPowerUpWithMessage:(Message *)message
{
    PowerUp *powerUp;

    int type = [[message.args objectAtIndex:0] intValue];
    switch (type) {
        case SpeedboostPowerUp:
            powerUp = [[Speedboost alloc] init];
            break;
        case TinierPowerUp:
            powerUp = [[Tinier alloc] init];
            break;
        case ScoreboostPowerUp:
            powerUp = [[Scoreboost alloc] init];
            break;
        case ImmortalPowerUp:
            powerUp = [[Immortal alloc] init];
            break;
        default:
            break;
    }
    powerUp.position = message.position;
    [self.myScene addChild:powerUp];
    [self.powerUps addObject:powerUp];
    
    //Critical, better by receiving an Event
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
