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
    self.physicsBody.collisionBitMask = PLAYER_OBJECT;
    self.physicsBody.contactTestBitMask = PLAYER_OBJECT;
    self.physicsBody.restitution = 0.0;
	self.physicsBody.allowsRotation = NO;
    
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

- (void)changePosition
{
    /* Get random coordinates that are within the screen bounds */
    CGRect rect = [[super scene] frame];
    float x = (arc4random() % (int)rect.size.width);
    float y = (arc4random() % (int)rect.size.height);
    
    /*Take object width into consideration */
    if (x + self.frame.size.width/2 > rect.size.width)
        x -= self.frame.size.width/2;
    else if (x - self.frame.size.width/2 < 0)
        x += self.frame.size.width/2;
    
    /* Take object height into consideration */
    if (y + self.frame.size.height/2 > rect.size.height )
        y -= self.frame.size.height/2;
    else if (y - self.frame.size.height/2 < 0)
        y += self.frame.size.width/2;
    
    /* Create and set new position */
    CGPoint newPosition = CGPointMake(x, y);
    self.position = newPosition;
}

@end
