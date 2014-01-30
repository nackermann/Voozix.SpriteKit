//
//  MenuScene.m
//  Voozix
//
//  Created by K!N on 1/11/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "MenuScene.h"
#import "MyScene.h"
#import "PeerToPeerManager.h"

@interface MenuScene()
@property (nonatomic, strong)SKLabelNode *waitingForHostLabel;
@end

@implementation MenuScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self createTitle];
        [self createPlayButton];
        [self createPeerToPeerButton];
        [self CreateStartAdvertisePeerButton];
    }
    return self;
}

/**
 * This gets called when a touch begins and then notifies all objects
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:position];
    
    if ([node.name isEqualToString:@"play"]) {
        
        if([PeerToPeerManager sharedInstance].advertiserIsAdvertising){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Advertiser is running!" message:@"You are advertising yourself. Do you want to continue and stop advertising yourself?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }else{
            [self readyToStartMatch];
        }
        
    }else if ([node.name isEqualToString:@"options"]) {
        
        NSLog(@"%@", @"options button pressed and do some shit!");
    }else if([node.name isEqualToString:@"startadvertise"]){
        
        [node removeFromParent];
        [self CreateStopAdvertisePeerButton];
        [[PeerToPeerManager sharedInstance] startAdvertisingWithDelegate:self];
        
    }else if([node.name isEqualToString:@"stopadvertise"]){
        
        [node removeFromParent];
        [self CreateStartAdvertisePeerButton];
        [self.waitingForHostLabel removeFromParent];
        [[PeerToPeerManager sharedInstance]stopAdvertising];
        
        
        
    }else if([node.name isEqualToString:@"peertopeer"]){
        [[PeerToPeerManager sharedInstance] showPeerBrowserWithViewController :self.view.window.rootViewController delegate:self];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex !=0)
    {
        [[PeerToPeerManager sharedInstance] stopAdvertising];
        [self readyToStartMatch];
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

-(void)readyToStartMatch
{
    SKView * skView = (SKView *)self.view;
    MyScene *myScene = [MyScene sceneWithSize:skView.bounds.size];
    
    [PeerToPeerManager sharedInstance].delegate = myScene;
    
    myScene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:myScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
}

-(void)peerConnected:(NSString *)peerName{
    if( ![PeerToPeerManager sharedInstance].isHost && (!self.waitingForHostLabel || (self.waitingForHostLabel && !self.waitingForHostLabel.parent)))
    {
        self.waitingForHostLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        self.waitingForHostLabel.fontSize = 30;
        self.waitingForHostLabel.text = @"Waiting for Host, to start match";
        self.waitingForHostLabel.fontColor = [SKColor yellowColor];
        self.waitingForHostLabel.position = CGPointMake(CGRectGetMidX(self.frame), 100);
        [self addChild:self.waitingForHostLabel];
    }
    
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

-(void)CreateStartAdvertisePeerButton{
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    optionsButton.fontSize = 50;
    optionsButton.name = @"startadvertise";
    optionsButton.text = @"ADVERTISE PEER";
    optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 3 * self.frame.size.height/7);
    
    [self addChild:optionsButton];
    
}

-(void)CreateStopAdvertisePeerButton{
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    optionsButton.fontSize = 50;
    optionsButton.name = @"stopadvertise";
    optionsButton.text = @"STOP ADVERTISING";
    optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 3 * self.frame.size.height/7);
    
    [self addChild:optionsButton];
    
}

-(void)createPeerToPeerButton{
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    optionsButton.fontSize = 50;
    optionsButton.name = @"peertopeer";
    optionsButton.text = @"PEER TO PEER MULTIPLAYER";
    optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 4 * self.frame.size.height/7);
    
    [self addChild:optionsButton];
    
}

@end
