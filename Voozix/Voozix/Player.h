//
//  Player.h
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PlayerController.h"
#import "HUDManager.h"

@interface Player : SKSpriteNode <SKPhysicsContactDelegate>
@property (nonatomic, strong) PlayerController *playerController;
@property (nonatomic, strong) NSNumber *score;

- (id)initWithHUDManager:(HUDManager*)hudmanager;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)didBeginContactWith:(id)object;
@end
