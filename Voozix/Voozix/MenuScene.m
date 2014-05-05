//
//  MenuScene.m
//  Voozix
//
//  Created by K!N on 1/11/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#import "MenuScene.h"
#import "MyScene.h"

#define CAPTION_FONT_SIZE 70.f
#define NORMAL_FONT_SIZE 50.f
#define IPHONE_SCALE_FACTOR 0.6f

@interface MenuScene()
@property (strong, nonatomic) NSNumber *captionFontSize;
@property (strong, nonatomic) NSNumber *normalFontSize;

@end

@implementation MenuScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self createTitle];
        [self createPlayButton];
        [self createOptionsButton];
        
        
    }
    return self;
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
    
    if ([node.name isEqualToString:@"play"]) {
        
        SKView * skView = (SKView *)self.view;
        MyScene *myScene = [MyScene sceneWithSize:skView.bounds.size];
        myScene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:myScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
    }else if ([node.name isEqualToString:@"options"]) {
        
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

- (void)createTitle {
    
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    title.fontSize = self.captionFontSize.floatValue;
    title.text = @"VOOZIX";
    title.fontColor = [SKColor yellowColor];
    title.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.height/8);
    
    [self addChild:title];
    
}

- (void)createPlayButton {
    
    SKLabelNode *playButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    playButton.fontSize = self.normalFontSize.floatValue;
    playButton.name = @"play";
    playButton.text = @"PLAY";
    playButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 2 * self.frame.size.height/7);
    
    [self addChild:playButton];
    
}

- (void)createOptionsButton {
    
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    optionsButton.fontSize = self.normalFontSize.floatValue;
    optionsButton.name = @"options";
    optionsButton.text = @"OPTIONS";
    optionsButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 3 * self.frame.size.height/7);
    
    [self addChild:optionsButton];
    
}



@end
