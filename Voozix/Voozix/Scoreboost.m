//
//  Scoreboost.m
//  Voozix
//
//  Created by Norman Ackermann on 16.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Scoreboost.h"

@implementation Scoreboost

- (void)didBeginContactWith:(id)object
{
    if ([object isKindOfClass:[Player class]]) {
        Player *player = object;
        player.score = [NSNumber numberWithInt:[player.score intValue]+5];
    }
    [super didBeginContactWith:object]; // remove etc.
}


@end
