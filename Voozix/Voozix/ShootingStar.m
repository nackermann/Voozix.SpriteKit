//
//  ShootingStar.m
//  Voozix
//
//  Created by K!N on 1/17/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

static const CGFloat MAX_SCALE = 1.2;
static const CGFloat MIN_SCALE = 0.8;
static const CGFloat SCALE_DURATION = 1.0;
static const CGFloat SPEED = 280.0;


#import "ShootingStar.h"
#import "ObjectCategories.h"
#import "Player.h"

@interface ShootingStar()
@property CGVector velocity;
@property (nonatomic, strong) SKEmitterNode *trail;
@property (nonatomic, weak) SKScene *screenBounds;
@end


@implementation ShootingStar

- (SKEmitterNode *)trail {
    
    if (!_trail) {
        _trail = [[SKEmitterNode alloc] init];
    }
    
    return _trail;
}

- (id)initWithScene:(SKScene *)scene {
    
    if (self = [super init]) {
        
        self.screenBounds = scene;
        self.texture = [SKTexture textureWithImageNamed:@"star"];
        self.size = self.texture.size;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.categoryBitMask = STAR_OBJECT;
        self.physicsBody.collisionBitMask = STAR_OBJECT;
        self.physicsBody.contactTestBitMask = PLAYER_OBJECT;
        [self setup];
        
    }

    return self;
}

- (void)setup {
    
    self.name = @"shootingstar";
//    self.xScale = MIN_SCALE;
//    self.yScale = MIN_SCALE;
    self.zPosition = 1;
    
//    SKAction *scaleLarge = [SKAction scaleTo:MAX_SCALE duration:SCALE_DURATION];
//    SKAction *scaleSmall = [SKAction scaleTo:MIN_SCALE duration:SCALE_DURATION];
    //[self runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaleLarge, scaleSmall]]]];
    
    NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"StarTrail" ofType:@"sks"];
    self.trail = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
    self.trail.position = self.position;
    self.trail.particleColorRedRange = 0.5;
    self.trail.zPosition = -1;
    [self addChild:self.trail];
    
    [self createPath];
    
}


- (void)createPath {
    
    CGPoint startPoint;
    CGPoint endPoint;
    
    int value = arc4random() % 4;
    
    switch (value) {
            
        case 0:
            startPoint = CGPointMake(-self.size.width/2, arc4random() % (int)self.screenBounds.frame.size.height);
            endPoint = CGPointMake(self.screenBounds.frame.size.width + self.size.height/2, arc4random() % (int)self.screenBounds.frame.size.height);
            break;
            
        case 1:
            startPoint = CGPointMake(self.screenBounds.frame.size.width + self.size.height/2, arc4random() % (int)self.screenBounds.frame.size.height);
            endPoint = CGPointMake(-self.size.width/2, arc4random() % (int)self.screenBounds.frame.size.height);
            break;
            
        case 2:
            startPoint = CGPointMake(arc4random() % (int)self.screenBounds.frame.size.width, self.screenBounds.frame.size.height + self.size.height/2);
            endPoint = CGPointMake(arc4random() % (int)self.screenBounds.frame.size.width, -self.size.height/2);            break;

        case 3:
            startPoint = CGPointMake(arc4random() % (int)self.screenBounds.frame.size.width, -self.size.height/2);
            endPoint = CGPointMake(arc4random() % (int)self.screenBounds.frame.size.width, self.screenBounds.frame.size.height + self.size.height/2);
            break;
            
        default:
            break;
    }
    
    
    self.position = startPoint;
    self.physicsBody.velocity = [self createVeloctyFromPoint:startPoint and:endPoint];
    
    float trailAngle = atan2(-self.physicsBody.velocity.dy, -self.physicsBody.velocity.dx);
    self.trail.emissionAngle = trailAngle;
    self.trail.emissionAngleRange = 0.8;
    
    
    
}

- (CGVector)createVeloctyFromPoint:(CGPoint)startPoint and:(CGPoint)endPoint {
    
    CGVector velocity = CGVectorMake(endPoint.x- startPoint.x, endPoint.y - startPoint.y);
    
    float vectorLength = sqrt(pow(velocity.dx, 2) + pow(velocity.dy, 2));
    
    velocity.dx /= vectorLength;
    velocity.dy /= vectorLength;
    
    velocity.dx *= SPEED;
    velocity.dy *= SPEED;
    
    return velocity;
}


- (void)update:(CFTimeInterval)currentTime {
    
    
    
    
}

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        [self removeFromParent];
    }
}


@end
