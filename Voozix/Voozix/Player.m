//
//  Player.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Player.h"

@interface Player() <SKPhysicsContactDelegate>
@property (nonatomic, strong) NSNumber *myScore;
@property (nonatomic, weak) SKScene *myScene;
@end

@implementation Player

- (id)init
{
    self = [super init];
    self.texture = [SKTexture textureWithImageNamed:@"player"];
    self.size = self.texture.size;
    [self setup];
    return self;
}

- (void)setup
{
    self.name = @"player";
    SKScene *scene = [super scene];
    self.position = CGPointMake(scene.frame.size.width/2+50, scene.frame.size.height/2+50);
}

- (NSNumber*)myScore
{
    if (_myScore == nil) {
        _myScore = [NSNumber numberWithInt:0];
    }
    return _myScore;
}


- (void)moveToPosition:(CGPoint)position
{
    [self runAction:[SKAction moveTo:position duration:0.4]];
}

// contact delegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contact between objects: %@ and %@", contact.bodyA, contact.bodyB);
}

@end
