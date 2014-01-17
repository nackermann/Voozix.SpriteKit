//
//  MenuScene.m
//  Voozix
//
//  Created by K!N on 1/11/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "MenuScene.h"
#import "MyScene.h"
#import "MultiplayerManager.h"
#import <GameKit/GameKit.h>
#import "PeerToPeerManager.h"

@implementation MenuScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self createTitle];
        [self createPlayButton];
        [self createOptionsButton];
        [self createPeerToPeerButton];
        [self CreateStartAdvertisePeerButton];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(authenticationChanged)
                   name:GKPlayerAuthenticationDidChangeNotificationName
                 object:nil];
        
    }
    return self;
}


-(void)authenticationChanged
{
    if([GKLocalPlayer localPlayer].isAuthenticated) [self createMultiplayerButton];
}


/**
 * This gets called when a touch begins and then notifies all objects
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:position];
    
    if ([node.name isEqualToString:@"play"]) {
        
        SKView * skView = (SKView *)self.view;
        MyScene *myScene = [MyScene sceneWithSize:skView.bounds.size];
        myScene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:myScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
    }else if ([node.name isEqualToString:@"options"]) {
        
        NSLog(@"%@", @"options button pressed and do some shit!");
    }else if([node.name isEqualToString:@"startadvertise"]){
        [[PeerToPeerManager sharedInstance] startAdvertising];
        [node removeFromParent];
        [self CreateStopAdvertisePeerButton];
        
    }else if([node.name isEqualToString:@"stopadvertise"]){
        
        [[PeerToPeerManager sharedInstance]stopAdvertising];
        
        [node removeFromParent];
        [self CreateStartAdvertisePeerButton];
    
    }else if([node.name isEqualToString:@"peertopeer"]){
        [[PeerToPeerManager sharedInstance] showPeerBrowserWithViewController :self.view.window.rootViewController delegate:nil];
    }else if([node.name isEqualToString:@"multiplayer"]){
        
        [[MultiplayerManager sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self.view.window.rootViewController delegate:nil];
    }
    
    
}

/**
 * This gets called during a touch and then notifies all objects
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

/**
 * This gets called when a touch ends and then notifies all objects
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)update:(NSTimeInterval)currentTime {
    
    
}

-(void)matchStarted
{
    
}

-(void)matchEnded
{
    
}

-(void)receicedMessage:(Message *)message fromPlayerID:(NSString *)playerID
{
    
}


- (void)createTitle {
    
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    title.fontSize = 70;
    title.text = @"VOOZIX";
    title.fontColor = [SKColor yellowColor];
    title.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.height/8);
    
    [self addChild:title];
    
}

- (void)createPlayButton {
    
    SKLabelNode *playButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    playButton.fontSize = 50;
    playButton.name = @"play";
    playButton.text = @"PLAY";
    playButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 2 * self.frame.size.height/7);
    
    [self addChild:playButton];
    
}

- (void)createOptionsButton {
    
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    optionsButton.fontSize = 50;
    optionsButton.name = @"options";
    optionsButton.text = @"OPTIONS";
    optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 3 * self.frame.size.height/7);
    
    [self addChild:optionsButton];
    
}

-(void)CreateStartAdvertisePeerButton{
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    optionsButton.fontSize = 50;
    optionsButton.name = @"startadvertise";
    optionsButton.text = @"ADVERTISE PEER";
    optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 4 * self.frame.size.height/7);
    
    [self addChild:optionsButton];
    
}

-(void)CreateStopAdvertisePeerButton{
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    optionsButton.fontSize = 50;
    optionsButton.name = @"stopadvertise";
    optionsButton.text = @"STOP ADVERTISING";
    optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 4 * self.frame.size.height/7);
    
    [self addChild:optionsButton];
    
}

-(void)createPeerToPeerButton{
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    optionsButton.fontSize = 50;
    optionsButton.name = @"peertopeer";
    optionsButton.text = @"PEER TO PEER MULTIPLAYER";
    optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 5 * self.frame.size.height/7);
    
    [self addChild:optionsButton];
    
}

- (void)createMultiplayerButton {
    
        SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        optionsButton.fontSize = 50;
        optionsButton.name = @"multiplayer";
        optionsButton.text = @"MULTIPLAYER";
        optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 6 * self.frame.size.height/7);
        [self addChild:optionsButton];
}




@end
