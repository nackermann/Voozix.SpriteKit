//
//  MyScene.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "MyScene.h"
#import "Star.h"
#import "HUDManager.h"
#import "Player.h"

@interface MyScene()
@property (nonatomic,strong) HUDManager *myHUDManager;
@property (nonatomic,strong) Player *myPlayer;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        CGPoint myPoint = CGPointMake(0.f, 0.f);
        backgroundSprite.anchorPoint = myPoint;
        backgroundSprite.position = myPoint;
        
        Star *star = [[Star alloc] init];
        star.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        self.myPlayer = [[Player alloc] init];
        self.myPlayer.position = CGPointMake(self.frame.size.width/2+50, self.frame.size.height/2+50);
    
        
        
        [self addChild:backgroundSprite];
        [self addChild:star];
        [self addChild:self.myPlayer];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // An einen Input Manager weitergeben?
    
    for (UITouch *touch in touches) {
        /*CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];*/
        

        
        // hier muss einiges geaendert werden!
        CGPoint position = [touch locationInNode:self];
        
        Star *star = (Star *)[self nodeAtPoint:position];
        if ([star.name isEqualToString:@"star"]) {
            [star changePosition:self.frame];
        }
        else
        {
            [self.myPlayer moveToPosition:position];
        }

    }
}

- (HUDManager*)myHUDManager
{
    if (_myHUDManager == nil) {
        _myHUDManager = [[HUDManager alloc] initWithScene:self];
    }
    return _myHUDManager;
}


-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    // Update all managers
    [self.myHUDManager update];
}

@end
