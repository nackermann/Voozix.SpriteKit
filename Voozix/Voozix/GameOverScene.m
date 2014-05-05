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

@interface GameOverScene()
@property (strong, nonatomic) NSNumber *captionFontSize;
@property (strong, nonatomic) NSNumber *normalFontSize;

@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self createTitle];
        [self createScore];
        [self createRetryButton];
        [self createQuitButton];
        
        
    }
    return self;
}

- (NSNumber*)captionFontSize
{
    if (!_captionFontSize)
    {
        
        _captionFontSize = [[NSNumber alloc] initWithFloat:isiPad ? CAPTION_FONT_SIZE : CAPTION_FONT_SIZE/2.f];
    }
    
    return _captionFontSize;
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
    title.text = @"GAME OVER";
    title.fontColor = [SKColor yellowColor];
    title.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.height/8);
    
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
    
}

@end
