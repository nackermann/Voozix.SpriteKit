//
//  MultiplayerManager.m
//  Voozix
//
//  Created by VM on 14.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "MultiplayerManager.h"

@interface MultiplayerManager()
@property (nonatomic)bool userIsAuthenticated;
@property (nonatomic, strong)NSArray *pendingPlayersToInvite;
@property (nonatomic)bool matchStarted;
@end

@implementation MultiplayerManager

static MultiplayerManager *sharedMultiplayerManger = nil;

/**
 * @brief Returns  and Optionally Creates an Singlton Instance of the Manager
 * @details [long description]
 *
 * @return [description]
 */
+(MultiplayerManager *)sharedInstance
{
    if(!sharedMultiplayerManger){
        sharedMultiplayerManger = [[MultiplayerManager alloc] init];
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

/**
 * @brief Handles if authentication Changed
 * @details [long description]
 *
 */
-(void)authenticationChanged
{
    if([GKLocalPlayer localPlayer].isAuthenticated && self.userIsAuthenticated){
        
        NSLog(@"Player was authenticated");
        
        self.userIsAuthenticated = true;
        [[GKLocalPlayer localPlayer] registerListener:self];
        
        
    }
}

-(void)player:(GKPlayer *)player didRequestMatchWithPlayers:(NSArray *)playerIDsToInvite
{
    NSLog(@"Received Invitation from %@", player.playerID);
    [self.delegate inviteReceived];
}

-(void)authenticateLocalUser {
    NSLog(@"Authenticating local user ...");
    
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error){
        NSLog(@"authenticateHandler");
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
            NSLog(@"local player not authenticated");        }
    };
}

-(void)findMatchWithMinPlayers:(int)minPlayers
                    maxPlayers:(int)maxPlayers
                viewController:(UIViewController *)viewController
                      delegate:(id<MultiplayerManagerDelegate>)theDelegate
{
    self.matchStarted = NO;
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    GKMatchmakerViewController *mmvc;
    
    if(self.pendingPlayersToInvite != nil){  //Compare against Invite
        mmvc = [[GKMatchmakerViewController alloc] initWithInvite:nil]; //ToDo get the Invite?!
        
    }else{
        GKMatchRequest *request = [[GKMatchRequest alloc]init];
        request.minPlayers = minPlayers;
        request.maxPlayers = maxPlayers;
        request.playersToInvite = self.pendingPlayersToInvite;
        mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    }
    
    mmvc.matchmakerDelegate = self;
    [self.viewController presentViewController:mmvc animated:YES completion:nil];
    self.pendingPlayersToInvite = nil;
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
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    self.match = match;
    match.delegate = self;
    if(!self.matchStarted && match.expectedPlayerCount == 0){
        NSLog(@"Ready to start the Game");
        [self lookupPlayers];
    }
}

#pragma mark GKMatchDelegate

-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    if(self.match != match) return;
    
    [self.delegate match:match didReceiveData:data fromPlayer:playerID];
}

-(void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    if(self.match != match) return;
    
    switch (state) {
        case GKPlayerStateConnected:
            NSLog(@"A Player has connected.");
            if(!self.matchStarted && match.expectedPlayerCount == 0){
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


@end
