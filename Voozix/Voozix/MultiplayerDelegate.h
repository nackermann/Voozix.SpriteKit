//
//  MultiplayerDelegate.h
//  Voozix
//
//  Created by VM on 17.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@protocol MultiplayerDelegate <NSObject>

@optional
-(void)matchStarted;
-(void)readyToStartMatch;
-(void)matchEnded;
-(void)receivedMessage:(Message *)message fromPlayerID:(NSString *)playerID;
-(void)inviteReceived; //Maybe remove it

@end
