//
//  Message.h
//  Voozix
//
//  Created by VM on 16.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum  {playerMoved, objectSpawned} MessageType;

@interface Message : NSObject
@property (nonatomic)MessageType messageType;
@property (nonatomic, strong)id Object;
@end
