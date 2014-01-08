//
//  Star.m
//  Voozix
//
//  Created by K!N on 1/3/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const CGFloat MAX_SCALE = 1.2;
static const CGFloat MIN_SCALE = 0.8;
static const CGFloat MAX_ROTATION = 0.5;
static const CGFloat MIN_ROTATION = -0.5;
static const CGFloat SCALE_DURATION = 1.0;
static const CGFloat ROTATE_DURATION = 2.0;

#import "Star.h"
#import "ObjectCategories.h"
#import "Player.h"

@implementation Star

- (id)init
{
    self = [super init];
    self.texture = [SKTexture textureWithImageNamed:@"star"];
    self.size = self.texture.size;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = STAR_OBJECT;
    //self.physicsBody.collisionBitMask = PLAYER_OBJECT;
    self.physicsBody.contactTestBitMask = PLAYER_OBJECT;
    [self setup];
    
    return self;
}

- (void)setup
{
    self.name = @"star";
    self.zRotation = MIN_ROTATION;
    self.xScale = MIN_SCALE;
    self.yScale = MIN_SCALE;
    
    SKAction *rotateRight = [SKAction rotateToAngle:MAX_ROTATION duration:ROTATE_DURATION];
    SKAction *rotateLeft = [SKAction rotateToAngle:MIN_ROTATION duration:ROTATE_DURATION];
    SKAction *scaleLarge = [SKAction scaleTo:MAX_SCALE duration:SCALE_DURATION];
    SKAction *scaleSmall = [SKAction scaleTo:MIN_SCALE duration:SCALE_DURATION];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotateRight, rotateLeft]]]];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaleLarge, scaleSmall]]]];
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

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        
        // loeschen statt physic body aendern
        
        self.physicsBody = nil;
        
        [self changePosition];
        
        // Recreate PhysicsBody
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = STAR_OBJECT;
        self.physicsBody.contactTestBitMask = PLAYER_OBJECT;
    }
}

@end
