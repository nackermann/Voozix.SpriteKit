//
//  MultiplayerDelegate.h
//  Voozix
//
//  Created by VM on 17.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@protocol MultiplayerDelegate 
-(void)matchStarted;
-(void)matchEnded;
-(void)receicedMessage:(Message *)message fromPlayerID:(NSString *)playerID;

@optional
-(void)inviteReceived; //Maybe remove it

@end
