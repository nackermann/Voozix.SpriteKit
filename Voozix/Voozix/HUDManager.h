//
//  HUDManager.h
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HUDManager : NSObject
@property (nonatomic,assign) NSInteger *m_score;
- (void)update:(id)sender;
@end
