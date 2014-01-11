//
//  PlayerController.m
//  Voozix
//
//  Created by K!N on 1/7/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "PlayerController.h"

static float MAX_JOYSTICK_OFFSET = 20.0;
static float VELOCITY_MULTIPLIER = 100.0;

@interface PlayerController()
@property (nonatomic, assign) SKSpriteNode *joystick;
@end
@implementation PlayerController


- (SKSpriteNode *)joystick {
    
    if (!_joystick) {
        _joystick = [SKSpriteNode spriteNodeWithImageNamed:@"joystick"];
    }
    
    return _joystick;
}

- (id)init {
    
    if (self = [super init]) {
        self.texture = [SKTexture textureWithImageNamed:@"joystickArea"];
        self.size = self.texture.size;
        
        [self addChild:self.joystick];
        
        self.hidden = YES;
    }
    
    return self;
}

/**
 * Place the joystick at the position of the touch
 * @param {NSSet   *} touches [description]
 * @param {UIEvent *} event   [description]
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self.parent];
    self.position = position;
    
    self.hidden = NO;
}

/**
 * If the finger moves during the touch, we adjust the joystick's position and calculate the speed
 * @param {NSSet   *} touches [description]
 * @param {UIEvent *} event   [description]
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if (touch.phase == UITouchPhaseMoved) {
        
        // self is passed instead of self.parent, so we get local coodinates
        CGPoint position = [touch locationInNode:self];
        
        float vectorLength = sqrt(pow(position.x, 2) + pow(position.y, 2));
        if (vectorLength > MAX_JOYSTICK_OFFSET) {
            
            position.x *= 1/vectorLength * MAX_JOYSTICK_OFFSET;
            position.y *= 1/vectorLength * MAX_JOYSTICK_OFFSET;
        }
        
        self.joystick.position = position;
        
    }
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Reset and hide joystick position
    self.joystick.position = CGPointMake(0, 0);
    self.hidden = YES;
    
    
}

- (CGVector)getJoystickVelocity {
    
    // Normally returns vector that has values between -1 and 1
    // Values are multiplied by VELOCITY_MULTIPLIER to have more "force"
    CGVector velocity = CGVectorMake(self.joystick.position.x/MAX_JOYSTICK_OFFSET *VELOCITY_MULTIPLIER , self.joystick.position.y/MAX_JOYSTICK_OFFSET *VELOCITY_MULTIPLIER);
    
    return velocity;
}






@end
