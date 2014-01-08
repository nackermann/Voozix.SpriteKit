//
//  HUDManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "HUDManager.h"
#import "Player.h"

static const CGFloat fontSize = 30;
static const CGFloat labelXOffset = 100;
static const CGFloat labelYOffset = 30;

@interface HUDManager()
@property (nonatomic, strong) SKScene *myScene;
@property (nonatomic, strong) SKLabelNode *myScoreLabelForPlayer1;
@end

@implementation HUDManager

- (id)initWithScene:(SKScene*)scene
{
    self = [super init];
    
    self.myScene = scene;
    
    return self;
}

- (NSMutableArray*)players
{
    if (_players == nil) {
        _players = [[NSMutableArray alloc] init];
    }
    return _players;
}


- (SKLabelNode*)myScoreLabelForPlayer1
{
    if (_myScoreLabelForPlayer1 == nil) {
        _myScoreLabelForPlayer1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _myScoreLabelForPlayer1.fontSize = fontSize;
        CGPoint testPos = CGPointMake(CGRectGetMinX(self.myScene.frame)+labelXOffset, CGRectGetMinY(self.myScene.frame)+labelYOffset);
        _myScoreLabelForPlayer1.position = testPos;
        
        if (self.myScene) {
            [self.myScene addChild:self.myScoreLabelForPlayer1];
        }
        else
        {
            NSLog(@"%@", @"HUDManager: There is no scene where I can render");
        }
        
    }
    return _myScoreLabelForPlayer1;
}

- (void)update
{
    
    for (Player *player in self.players) {
        self.myScoreLabelForPlayer1.text = [NSString stringWithFormat:@"%@%d", @"Score: ", [player.score intValue]];
        // Im Multiplayer dann 2 Labels in nem array und einfach hier durchgehen und updaten;
    }
    
}

@end
