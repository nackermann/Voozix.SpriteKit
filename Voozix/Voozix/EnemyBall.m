//
//  EnemyBall.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "EnemyBall.h"

@implementation EnemyBall
- (id)init {
    
    if (self = [super init]) {
        self.texture = [SKTexture textureWithImageNamed:@"enemy"];
        self.size = self.texture.size;
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.name = @"enemy";
}



- (void)update:(CFTimeInterval)currentTime {
    
    CGPoint newPosition = self.position;
    newPosition.x += self.velocity.dx;
    newPosition.y += self.velocity.dy;
    
    self.position = newPosition;
    
}

@end
