//
//  Player.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Player.h"
#import "Star.h"
#import "EnemyManager.h"
#import "ObjectCategories.h"

@interface Player()
@property (nonatomic, strong) NSNumber *myScore;
@property (nonatomic, weak) SKScene *myScene;
@end

@implementation Player

- (PlayerController *)playerController {
    
    if (!_playerController) {
        _playerController = [[PlayerController alloc] init];
        [self.parent addChild:_playerController];
    }
    
    return _playerController;
}

- (id)init
{
    self = [super init];
    self.texture = [SKTexture textureWithImageNamed:@"player"];
    self.size = self.texture.size;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = PLAYER_OBJECT;
    self.physicsBody.contactTestBitMask = ENEMY_OBJECT | STAR_OBJECT;
    self.physicsBody.allowsRotation = NO;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.playerController touchesBegan:touches withEvent:event];
    self.physicsBody.velocity = [self.playerController getJoystickVelocity];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.playerController touchesMoved:touches withEvent:event];
    self.physicsBody.velocity = [self.playerController getJoystickVelocity];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.playerController touchesEnded:touches withEvent:event];
    self.physicsBody.velocity = [self.playerController getJoystickVelocity];
    
}






// contact delegate
- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    
}

@end
