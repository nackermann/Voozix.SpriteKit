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
@property(nonatomic, strong) MCSession *session;
@property(nonatomic, strong) MCAdvertiserAssistant* advertiser;
@property(nonatomic, strong) MCBrowserViewController *browserVC;
@property(nonatomic, readwrite)bool isMatchActive;
@property(nonatomic, readwrite)bool isHost;
@property(nonatomic, readwrite)int waitForPeers;
@property(nonatomic, readwrite)bool advertiserIsAdvertising;
@property(nonatomic, readwrite) MCPeerID *myPeerID;

@end

@implementation PeerToPeerManager


-(void)setWaitForPeers:(int)waitForPlayers
{
    _waitForPeers = waitForPlayers;
    if(_waitForPeers == 0)
    {
        if([self.delegate respondsToSelector:@selector(matchStarted)]){
            [self.delegate matchStarted];
        }
    }
}

-(MCPeerID *)myPeerID
{
    if(!_myPeerID){
        NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *deviceName = [[UIDevice currentDevice] name];
        NSString *peerID = [NSString stringWithFormat:@"%@ (%@)", deviceName, deviceID];
        _myPeerID = [[MCPeerID alloc] initWithDisplayName: peerID];  //If you change it, you have to change it also in the MyScene!
    }
    return _myPeerID;
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
    
    NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    self.session = [[MCSession alloc]initWithPeer:self.myPeerID];
    self.session.delegate = self;
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceName discoveryInfo:nil session:self.session];
    
    self.delegate = delegate;
    [self.advertiser start];
    self.isHost = NO;
    self.advertiserIsAdvertising = YES;
    
}

-(void)stopAdvertising
{
    if(self.advertiser != nil){
        [self.advertiser stop];
    }
    
    self.advertiserIsAdvertising = NO;
}

-(NSArray *)ConnectedPeers
{
    return [self.session connectedPeers];
}

-(void)showPeerBrowserWithViewController:(UIViewController *)viewController
                                delegate:(id<MultiplayerDelegate>)theDelegate
{
    self.delegate = theDelegate;
    self.isHost = YES;
    NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    self.session = [[MCSession alloc]initWithPeer:self.myPeerID];
    self.session.delegate = self;
    
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
        
        if([self.delegate respondsToSelector:@selector(readyToStartMatch)]){
            [self.delegate readyToStartMatch];
        }
        
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
    [self.session disconnect];
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch(state){
        case MCSessionStateConnected:
            NSLog(@"Peer %@ connected", peerID.displayName);
            
            if([self.delegate respondsToSelector:@selector(peerConnected:)] && !self.isHost){
                [self.delegate peerConnected:(NSString *)peerID.displayName];
            }
            break;
        case MCSessionStateNotConnected:
            NSLog(@"Peer %@ disconnected.", peerID.displayName);
            if([[self.session connectedPeers] count] == 0)
            {
                NSLog(@"No more peers connected... Ending Session");
                [self.session disconnect];
                if([self.delegate respondsToSelector:@selector(matchEnded)]){
                    [self.delegate matchEnded];
                }
                
                self.session = nil;
            }
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
        
        NSLog(@"Received Message from Type %i from %@", message.messageType, peerID);
        
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
                    return;
                }
                break;
            case matchStarted:
                if([self.delegate respondsToSelector:@selector(matchStarted)])
                {
                    [self.delegate matchStarted];
                    return;
                }
                break;
            case matchEnded:
                self.isMatchActive = false;
                [self.session disconnect];
                self.session = nil;
                if([self.delegate respondsToSelector:@selector(matchEnded)])
                {
                    [self.delegate matchEnded];
                    return;
                }
                break;
            default:
                break;
        }
        
        if([self.delegate respondsToSelector:@selector(receivedMessage:fromPlayerID:)])
        {
            [self.delegate receivedMessage:(Message *)receivedMessage fromPlayerID:peerID];
        }
    }
    
    
}

-(bool)sendMessage:(Message *)message
{
    NSLog(@"Send Message: %i", message.messageType);
    NSError *error;
    NSData *data =   [NSKeyedArchiver archivedDataWithRootObject:message];
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
