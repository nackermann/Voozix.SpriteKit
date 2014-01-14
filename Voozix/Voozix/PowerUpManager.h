//
//  PowerUpManager.h
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 * @class PowerUpManager
 *
 * @brief Responsible for updating and drawing anything related to power ups
 *
 * Detailed doc
 */
@interface PowerUpManager : NSObject
@property (nonatomic, strong) NSMutableArray *powerUps;

- (id)initWithScene:(SKScene *)scene;
//- (void)createPowerUp:(id)powerUpType;
- (void)update;

@end
