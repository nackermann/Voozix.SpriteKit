//
//  HUDManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "HUDManager.h"
#import "Player.h"

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define NORMAL_FONT_SIZE 30
#define LABEL_X_OFFSET 100
#define LABEL_Y_OFFSET 30

@interface HUDManager()
@property (nonatomic, strong) NSNumber *normalFontSize;
@property (nonatomic, strong) NSNumber *labelXOffset;
@property (nonatomic, strong) NSNumber *labelYOffset;
@property (nonatomic, strong) SKScene *myScene;
@property (nonatomic, strong) SKLabelNode *myScoreLabelForPlayer1;
@end

@implementation HUDManager

/**
 * @brief Initializes the HUD Manager
 * @details [long description]
 * 
 * @param  [description]
 * @return [description]
 */
- (id)initWithScene:(SKScene*)scene
{
    self = [super init];
    
    self.myScene = scene;
    
    return self;
}

- (NSNumber*)labelXOffset
{
    if (!_labelXOffset)
    {
        _labelXOffset = [[NSNumber alloc] initWithFloat:isiPad ? LABEL_X_OFFSET : LABEL_X_OFFSET/2.f];
    }
    
    return _labelXOffset;
}

- (NSNumber*)labelYOffset
{
    if (!_labelYOffset)
    {
        _labelYOffset = [[NSNumber alloc] initWithFloat:isiPad ? LABEL_Y_OFFSET : LABEL_Y_OFFSET/2.f];
    }
    
    return _labelYOffset;
}

- (NSNumber*)normalFontSize
{
    if (!_normalFontSize)
    {
        _normalFontSize = [[NSNumber alloc] initWithFloat:isiPad ? NORMAL_FONT_SIZE : NORMAL_FONT_SIZE/2.f];
    }
    
    return _normalFontSize;
}

/**
 * Returns all player from which scores are displayed
 */
- (NSMutableArray*)players
{
    if (_players == nil) {
        _players = [[NSMutableArray alloc] init];
    }
    return _players;
}

/**
 * @brief [brief description]
 * @details [long description]
 * 
 * @param  [description]
 * @return [description]
 */
- (SKLabelNode*)myScoreLabelForPlayer1
{
    if (_myScoreLabelForPlayer1 == nil) {
        _myScoreLabelForPlayer1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _myScoreLabelForPlayer1.fontSize = self.normalFontSize.floatValue;
        CGPoint testPos = CGPointMake(CGRectGetMinX(self.myScene.frame)+self.labelXOffset.floatValue, CGRectGetMinY(self.myScene.frame)+self.labelYOffset.floatValue);
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

/**
 * @brief Updates every information on the screen
 * @details [long description]
 * 
 * @param player [description]
 * @return [description]
 */
- (void)update
{
    for (Player *player in self.players) {
        self.myScoreLabelForPlayer1.text = [NSString stringWithFormat:@"%@%d", @"Score: ", [player.score intValue]];
        // Im Multiplayer dann 2 Labels in nem array und einfach hier durchgehen und updaten;
    }
    
}

@end
