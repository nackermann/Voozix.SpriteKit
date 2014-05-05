//
//  PowerUp.m
//  Voozix
//
//  Created by Norman Ackermann on 13.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const int spawnChance = 0;

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define IPHONE_SCALE_FACTOR isiPad ? 1.0f : 0.6f

#import "PowerUp.h"

@interface PowerUp()

@end

@implementation PowerUp

- (id)init
{
    self = [super init];
    
    self.texture = [SKTexture textureWithImageNamed:@"spark"];
    CGSize scaledSize;
    CGFloat width = self.texture.size.width;
    CGFloat height = self.texture.size.height;
    width *= IPHONE_SCALE_FACTOR;
    height *= IPHONE_SCALE_FACTOR;
    scaledSize.width = width;
    scaledSize.height = height;
    self.size = scaledSize;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:scaledSize.width/2];
	self.physicsBody.categoryBitMask = POWERUP_OBJECT;
    self.physicsBody.collisionBitMask = PLAYER_OBJECT;
    self.physicsBody.contactTestBitMask = PLAYER_OBJECT;
    self.physicsBody.restitution = 0.0;
	self.physicsBody.allowsRotation = NO;
    
    return self;
}

- (void)didBeginContactWith:(id)object
{
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

+ (NSNumber*)chanceToSpawn
{
    return [NSNumber numberWithInt:spawnChance];
}


@end
