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
@property(nonatomic, strong) MCAdvertiserAssistant* advertiser;
@property(nonatomic, strong) MCBrowserViewController *browserVC;
@property(nonatomic, readwrite)bool isMatchActive;
@property(nonatomic, readwrite)bool isHost;
@property(nonatomic, readwrite) int waitForPeers;
@end

@implementation PeerToPeerManager


-(void)setWaitForPeers:(int)waitForPlayers
{
    _waitForPeers = waitForPlayers;
    if(_waitForPeers == 0)
    {
        [self.delegate matchStarted];
    }
}

-(MCPeerID *)peerID
{
    if(!_peerID){
     //   NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *deviceName = [[UIDevice currentDevice] name];
        
        _peerID = [[MCPeerID alloc] initWithDisplayName: deviceName];
    }
    return _peerID;
}

-(MCSession *)session
{
    if(!_session){
        _session = [[MCSession alloc] initWithPeer:self.peerID];
        _session.delegate = self;
    }
    return _session;
}

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


-(void)startAdvertisingWithDelegate:(id<MultiplayerDelegate>)delegate
{
    if(self.advertiser == nil){
        NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceName discoveryInfo:nil session:self.session];
    }
    self.delegate = delegate;
    [self.advertiser start];
    
}

-(NSArray *)ConnectedPeers
{
    NSMutableArray *peers = [NSMutableArray array];
    for(MCPeerID *peer in [self.session connectedPeers]){
        [peers addObject:peer.displayName];
    }
    
    return peers;
}

-(void)stopAdvertising
{
    if(self.advertiser != nil){
        [self.advertiser stop];
    }
}

-(void)showPeerBrowserWithViewController:(UIViewController *)viewController
                      delegate:(id<MultiplayerDelegate>)theDelegate
{
    self.delegate = theDelegate;
    [self startAdvertisingWithDelegate:theDelegate];
    NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:serviceName session:self.session];
    self.browserVC.delegate = self;
    [viewController presentViewController:self.browserVC animated:YES completion:nil];
}


-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
    if( [self.session connectedPeers] && [[self.session connectedPeers] count] > 0)
    {
        NSLog(@"Finished Selecting.... Starting the Game!");
        self.isHost = YES;
        self.isMatchActive = YES;
        self.waitForPeers = [[self.session connectedPeers] count];
        
        [self stopAdvertising];
        [self.delegate readyToStartMatch];
        
        Message *message = [[Message alloc] init];
        message.messageType = ReadyToStartMatch;
        [self sendMessage:message];
    }
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Cancelled Selecting...");
    self.isHost = false;
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch(state){
        case MCSessionStateConnected:
            NSLog(@"Peer %@ connected", peerID.displayName);
            break;
        case MCSessionStateNotConnected:
            NSLog(@"Peer %@ disconnected.", peerID.displayName);
            break;
        default: break;
            
    }
}

-(void)session:(MCSession *)session
didReceiveData:(NSData *)data
      fromPeer:(MCPeerID *)peerID
{
    if(session != self.session) return;
    
    id receivedMessage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if([receivedMessage isKindOfClass:[Message class]]){
        Message *message = (Message *)receivedMessage;
    
        NSLog(@"Received Message %i", message.messageType);
        

        
        switch (message.messageType) {
            case ReadyToStartMatch:
                [self stopAdvertising];
                
                if(self.waitForPeers != 0){
                    self.waitForPeers--;
                }else{
                    self.isHost = false;
                }
                
                self.isMatchActive = YES;
                if(self.browserVC) [self.browserVC dismissViewControllerAnimated:YES completion:nil];
              
                if([self.delegate respondsToSelector:@selector(readyToStartMatch)])
                {
                    [self.delegate readyToStartMatch];
                }
                
                return;
                break;
            case matchStarted:
                [self.delegate matchStarted];
                break;
                return;
            case matchEnded:
                self.isMatchActive = false;
                [self.session disconnect];
                [self.delegate matchEnded];
                break;
                return;
            default:
                break;
        }
        
        [self.delegate receivedMessage:(Message *)receivedMessage fromPlayerID:peerID.displayName];
    }

    
}

-(bool)sendMessage:(Message *)message
{
    NSLog(@"Send Message: %i", message.messageType);
    NSError *error;
    NSData *data =   [NSKeyedArchiver archivedDataWithRootObject:message]; // [NSData dataWithBytes:&message length:sizeof(message)];
    return [self.session sendData:data toPeers:[self.session connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    //Unused
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    //Unused
}
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    //Unused
}


@end
