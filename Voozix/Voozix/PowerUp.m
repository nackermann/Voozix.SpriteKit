//
//  PowerUp.m
//  Voozix
//
//  Created by Norman Ackermann on 13.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "PowerUp.h"
#import "ObjectCategories.h"

@interface PowerUp()

@end

@implementation PowerUp

- (id)init
{
    self = [super init];
    
    self.texture = [SKTexture textureWithImageNamed:@"spark"];
	self.size = self.texture.size;
	self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
	self.physicsBody.categoryBitMask = POWERUP_OBJECT;
    self.physicsBody.contactTestBitMask = PLAYER_OBJECT;
    self.physicsBody.restitution = 0.0;
	self.physicsBody.allowsRotation = NO;
    
    self.position = CGPointMake(100.f, 200.f); // zum testen, wegmachen
    
    return self;
}

- (void)didBeginContactWith:(id)object
{
    NSLog(@"%@",@"generisch");
    [self removeFromParent];
}

- (void)update
{
    
}


@end
