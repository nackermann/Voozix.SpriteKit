//
//  MultiplayerManager.m
//  Voozix
//
//  Created by VM on 14.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "GameCenterManager.h"

@interface GameCenterManager()
@property (nonatomic)bool userIsAuthenticated;
@property (nonatomic, strong)NSArray *pendingPlayersToInvite;
@property (nonatomic)bool matchStarted;
@property (nonatomic, strong)GKInvite* pendingInvite;
@end

@implementation GameCenterManager

static GameCenterManager *sharedMultiplayerManger = nil;

/**
 * @brief Returns  and Optionally Creates an Singlton Instance of the Manager
 * @details [long description]
 *
 * @return [description]
 */
+(GameCenterManager *)sharedInstance
{
    if(!sharedMultiplayerManger){
        sharedMultiplayerManger = [[GameCenterManager alloc] init];
    }
    return sharedMultiplayerManger;
}

/**
 * @brief Inits and add Observer to NotificationCenter
 * @details [long description]
 *
 * @return [description]
 */
-(id)init{
    self = [super init];
    if(self){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(authenticationChanged)
                   name:GKPlayerAuthenticationDidChangeNotificationName
                 object:nil];
    }
    return self;
}

/*
-(bool)gameCenterisAvailable
{
    return self.userIsAuthenticated;
}
*/

/**
 * @brief Handles if authentication Changed
 * @details [long description]
 *
 */
-(void)authenticationChanged
{
    if([GKLocalPlayer localPlayer].isAuthenticated && !self.userIsAuthenticated){
        
        NSLog(@"Player authenticated");
        
        [[GKLocalPlayer localPlayer] registerListener:self];
        /*
        [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
            NSLog(@"Received invite on deprecated Method");
            self.pendingInvite = acceptedInvite;
            self.pendingPlayersToInvite = playersToInvite;
            [self.delegate inviteReceived];
        };
        */
        //To be sure, only one listener
        [[GKLocalPlayer localPlayer] unregisterListener:self];
        [[GKLocalPlayer localPlayer] registerListener:self];
        
    }else if(![GKLocalPlayer localPlayer].isAuthenticated && self.userIsAuthenticated){
        NSLog(@"Player nolonger authenticated");
    }
    self.userIsAuthenticated =  [GKLocalPlayer localPlayer].isAuthenticated;
    
}

-(void)authenticateLocalUser {
    NSLog(@"Authenticating local user ...");
    
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error){
        
        if (viewController != nil)
        {
            NSLog(@"viewController != nil");
            
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            
        }
        else if ([GKLocalPlayer localPlayer].isAuthenticated)
        {
            NSLog(@"localPlayer already authenticated");
            //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
        }
        else
        {
            NSLog(@"local player not authenticated");
            self.userIsAuthenticated = false;
            
        }
    };
}

-(void)findMatchWithMinPlayers:(int)minPlayers
                    maxPlayers:(int)maxPlayers
                viewController:(UIViewController *)viewController
                      delegate:(id<MultiplayerDelegate>)theDelegate
{
    self.viewController = viewController;
    self.matchStarted = NO;
    self.match = nil;
    self.delegate = theDelegate;
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    GKMatchmakerViewController *mmvc;
    
    if(self.pendingPlayersToInvite != nil){  //Compare against Invite
        mmvc = [[GKMatchmakerViewController alloc] initWithInvite:self.pendingInvite]; //ToDo get the Invite?!
        
    }else{
        GKMatchRequest *request = [[GKMatchRequest alloc]init];
        request.minPlayers = minPlayers;
        request.maxPlayers = maxPlayers;
        request.playersToInvite = self.pendingPlayersToInvite;
        
        mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    }
    
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
    //Clear Invite
    
}

- (void)lookupPlayers {
    
    NSLog(@"Looking up %d players...", self.match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:self.match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            self.matchStarted = NO;
            [self.delegate matchEnded];
        } else {
        
            // Populate players dict
            self.playerDictonary = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                [self.playerDictonary setObject:player forKey:player.playerID];
            }
            
            // Notify delegate match can begin
            self.matchStarted = YES;
            [self.delegate matchStarted];
            
        }
    }];
    
}

#pragma mark GKMatchMakerViewControllerDelegate

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"User cancelled matchmaking");
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    NSLog(@"Found peer-to-peer match!");
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    self.match = match;
    self.match.delegate = self;
    
    if(!self.matchStarted && self.match.expectedPlayerCount == 0){
        NSLog(@"Ready to start the Game");
        [self lookupPlayers];
    }
}
//Hosted game
-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs
{
    NSLog(@"Found an hosted game");
}

-(bool)sendMessage:(Message *)message
{
    NSError *error;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(message)];
    return [self.match sendDataToAllPlayers:data withDataMode:GKSendDataReliable error:&error];
}
#pragma mark GKMatchDelegate

-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    if(self.match != match) return; //Any other match
    
    id receivedMessage = [data bytes];
    
    if([receivedMessage isKindOfClass:[Message class]]) [self.delegate receicedMessage:(Message *)receivedMessage fromPlayerID:playerID];
}


//Player state changed ( (dis)connected)
-(void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    if(self.match != match) return;
    
    switch (state) {
        case GKPlayerStateConnected:
            NSLog(@"A Player has connected.");
            if(!self.matchStarted && match.expectedPlayerCount == 0){
                NSLog(@"Ready to start match");
                [self lookupPlayers];
            }
            break;
        case GKPlayerStateDisconnected:
            NSLog(@"A Player has disconnected");
            self.matchStarted = NO;
            [self.delegate matchEnded];
            break;
        default:
            break;
    }
}

-(void)match:(GKMatch *)match didFailWithError:(NSError *)error
{
    if(self.match != match) return; //Other match
    
    NSLog(@"Match failed. Error Message: %@", error.localizedDescription);
    self.matchStarted = NO;
    [self.delegate matchEnded];
}


-(void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite
{
    NSLog(@"%@ accepted invite", player.playerID);
}

-(void)player:(GKPlayer *)player didRequestMatchWithPlayers:(NSArray *)playerIDsToInvite
{
    NSLog(@"%@ requested a match", player.playerID);
    
}

@end
