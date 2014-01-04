//
//  Player.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Player.h"

@interface Player()
@property (nonatomic, strong) NSNumber *myScore;
@end

@implementation Player

- (NSNumber*)myScore
{
    if (_myScore == nil) {
        _myScore = [NSNumber numberWithInt:0];
    }
    return _myScore;
}

@end
