//
//  PeerToPeerManager.h
//  Voozix
//
//  Created by VM on 17.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "MultiplayerDelegate.h"

@interface PeerToPeerManager : NSObject <MCBrowserViewControllerDelegate, MCSessionDelegate>

-(bool)sendMessage:(Message *)message;
+(PeerToPeerManager *)sharedInstance;
-(void)findMatchWithMinPlayers:(int)minPlayers
                    maxPlayers:(int)maxPlayers
                viewController:(UIViewController *)viewController
                      delegate:(id<MultiplayerDelegate>)theDelegate;
@end
