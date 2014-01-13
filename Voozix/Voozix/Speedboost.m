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
        player.score = [NSNumber numberWithInt:[player.score intValue]+1];
    }
    
    NSLog(@"%@",@"Speedboost");
    [super didBeginContactWith:object]; // remove etc.
}

@end
