//
//  Player.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Player.h"
#import "Star.h"
#import "EnemyBall.h"
#import "ObjectCategories.h"

@interface Player()
@property (nonatomic, strong) HUDManager *myHUDManager;
@end

@implementation Player

- (PlayerController *)playerController {
    
    if (!_playerController) {
        _playerController = [[PlayerController alloc] init];
        [self.parent addChild:_playerController];
    }
    
    return _playerController;
}

- (id)initWithHUDManager:(HUDManager*)hudmanager
{
    self = [super init];
    self.myHUDManager = hudmanager;
    
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
    // [super scene ist noch nicht gesetzt beim alloc, erst bei add child]
    
    [self.myHUDManager.players addObject:self];
    
}

- (NSNumber*)score
{
    if (_score == nil) {
        _score = [NSNumber numberWithInt:0];
    }
    return _score;
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

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Star class]]) {
        self.score = [NSNumber numberWithInt:[self.score intValue]+1];
    }
    else if ([object isKindOfClass:[EnemyBall class]])
    {
        [self.myHUDManager.players removeObject:self];
        [self removeFromParent];
    }
}

@end
