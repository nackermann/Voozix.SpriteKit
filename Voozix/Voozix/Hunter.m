//
//  Hunter.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "Hunter.h"
#import "ObjectCategories.h"


static const float relativeSpeedToPlayer = 0.5;

@interface Hunter()
@property (nonatomic, weak)Player *followingPlayer;
@end

@implementation Hunter
-(id)initWithPlayer:(Player *)player AndPosition:(CGPoint)position
{
    if (self = [super init]) {
        self.followingPlayer = player;
        self.position = position;
        [self setup];
        
    }
    
    return self;
}

-(id)initWithPlayer:(Player *)player
{
    if(self = [super init]){
        self.followingPlayer = player;
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.texture = [SKTexture textureWithImageNamed:@"enemy"];
    self.size = self.texture.size;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = ENEMY_OBJECT;
    self.physicsBody.collisionBitMask = PLAYER_OBJECT | BACKGROUND_OBJECT;
    self.physicsBody.contactTestBitMask = PLAYER_OBJECT;
    self.physicsBody.allowsRotation = NO;
    self.name = @"hunter";
}

-(void)setRandomPosition
{
    CGRect rect = [[super scene] frame];
    float x = (arc4random() % (int)rect.size.width);
    float y = (arc4random() % (int)rect.size.height);
    
    /*Take object width into consideration */
    if (x + self.frame.size.width/2 > rect.size.width)
        x -= self.frame.size.width/2;
    else if (x - self.frame.size.width/2 < 0)
        x += self.frame.size.width/2;
    
    /* Take object height into consideration */
    if (y + self.frame.size.height/2 > rect.size.height )
        y -= self.frame.size.height/2;
    else if (y - self.frame.size.height/2 < 0)
        y += self.frame.size.width/2;
    
    /* Create and set new position */
    self.position =  CGPointMake(x, y);
}


-(void)update
{
    //CGFloat x = (self.followingPlayer.position.x-self.position.x-self.followingPlayer.playerSpeed) / (2*self.followingPlayer.playerSpeed);
    //CGFloat y = (self.followingPlayer.position.y-self.position.y-self.followingPlayer.playerSpeed) / (2*self.followingPlayer.playerSpeed);
    
    CGFloat x = self.followingPlayer.position.x - self.position.x;
    CGFloat y = self.followingPlayer.position.y - self.position.y;
    
    if(x < 0) x = -relativeSpeedToPlayer*self.followingPlayer.playerSpeed;
    else if(x > 0) x = relativeSpeedToPlayer* self.followingPlayer.playerSpeed;
    
    if(y < 0) y = -relativeSpeedToPlayer*self.followingPlayer.playerSpeed;
    else if(y > 0) y =relativeSpeedToPlayer* self.followingPlayer.playerSpeed;
    
    if(self.physicsBody) self.physicsBody.velocity = CGVectorMake(x, y);
}

@end