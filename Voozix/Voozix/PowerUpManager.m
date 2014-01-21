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

static NSTimeInterval powerUpLiveTime = 4;

@interface PowerUpManager()
@property (nonatomic, strong) SKScene *myScene;
@property (nonatomic, strong) NSArray *powerUpTypes;
@property (nonatomic, strong) NSNumber *cumulativeChanceToSpawn;
@property (nonatomic)int powerUpID;

@property (nonatomic, strong) NSMutableDictionary *powerUps;
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
    
    if(![PeerToPeerManager sharedInstance].isMatchActive || ( [PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)){
    // Creates PowerUps in the given TimeInterval
       [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(createPowerUp:) userInfo:nil repeats:YES];
        self.powerUpID = 0;
    }
    return self;
}

- (void)createPowerUp:(NSTimer*)theTimer
{
    // dynamic roulett wheel selection
    
    NSMutableDictionary *tmpPowerUps = [self.powerUps mutableCopy];
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:powerUpLiveTime];
    for(PowerUp *p in self.powerUps)
    {
        if([now compare:p.timeToLive] == NSOrderedAscending) [tmpPowerUps removeObjectForKey:p.name];
    }
    self.powerUps = tmpPowerUps;
    PowerUp *powerUp;
    
    u_int32_t randomNumber = arc4random() % [self.cumulativeChanceToSpawn intValue]; // number 0-100 for rouletteWheelSelection
    int type = 0;
    int temp = 0;
    for (PowerUp *powerUpType in self.powerUpTypes) {
        temp += [[[powerUpType class] chanceToSpawn] intValue];
        if (temp > randomNumber) {
            powerUp = [[[powerUpType class] alloc] init];
            if ([powerUp isKindOfClass:[Speedboost class]])
            {
                type = SpeedboostPowerUp;
            }
            else if ([powerUp isKindOfClass:[Tinier class]])
            {
                type = TinierPowerUp;
            }
            else if ([powerUp isKindOfClass:[Scoreboost class]])
            {
                type = ScoreboostPowerUp;
            }
            else if ([powerUp isKindOfClass:[Immortal class]])
            {
                type = ImmortalPowerUp;
            }
            else
            {
                NSLog(@"undefinied behavior, check this in powerupmanager.m");
            }
            NSLog(@"%d", type);
            break;
        }
    }
    powerUp.name = [NSString stringWithFormat:@"powerUp %d", self.powerUpID]; //Give it an identifier!
    NSLog(@"%@", powerUp.name);
    self.powerUpID++;
    [self.powerUps setObject:powerUp forKey:powerUp.name];
    [self.myScene addChild:powerUp];
    [powerUp changePosition]; // only works after he is in his scene
    
    if([PeerToPeerManager sharedInstance].isMatchActive){
        Message *m = [[Message alloc] init];
        m.messageType =PowerUpSpawned;
        m.position = powerUp.position;
    
        m.args = [NSArray arrayWithObject:[NSNumber numberWithInt:type]];
        [[PeerToPeerManager sharedInstance] sendMessage:m];
        
    }
    //NSString *powerUpName = powerUp.name;
    
    // Player has only limited time to collect the PowerUp
   // [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(deletePowerUp:) userInfo:powerUp.name repeats:NO];
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
    powerUp.name = [message.args objectAtIndex:0];
    powerUp.timeToLive = [[NSDate date] dateByAddingTimeInterval:powerUpLiveTime];
    
    [self.myScene addChild:powerUp];
    [self.powerUps setValue:powerUp forKey:powerUp.name];
    
}

-(void)removePowerUpWithMessage:(Message *)message
{
    [self.powerUps removeObjectForKey:[message.args objectAtIndex:0]];
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

-(void)removePowerUpWithName:(NSString *)name
{
    [self.powerUps removeObjectForKey:name];
}
- (NSMutableDictionary*)powerUps
{
    if (!_powerUps) {
        _powerUps = [[NSMutableDictionary alloc] init];
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
        //PowerUp *powerUp = (PowerUp *)theTimer.userInfo;
        [self.powerUps removeObjectForKey:theTimer.userInfo];
        
        if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)
        {
            Message *m = [[Message alloc] init];
            m.messageType = PowerUpCollected;
            m.args = [NSArray arrayWithObject:theTimer.userInfo];
        }
        
    }
}

@end
