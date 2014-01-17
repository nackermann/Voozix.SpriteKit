//
//  Speedboost.m
//  Voozix
//
//  Created by Norman Ackermann on 13.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Speedboost.h"

@implementation Speedboost

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        Player *player = object;
        player.playerSpeed = player.playerSpeed * 1.5;
        [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(removeSpeedBoost:) userInfo:player repeats:NO];
    }
    [super didBeginContactWith:object]; // remove etc.
}

- (void)removeSpeedBoost:(NSTimer*)theTimer
{
    Player *player = theTimer.userInfo;
    player.playerSpeed = 300; // default hier irgendwie rausfinden ?
}

@end
