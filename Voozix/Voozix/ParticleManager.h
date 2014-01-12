//
//  ParticleManager.h
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 * @class ParticleManager
 *
 * @brief Responsible for updating and drawing anything related to particles
 *
 * Detailed doc
 */
@interface ParticleManager : NSObject
- (id)initWithScene:(SKScene *)scene;
- (void)createStarSparksAtPosition:(CGPoint)position;
@end
