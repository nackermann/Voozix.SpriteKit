//
//  Message.h
//  Voozix
//
//  Created by VM on 16.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum  {
    ReadyToStartMatch,          // 0
    matchStarted,               // 1
    matchEnded,                 // 2
    playerMoved,                // 3
    StarSpawned,                // 4
    StarCollected,              // 5
    ShootingStarSpawned,        // 6
    ShootingStarCollected,      // 7
    PowerUpSpawned,             // 8
    PowerUpCollected,           // 9
    EnemyBallSpawned,           // 10
    HunterSpawned,              // 11
    HunterMoved,                // 12
    HunterDespawned,            // 13
} MessageType;

@interface Message : NSObject
@property (nonatomic)MessageType messageType;
@property (nonatomic)CGPoint position;
@property (nonatomic)CGVector velocity;
@property (nonatomic)NSArray *args;
@end
