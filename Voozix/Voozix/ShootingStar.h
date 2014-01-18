//
//  ShootingStar.h
//  Voozix
//
//  Created by K!N on 1/17/14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ShootingStar : SKSpriteNode

-(id)initWithScene:(SKScene *)scene;
-(void)update:(CFTimeInterval)currentTime;
- (void)didBeginContactWith:(id)object;
@end
