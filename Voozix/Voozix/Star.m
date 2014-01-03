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
    //NSLog(@"%g, %g", self.xScale, self.scale);
    [self runAction:scale];
}

- (void)rotate:(CFTimeInterval)currentTime {
    
    if (self.zRotation >= 0.5) {
        self.rotationIncrement = -0.01;
    }
    
    if (self.zRotation <= -0.5) {
        self.rotationIncrement = 0.01;
    }
    
    SKAction *rotate = [SKAction rotateByAngle:self.rotationIncrement duration:0.1/currentTime];
    self.zRotation += self.rotationIncrement;
    //NSLog(@"%g", self.zRotation);
    
    [self runAction:rotate];
}

- (void)changePosition:(CGRect)rect {

    float x = (arc4random() % (int)rect.size.width);
    float y = (arc4random() % (int)rect.size.height);

    
//    NSLog(@"%g, %g", self.position.x, self.position.y);
//    float y = 1024;
//    float x = 768;
    
    CGPoint newPosiion = CGPointMake(x, y);
    
    self.position = newPosiion;
    
}






@end
