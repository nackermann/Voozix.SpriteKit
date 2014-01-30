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
@property(nonatomic, strong)MCPeerID *peerID;

@end

@implementation PeerToPeerManager

static PeerToPeerManager *sharedPeerToPeerManager = nil;
/**
 * @brief Creates and returns an singleton
 * @details Returns an Singleton of this class. If there is no instance it creates a new one.
 *
 * @return PeerToPeerManager Singleton Object
 */
+(PeerToPeerManager *)sharedInstance
{
    if(!sharedPeerToPeerManager){
        sharedPeerToPeerManager = [[PeerToPeerManager alloc] init];
    }
    return sharedPeerToPeerManager;
}

/**
 * @brief Sets the amount of players which are not ready
 * @details It sets the amount of players which are not ready. After that it checks, if all players (amount=0) are ready. If so, it tells the delegate that all connected Peers are Ready and the game can begin
 *
 * @param  waitForPlayers the left amount of Players
 */
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

/**
 * @brief  returns the Own Identification for this device
 * @details [long description]
 *
 * @return [description]
 */
-(id)myPeerID
{
    return self.peerID.displayName;
}

/**
 * @brief Returns the peerID for this device.
 * @details Optionally it also generates the ID if it is not set yet
 *
 * @return MCPeerID the current PeerID
 */
-(MCPeerID *)peerID
{
    if(!_peerID){
        NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *deviceName = [[UIDevice currentDevice] name];
        NSString *peerID = [NSString stringWithFormat:@"%@ (%@)", deviceName, deviceID];
        _peerID = [[MCPeerID alloc] initWithDisplayName: peerID];  //If you change it, you have to change it also in the MyScene!
    }
    return _peerID;
}

/**
 * @brief  Initialisation
 * @details [long description]
 *
 * @param  [description]
 * @return [description]
 */
-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}


/**
 * @brief Starts advertising and sets the delegate
 * @details This method starts the Advertising Assistant (and create it if it is not set yet). Advertising means, that other players can find this device with the MCBrowserViewController (see later)
 *
 * @param  delegate The delegate which is called, when we get an invite or something else from other connected peers.
 */
-(void)startAdvertisingWithDelegate:(id<MultiplayerDelegate>)delegate
{
    
    NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    self.session = [[MCSession alloc]initWithPeer:self.peerID];
    self.session.delegate = self;
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceName discoveryInfo:nil session:self.session];
    
    self.delegate = delegate;
    [self.advertiser start];
    self.isHost = NO;
    self.advertiserIsAdvertising = YES;
    
}

/**
 * @brief Stops the MCAdvertiser.
 * @details Stops advertising, so that other players can't find this device.
 *
 */
-(void)stopAdvertising
{
    if(self.advertiser != nil){
        [self.advertiser stop];
    }
    
    self.advertiserIsAdvertising = NO;
}

/**
 * @brief Gives the names of the Connected devices
 * @details It returns all displayNames of the connected devices
 *
 * @return NSArray the connected device-displayNames
 */
-(NSArray *)ConnectedPeers
{
    NSMutableArray *peerNames = [NSMutableArray array];
    for(MCPeerID *peerID in [self.session connectedPeers]){
        [peerNames addObject:peerID.displayName];
    }
    return peerNames;
    
    //return [self.session connectedPeers];
    
}

/**
 * @brief Shows the MCBrowserVieController and sets the delegate
 * @details This method shows the MCBrowserVieController. With this ViewController the user can find and invite other players. The user which invites is the "server" of the game and should handle all events.
 *
 * @param  viewController the viewController where the MCBrowserViewController should be displayed
 * @param  delegate the delegate for events like incoming messages, or starting the Match.
 */
-(void)showPeerBrowserWithViewController:(UIViewController *)viewController
                                delegate:(id<MultiplayerDelegate>)delegate
{
    self.delegate = delegate;
    self.isHost = YES;
    NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    self.session = [[MCSession alloc]initWithPeer:self.peerID];
    self.session.delegate = self;
    
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:serviceName session:self.session];
    self.browserVC.delegate = self;
    [viewController presentViewController:self.browserVC animated:YES completion:nil];
}


/**
 * @brief MCBrowserViewController delegate method when its finished
 * @details This method is called, when the user finished selecting players from the MCBrowserViewcontroller. It calls then the delegate, that the user is readyToStartMatch.
 *
 * @param  browserViewController the called BrowserVieController
 */
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
    if( [self.session connectedPeers] && [[self.session connectedPeers] count] > 0)
    {
        NSLog(@"Finished Selecting.... Starting the Game!");
        self.isHost = YES;
        self.isMatchActive = YES;
        self.waitForPeers = [[self.session connectedPeers] count];
        if([self.delegate respondsToSelector:@selector(readyToStartMatch)]){
            [self.delegate readyToStartMatch];
        }
        
        Message *message = [[Message alloc] init];
        message.messageType = ReadyToStartMatch;
        [self sendMessage:message];
    }
}

/**
 * @brief MCBrowserViewController delegate method when its cancelled
 * @details This method is called, when the user cancelld selecting players from the MCBrowserViewcontroller. It automatically disconnects from all players.
 *
 * @param  browserViewController the called BrowserVieController
 */
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Cancelled Selecting...");
    self.isHost = false;
    [self.session disconnect];
}

/**
 * @brief MCSession delegate method when user (dis)connected
 * @details This Method is called when an Peer is (dis)connected to this device. If so it also calls the delegate for the specific function.
 *
 * @param See documentation
 */
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
/**
 * @brief MCSession delegate when a message is received
 * @details This method received all incomming message from any peer. It then callls the delegate with the specific method (e.g. matchStarted) or generally it calls receivedMessage
 *
 * @param See documentation
 */
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
            [self.delegate receivedMessage:(Message *)receivedMessage fromPlayerID:peerID.displayName];
        }
    }
    
    
}

/**
 * @brief Sends a Message to all connected Peers
 * @details This Method sends the Message to all players. Before this can be done it will be Archived in an NSData and then send with the MCSession Method
 *
 * @param message the Message which should be send
 * @return bool if it is successfully send or not. Should be allways true, because of reliable sending.
 */
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
