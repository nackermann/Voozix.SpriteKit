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
@end

@implementation PeerToPeerManager

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


-(void)startAdvertising
{
    if(self.advertiser == nil){
        NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceName discoveryInfo:nil session:self.session];
    }
    [self.advertiser start];
    
}

-(NSArray *)getConnectedPeers
{
    return [self.session connectedPeers];
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
    [self startAdvertising];
    NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:serviceName session:self.session];
    self.browserVC.delegate = self;
    [viewController presentViewController:self.browserVC animated:YES completion:nil];
}


-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Finished Selecting.... Starting the Game!");
    self.isHost = YES;
    self.isMatchActive = YES;
    [self.delegate matchStarted];
    
    Message *message = [[Message alloc] init];
    message.messageType = matchStarted;
    [self sendMessage:message];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Cancelled Selecting...");
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch(state){
        case MCSessionStateConnected:
            NSLog(@"Peer %@ connected", peerID.displayName);
            break;
        case MCSessionStateNotConnected:
            NSLog(@"Peer %@ didn't connect", peerID.displayName);
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
        
        if(message.messageType == matchStarted){
            self.isMatchActive = YES;
            self.isHost = false;
            [self.delegate matchStarted];
            return;
        }else if(message.messageType == matchEnded){
            self.isMatchActive = false;
            [self.delegate matchEnded];
            return;
        }

        
        [self.delegate receicedMessage:(Message *)receivedMessage fromPlayerID:peerID.displayName];
    }

    
}

-(bool)sendMessage:(Message *)message
{
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
