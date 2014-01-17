//
//  PeerToPeerManager.m
//  Voozix
//
//  Created by VM on 17.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "PeerToPeerManager.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface PeerToPeerManager()
@property(nonatomic, strong) MCPeerID *peerID;
@property(nonatomic, strong) MCSession *session;
@end

@implementation PeerToPeerManager


static PeerToPeerManager *sharedPeerToPeerManager = nil;

+(PeerToPeerManager *)sharedInstance
{
    if(!sharedPeerToPeerManager){
        sharedPeerToPeerManager = [[PeerToPeerManager alloc] init];
    }
    return sharedPeerToPeerManager;
}


-(id)init{
    self = [super init];
    if(self){
     
    }
    return self;
}

-(bool)sendMessage:(Message *)message
{
    return true;
}


-(void)advertisePeer
{
    
    self.peerID= [[MCPeerID alloc] initWithDisplayName: [[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
    
}

-(void)findMatchWithMinPlayers:(int)minPlayers
                    maxPlayers:(int)maxPlayers
                viewController:(UIViewController *)viewController
                      delegate:(id<MultiplayerDelegate>)theDelegate
{
    
}



@end
