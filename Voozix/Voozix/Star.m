//
//  Star.m
//  Voozix
//
//  Created by K!N on 1/3/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Star.h"
@interface Star()
@property float scale;
@property float maxScale;
@property float minScale;
@property float maxRotation;
@property float minRotation;
@property float scaleIncrement;
@property float rotationIncrement;
@end

@implementation Star

- (id) init {
    
    if (self = [super init]) {
        self = [Star spriteNodeWithImageNamed:@"star"];
        [self setup];
    }
    return self;
}

- (void) setup {
    
    self.name = @"star";
    self.scale = 1.0;
    self.maxScale = 1.2;
    self.minScale = 0.8;
    self.maxRotation = 0.5;
    self.minRotation = -0.5;
    self.scaleIncrement = 0.02;
    self.rotationIncrement = 0.01;
}

-(void)update:(CFTimeInterval)currentTime {
    
    [self scale:currentTime];
    [self rotate:currentTime];

}

- (void)scale:(CFTimeInterval)currentTime {
    
    if (self.scale >= self.maxScale) {
        self.scaleIncrement = -0.02;
    }
    
    if (self.scale <= self.minScale) {
        self.scaleIncrement = 0.02;
    }
    
    SKAction *scale = [SKAction scaleTo:self.scale duration:0.1/currentTime];
    self.scale += self.scaleIncrement;
    [self runAction:scale];
}

- (void)rotate:(CFTimeInterval)currentTime {
    
    if (self.zRotation >= self.maxRotation) {
        self.rotationIncrement = -0.01;
    }
    
    if (self.zRotation <= self.minRotation) {
        self.rotationIncrement = 0.01;
    }
    
    SKAction *rotate = [SKAction rotateByAngle:self.rotationIncrement duration:0.1/currentTime];
    self.zRotation += self.rotationIncrement;
    [self runAction:rotate];
}

- (void)changePosition:(CGRect)rect {

    float x = (arc4random() % (int)rect.size.width);
    float y = (arc4random() % (int)rect.size.height);
    
    if (x + self.frame.size.width/2 > rect.size.width)
        x -= self.frame.size.width/2;
    else if (x - self.frame.size.width/2 < 0)
        x += self.frame.size.width/2;
    
    if (y + self.frame.size.height/2 > rect.size.height )
        y -= self.frame.size.height/2;
    else if (y - self.frame.size.height/2 < 0)
        y += self.frame.size.width/2;
    
    
    CGPoint newPosiion = CGPointMake(x, y);
    
    self.position = newPosiion;
    
}






@end
