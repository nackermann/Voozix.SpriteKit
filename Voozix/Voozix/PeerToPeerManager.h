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
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface PeerToPeerManager : NSObject <MCBrowserViewControllerDelegate, MCSessionDelegate>

-(bool)sendMessage:(Message *)message;
+(PeerToPeerManager *)sharedInstance;
-(void)showPeerBrowserWithViewController:(UIViewController *)viewController
                      delegate:(id<MultiplayerDelegate>)theDelegate;
-(void)startAdvertisingWithDelegate:(id<MultiplayerDelegate>)delegate;
-(void)stopAdvertising;
-(NSArray *)ConnectedPeers;

@property (nonatomic, readonly)bool isHost;
@property (nonatomic, readonly)bool isMatchActive;
@property (nonatomic, strong) id<MultiplayerDelegate> delegate;
@property (nonatomic, readonly)int waitForPeers;
@end
