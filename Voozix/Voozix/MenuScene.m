//
//  MenuScene.m
//  Voozix
//
//  Created by K!N on 1/11/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "MenuScene.h"
#import "MyScene.h"

@interface MenuScene()
@property (nonatomic, strong) SKLabelNode *title;
@property (nonatomic, strong) SKLabelNode *playButton;
@property (nonatomic, strong) SKLabelNode *optionsButton;
@end




@implementation MenuScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self addChild:self.title];
        [self addChild:self.playButton];
        [self addChild:self.optionsButton];
        
        
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
    
    if (node == self.playButton) {
        
        SKView * skView = (SKView *)self.view;
        MyScene *myScene = [MyScene sceneWithSize:skView.bounds.size];
        myScene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:myScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
    }else if (node == self.optionsButton) {
        
        NSLog(@"%@", @"options button pressed and do some shit!");
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
        _title.text = @"VOOZIX";
        _title.fontColor = [SKColor yellowColor];
        _title.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.height/8);
    }
    
    return _title;
}

- (SKLabelNode *)playButton {
    
    if (!_playButton) {
        _playButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        _playButton.fontSize = 50;
        _playButton.text = @"PLAY";
        _playButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.height/3);
    }
    
    return _playButton;
}

- (SKLabelNode *)optionsButton {
    
    if (!_optionsButton) {
        _optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
        _optionsButton.fontSize = 50;
        _optionsButton.text = @"OPTIONS";
        _optionsButton.position = CGPointMake(self.frame.size.width/2, self.playButton.position.y - self.frame.size.height/5);
    }
    
    return _optionsButton;
}




@end
