//
//  GameOverScene.m
//  Voozix
//
//  Created by K!N on 1/12/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"
#import "MenuScene.h"

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define CAPTION_FONT_SIZE 70.f
#define NORMAL_FONT_SIZE 50.f
#define IPHONE_SCALE_FACTOR 0.6f
#define LABEL_X_OFFSET 210.f
#define LABEL_Y_OFFSET 30.f

@interface GameOverScene()
@property (strong, nonatomic) NSNumber *captionFontSize;
@property (strong, nonatomic) NSNumber *normalFontSize;
@property (nonatomic, strong) NSNumber *labelXOffset;
@property (nonatomic, strong) NSNumber *labelYOffset;

@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self createTitle];
        [self createScore];
        [self createRetryButton];
        [self createQuitButton];
        [self createHighscore];
        
    }
    return self;
}

- (NSNumber*)labelXOffset
{
    if (!_labelXOffset)
    {
        _labelXOffset = [[NSNumber alloc] initWithFloat:isiPad ? LABEL_X_OFFSET : LABEL_X_OFFSET*IPHONE_SCALE_FACTOR];
    }
    
    return _labelXOffset;
}

- (NSNumber*)labelYOffset
{
    if (!_labelYOffset)
    {
        _labelYOffset = [[NSNumber alloc] initWithFloat:isiPad ? LABEL_Y_OFFSET : LABEL_Y_OFFSET*IPHONE_SCALE_FACTOR];
    }
    
    return _labelYOffset;
}

- (NSNumber*)captionFontSize
{
    if (!_captionFontSize)
    {
        
        _captionFontSize = [[NSNumber alloc] initWithFloat:isiPad ? CAPTION_FONT_SIZE : CAPTION_FONT_SIZE*IPHONE_SCALE_FACTOR];
    }
    
    return _captionFontSize;
}

- (NSNumber*)normalFontSize
{
    if (!_normalFontSize)
    {
        _normalFontSize = [[NSNumber alloc] initWithFloat:isiPad ? NORMAL_FONT_SIZE : NORMAL_FONT_SIZE*IPHONE_SCALE_FACTOR];
    }
    
    return _normalFontSize;
}

/**
 * This gets called when a touch begins and then notifies all objects
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:position];
    
    if ([node.name isEqualToString:@"retry"]) {
        
        SKView * skView = (SKView *)self.view;
        MyScene *myScene = [MyScene sceneWithSize:skView.bounds.size];
        myScene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:myScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
    }else if ([node.name isEqualToString:@"quit"]) {
        
        SKView * skView = (SKView *)self.view;
        MenuScene *menuScene = [MenuScene sceneWithSize:skView.bounds.size];
        menuScene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:menuScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
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


- (void)createScore {
    
    SKLabelNode *score= [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    score.fontSize = self.normalFontSize.floatValue;
    score.name =  @"score";
    score.text = [NSString stringWithFormat: @"YOUR SCORE: %i", self.score];
    score.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 2 * self.frame.size.height/7);
    
    [self addChild:score];
    
}

- (void)createRetryButton{
    
    SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    retryButton.fontSize = self.normalFontSize.floatValue;
    retryButton.name = @"retry";
    retryButton.text = @"RETRY";
    retryButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 3 * self.frame.size.height/7);
    
    [self addChild:retryButton];
    
}

- (void)createQuitButton {
    
    SKLabelNode *quitButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    quitButton.fontSize = self.normalFontSize.floatValue;
    quitButton.name = @"quit";
    quitButton.text = @"QUIT";
    quitButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 4 * self.frame.size.height/7);
    
    [self addChild:quitButton];
    
}

- (void)createTitle {
    
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    title.fontSize = self.captionFontSize.floatValue;
    title.name = @"title";
    title.text = @"";
    title.fontColor = [SKColor yellowColor];
    title.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.height/8);
    
    [self addChild:title];
    
}

- (void)createHighscore {
    
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    title.fontSize = self.normalFontSize.floatValue;
    title.name = @"highscore";
    int highscore = 0;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"currentHighscore"])
    {
        highscore = [[[NSUserDefaults standardUserDefaults] valueForKey:@"currentHighscore"] integerValue];
    }
    title.text = [NSString stringWithFormat: @"Highscore: %i", highscore];
    title.fontColor = [SKColor yellowColor];
    title.position = CGPointMake(CGRectGetMinX(self.frame)+self.labelXOffset.floatValue, CGRectGetMinY(self.frame)+self.labelYOffset.floatValue);
    
    [self addChild:title];
    
}

- (void)setScore:(int)score {
    
    if (_score != score) {
        _score = score;
        [self updateScore];
    }
    
}

- (void)updateScore {
    
    SKLabelNode *score = (SKLabelNode *)[self childNodeWithName:@"score"];
    score.text = [NSString stringWithFormat:@"YOUR SCORE: %i", self.score];
    
    int currentHighscore = [[[NSUserDefaults standardUserDefaults] valueForKey:@"currentHighscore"] integerValue];
    
    if (self.score > currentHighscore)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:self.score] forKey:@"currentHighscore"];
    }
    SKLabelNode *highscore = (SKLabelNode *)[self childNodeWithName:@"highscore"];
    highscore.text = [NSString stringWithFormat: @"Highscore: %i", [[[NSUserDefaults standardUserDefaults] valueForKey:@"currentHighscore"] integerValue]];
    
    SKLabelNode *rank = (SKLabelNode*)[self childNodeWithName:@"title"];
    
    if (self.score >= 50)
    {
        rank.text = @"HOLY SHITTTTT";
    }
    else if (self.score >= 45)
    {
        rank.text = @"U SRSLY DUDE?!";
    }
    else if (self.score >= 40)
    {
        rank.text = @"ARE YOU KIDDING?!";
    }
    else if (self.score >= 35)
    {
        rank.text = @"MONSTER COLLECTER";
    }
    else if (self.score >= 30)
    {
        rank.text = @"WTF, you did that?";
    }
    else if (self.score >= 25)
    {
        rank.text = @"WOW, you're GOD!";
    }
    else if (self.score >= 20)
    {
        rank.text = @"WOW, you're good";
    }
    else if (self.score >= 15)
    {
        rank.text = @"Nice one!";
    }
    else if (self.score >= 10)
    {
        rank.text = @"Well done :)";
    }
    else if (self.score >= 5)
    {
        rank.text = @"Good";
    }
    else
    {
        rank.text = @"You can do better";
    }
}

@end
