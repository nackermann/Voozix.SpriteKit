//
//  MultiplayerManager.h
//  Voozix
//
//  Created by VM on 14.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Message.h"
#import "MultiplayerDelegate.h"

@interface MultiplayerManager : NSObject <GKMatchDelegate, GKMatchmakerViewControllerDelegate, GKLocalPlayerListener, GKLocalPlayerListener>

@property (nonatomic, strong)id<MultiplayerDelegate> delegate;
@property (nonatomic, strong)UIViewController *viewController;
@property (nonatomic, strong)GKMatch *match;
@property (nonatomic, strong)NSMutableDictionary *playerDictonary;

+(MultiplayerManager *)sharedInstance;
-(void)findMatchWithMinPlayers:(int)minPlayers
                    maxPlayers:(int)maxPlayers
                viewController:(UIViewController *)viewController
                      delegate:(id<MultiplayerDelegate>)theDelegate;


-(bool)sendMessage:(Message *)message;

-(void)authenticateLocalUser;
//-(bool)gameCenterisAvailable;


@end
