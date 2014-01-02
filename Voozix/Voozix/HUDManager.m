//
//  HUDManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "HUDManager.h"

@implementation HUDManager

- (void)update:(id)sender
{
    //if (!self.m_score) {
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        CGPoint testPos = CGPointMake(200.f, 200.f);
        myLabel.position = testPos;
        
        
        if ([sender isKindOfClass:[SKScene class]]) {
            [sender addChild:myLabel];
        }
    //}
}

@end
