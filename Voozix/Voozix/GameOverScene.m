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

@interface GameOverScene()
@property (nonatomic, strong) SKLabelNode *title;
@property (nonatomic, strong) SKLabelNode *score;
@property (nonatomic, strong) SKLabelNode *retryButton;
@property (nonatomic, strong) SKLabelNode *quitButton;
@end

@implementation GameOverScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self addChild:self.title];
        [self addChild:self.score];
        [self addChild:self.retryButton];
        [self addChild:self.quitButton];
        
        
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
    
    if (node == self.retryButton) {
        
        SKView * skView = (SKView *)self.view;
        MyScene *myScene = [MyScene sceneWithSize:skView.bounds.size];
        myScene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:myScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
    }else if (node == self.quitButton) {
        
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

-(void)update:(NSTimeInterval)currentTime {
    
    
}

- (SKLabelNode *)title {
    
    if (!_title) {
        _title = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        _title.fontSize = 70;
        _title.text = @"THANK YOU FOR PLAYING!";
        _title.fontColor = [SKColor yellowColor];
        _title.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.height/8);
    }
    
    return _title;
}

- (SKLabelNode *)score {
    
    if (!_score) {
        _score = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        _score.fontSize = 50;
        _score.text = @"Your Score:";
        _score.position = CGPointMake(self.frame.size.width/2, self.title.position.y - self.frame.size.height/5);
    }
    
    return _score;
}

- (SKLabelNode *)retryButton {
    
    if (!_retryButton) {
        _retryButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        _retryButton.fontSize = 50;
        _retryButton.text = @"RETRY";
        _retryButton.position = CGPointMake(self.frame.size.width/2, self.score.position.y - self.frame.size.height/5);
    }
    
    return _retryButton;
}
- (SKLabelNode *)quitButton {
    
    if (!_quitButton) {
        _quitButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        _quitButton.fontSize = 50;
        _quitButton.text = @"QUIT";
        _quitButton.position = CGPointMake(self.frame.size.width/2, self.retryButton.position.y - self.frame.size.height/5);

    }
    
    return _quitButton;
}
@end
