//
//  Message.m
//  Voozix
//
//  Created by VM on 16.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        self.messageType = [decoder decodeIntegerForKey:@"messageType"];
        self.args = [decoder decodeObjectForKey:@"args"];
        CGFloat positionX = [decoder decodeFloatForKey:@"posX"];
        CGFloat positionY = [decoder decodeFloatForKey:@"posY"];
        
        self.position = CGPointMake(positionX, positionY);
        
        
        CGFloat dx = [decoder decodeFloatForKey:@"velocityDx"];
        CGFloat dy = [decoder decodeFloatForKey:@"velocityDy"];
        self.velocity = CGVectorMake(dx, dy);
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.messageType forKey:@"messageType"];
    [encoder encodeObject:self.args forKey:@"args"];
    [encoder encodeFloat:self.position.x forKey:@"posX"];
    [encoder encodeFloat:self.position.y forKey:@"posY"];
    [encoder encodeFloat:self.velocity.dx forKey:@"velocityDx"];
    [encoder encodeFloat:self.velocity.dy forKey:@"velocityDy"];
}


@end
