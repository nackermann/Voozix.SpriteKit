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
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.8f];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
    [spark runAction:sequence];
    
    
}
@end
