//
//  EnemyBall.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "EnemyBall.h"
static const uint32_t sprite1Category = 0x1 << 0;
static const uint32_t sprite2Category = 0x1 << 1;


@implementation EnemyBall
- (id)init {
    
    if (self = [super init]) {
        self.texture = [SKTexture textureWithImageNamed:@"enemy"];
        self.size = self.texture.size;
//        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
//        self.physicsBody.categoryBitMask = sprite2Category;
//        self.physicsBody.collisionBitMask = sprite1Category;
//        self.physicsBody.contactTestBitMask = sprite1Category;
        [self setup];
    }
    
    return self;
}

- (id)initAtPosition:(CGPoint)position {
    
    if (self = [super init]) {
        self.texture = [SKTexture textureWithImageNamed:@"enemy"];
        self.position = position;
        self.size = self.texture.size;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = sprite2Category;
        self.physicsBody.collisionBitMask = sprite1Category;
        self.physicsBody.contactTestBitMask = sprite1Category;
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
