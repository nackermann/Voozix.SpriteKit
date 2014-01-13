//
//  PowerUp.h
//  Voozix
//
//  Created by Norman Ackermann on 13.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface PowerUp : SKSpriteNode   // Base Class

- (void)didBeginContactWith:(id)object;
- (void)update;

@end
