//
//  HUDManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "HUDManager.h"

@interface HUDManager()
// View
@property (nonatomic,strong) SKLabelNode *myScoreLabel;

@property (nonatomic, weak) SKScene *myScene;
@property (nonatomic,assign) int myScore;
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
        _myScoreLabel.fontSize = 30;
        CGPoint testPos = CGPointMake(CGRectGetMinX(self.myScene.frame)+100, CGRectGetMinY(self.myScene.frame)+30); // aus dem frame spaeter berechnen
        _myScoreLabel.position = testPos;
        [self.myScene addChild:self.myScoreLabel];
        
        // Score belongs to the label
        self.myScore = 0;
        
    }
    return _myScoreLabel;
}

- (void)update
{
    // pooling, wichtig erst nach den Kollisionen!
    
    // self.myScore updaten
    
    // LabelView updaten, nur updaten bei Veraenderung, aendern !
    self.myScoreLabel.text = [NSString stringWithFormat:@"%@%d", @"Score: ", self.myScore];

}

@end
