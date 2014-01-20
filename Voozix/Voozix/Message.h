//
//  Message.h
//  Voozix
//
//  Created by VM on 16.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum  {
    ReadyToStartMatch,
    matchStarted,
    matchEnded,
    playerMoved,
    StarSpawned,
    StarCollected,
    ShootingStarSpawned,
    ShootingStarCollected,
    PowerUpSpawned,
    PowerUpCollected,
    EnemyBallSpawned,
} MessageType;

@interface Message : NSObject
@property (nonatomic)MessageType messageType;
@property (nonatomic)CGPoint position;
@property (nonatomic)CGVector velocity;
@property (nonatomic)NSArray *args;
@end
