//
//  Message.h
//  Voozix
//
//  Created by VM on 16.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum  { playerMoved,
                StarSpawned,
                StarCollected,
                PowerUpSpawned,
                PowerUpCollected,
                matchStarted,
                matchEnded
              } MessageType;

@interface Message : NSObject
@property (nonatomic)MessageType messageType;
@property (nonatomic)id Object;
@property (nonatomic)CGVector velocity;
@end
