//
//  ParticleManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "ParticleManager.h"

@interface ParticleManager()
@property (nonatomic, weak) SKScene *scene;
@end

@implementation ParticleManager
- (id)initWithScene:(SKScene*)scene
{
    if (self = [super init]){
    
        self.scene = scene;
    }
    return self;
}


- (void)createStarSparksAtPosition:(CGPoint)position {
    
    NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"StarSparks" ofType:@"sks"];
    SKEmitterNode *spark = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
    spark.position = position;
    [self.scene addChild:spark];
    
    // Particle stays on screen for 2 seconds and is then removed
    SKAction *wait = [SKAction waitForDuration:2.0];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[wait, remove]];
    [spark runAction:sequence];
    
    
}
@end
