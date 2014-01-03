//
//  HUDManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "HUDManager.h"

#define FONTSIZE 30
#define LABELXOFFSET 100
#define LABELYOFFSET 30

@interface HUDManager()
@property (nonatomic, weak) SKScene *myScene;
@property (nonatomic, strong) SKLabelNode *myScoreLabel;
@end

@implementation HUDManager

- (id)initWithScene:(SKScene*)scene
{
    self = [super init];
    
    self.myScene = scene;
    
    return self;
}

- (SKLabelNode*)myScoreLabel
{
    if (_myScoreLabel == nil) {
        _myScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _myScoreLabel.fontSize = FONTSIZE;
        CGPoint testPos = CGPointMake(CGRectGetMinX(self.myScene.frame)+LABELXOFFSET, CGRectGetMinY(self.myScene.frame)+LABELYOFFSET);
        _myScoreLabel.position = testPos;
        
        if (self.myScene) {
            [self.myScene addChild:self.myScoreLabel];
        }
        else
        {
            NSLog(@"%@", @"HUDManager: There is no scene where I can render");
        }
        
    }
    return _myScoreLabel;
}

- (void)update
{
    // pooling, wichtig erst nach den Kollisionen!
    
    // self.myScore updaten
    
    // LabelView updaten, nur updaten bei Veraenderung, aendern !!!!!
    //if (das was ich hab != das was der player hat) {
        self.myScoreLabel.text = [NSString stringWithFormat:@"%@%d", @"Score: ", 30]; // 30 ist stub bis richtig Kommuniziert wird
    //}
    
}

@end
