//
//  MultiplayerManager.h
//  Voozix
//
//  Created by VM on 14.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol MultiplayerManagerDelegate
-(void)matchStarted;
-(void)matchEnded;
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)PlayerID;
-(void)inviteReceived;
@end

@interface MultiplayerManager : NSObject <GKMatchDelegate, GKMatchmakerViewControllerDelegate, GKLocalPlayerListener>

@property (nonatomic, strong)id<MultiplayerManagerDelegate> delegate;
@property (nonatomic, strong)UIViewController *viewController;
@property (nonatomic, strong)GKMatch *match;
@property (nonatomic, strong)NSMutableDictionary *playerDictonary;

+(MultiplayerManager *)sharedInstance;
-(void)findMatchWithMinPlayers:(int)minPlayers
                    maxPlayers:(int)maxPlayers
                viewController:(UIViewController *)viewController
                      delegate:(id<MultiplayerManagerDelegate>)theDelegate;
-(void)authenticateLocalUser;

@end
