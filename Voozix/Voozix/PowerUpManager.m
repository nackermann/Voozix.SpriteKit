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
@property (nonatomic, strong) NSTimer *spawnTimer;
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
        self.spawnTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(createPowerUp:) userInfo:nil repeats:YES];
        self.powerUpID = 0;
    }
    return self;
}

- (void)createPowerUp:(NSTimer*)theTimer
{
    // dynamic roulett wheel selection
    
    NSMutableDictionary *tmpPowerUps = [self.powerUps mutableCopy];
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:powerUpLiveTime];
    
    
    for(id powerUpID in self.powerUps)
    {
        PowerUp *p = [self.powerUps objectForKey:powerUpID];
        if([now compare:p.timeToLive] == NSOrderedAscending || [now compare:p.timeToLive] == NSOrderedSame){
            
            
            if([PeerToPeerManager sharedInstance].isMatchActive && [PeerToPeerManager sharedInstance].isHost)
            {
                Message *m = [[Message alloc] init];
                m.messageType = PowerUpCollected;
                m.args = [NSArray arrayWithObjects:p.name,[NSNull null], nil ];
                [[PeerToPeerManager sharedInstance] sendMessage:m];
            }
            
            [tmpPowerUps removeObjectForKey:p.name];
            [p removeFromParent];
        }
    }
    self.powerUps = tmpPowerUps;
    PowerUp *powerUp;
    
    u_int32_t randomNumber = arc4random() % [self.cumulativeChanceToSpawn intValue]; // number 0-100 for rouletteWheelSelection
    int type;
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
            break;
        }
    }
    NSString *powerUpID =[NSString stringWithFormat:@"powerUp %d", self.powerUpID]; //Give it an identifier!
    powerUp.name = powerUpID;
    self.powerUpID++;
    [self.powerUps setObject:powerUp forKey:powerUpID];
    [self.myScene addChild:powerUp];
    [powerUp changePosition]; // only works after he is in his scene
    
    if([PeerToPeerManager sharedInstance].isMatchActive){
        Message *m = [[Message alloc] init];
        m.messageType =PowerUpSpawned;
        m.position = powerUp.position;
        
        m.args = [NSArray arrayWithObjects:[NSNumber numberWithInt:type], powerUpID, nil];
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
    NSString *powerUpID =[message.args objectAtIndex:1];
    powerUp.name = powerUpID;
    powerUp.timeToLive = [[NSDate date] dateByAddingTimeInterval:powerUpLiveTime];
    
    [self.myScene addChild:powerUp];
    [self.powerUps setObject:powerUp forKey:powerUpID];
}

-(PowerUp *)removePowerUpWithMessage:(Message *)message
{
    NSString *powerUpID =[message.args objectAtIndex:0];
    PowerUp *p =[self.powerUps objectForKey:powerUpID];
    [p removeFromParent];
    [self.powerUps removeObjectForKey:powerUpID];
    return p;
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
    
    for(id powerUpID in self.powerUps){
        PowerUp * p= [self.powerUps objectForKey:powerUpID];
        [p update];
    }
}

-(void)stop
{
    [self.spawnTimer invalidate];
}

@end
