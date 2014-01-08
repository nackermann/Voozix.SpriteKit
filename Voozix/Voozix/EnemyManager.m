//
//  EnemyManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "EnemyManager.h"

const int MIN_SPEED = 4;
const int MAX_SPEED = 15;

@interface EnemyManager()
@property SKScene *scene;
@property (nonatomic, strong) NSMutableArray *enemies;
@end


@implementation EnemyManager

- (void)removeAllEnemies
{
    for (EnemyBall *enemy in self.enemies) {
        [enemy removeFromParent];
    }
    
    [self.enemies removeAllObjects];
}

- (NSMutableArray *)enemies {
    
    if (!_enemies)
        _enemies = [[NSMutableArray alloc] init];
    
    return _enemies;
}

- (id)initWithScene:(SKScene *)scene {
    
    if  (self = [super init]){
        self.scene = scene;
    }
    
    return self;
}


- (void)createEnemy {
    
    EnemyBall *enemy = [[EnemyBall alloc] init];
    enemy.velocity = [self createRandomVelocity];
    
    /* Get random coordinates that are within the screen bounds */
    float x = (arc4random() % (int)self.scene.frame.size.width);
    float y = (arc4random() % (int)self.scene.frame.size.height);
    
    /*Take object width into consideration */
    if (x + enemy.frame.size.width/2 > self.scene.frame.size.width)
        x -= enemy.frame.size.width/2;
    else if (x - enemy.frame.size.width/2 < 0)
        x += enemy.frame.size.width/2;
    
    /* Take object height into consideration */
    if (y + enemy.frame.size.height/2 > self.scene.frame.size.height )
        y -= enemy.frame.size.height/2;
    else if (y - enemy.frame.size.height/2 < 0)
        y += enemy.frame.size.width/2;
    
    /* Create and set new position */
    enemy = [[EnemyBall alloc] initAtPosition:CGPointMake(x, y)];
    enemy.velocity = [self createRandomVelocity];
    //enemy.position = CGPointMake(x, y);
    
    [self.enemies addObject:enemy];
    [self.scene addChild:enemy];
    
}

- (void)update:(CFTimeInterval)currentTime {
    
    for (EnemyBall *enemy in self.enemies) {
        
        if ((enemy.position.x - enemy.size.width/2 <= 0) ||
            (enemy.position.y - enemy.size.height/2 <= 0) ||
            (enemy.position.x + enemy.size.width/2 >= self.scene.frame.size.width) ||
            (enemy.position.y + enemy.size.height/2 >= self.scene.frame.size.height)){
                enemy.velocity = CGVectorMake( - enemy.velocity.dx, -enemy.velocity.dy);
        }
        
        [enemy update:currentTime];
    }
    
}

- (CGVector)createRandomVelocity {
    
    CGVector velocity;
    
    int value = arc4random() % 4;
    
    switch (value) {
        case 0:
            velocity = CGVectorMake(0.0, 1.0 * (arc4random() % MAX_SPEED) + MIN_SPEED);
            break;
            
        case 1:
            velocity = CGVectorMake(1.0 * (arc4random() % MAX_SPEED) + MIN_SPEED, 0.0);
            break;
            
        case 2:
            velocity = CGVectorMake(0.0, -1.0 * (arc4random() % MAX_SPEED) - MIN_SPEED);
            break;
            
        case 3:
            velocity = CGVectorMake(-1.0 * (arc4random() % MAX_SPEED) - MIN_SPEED, 0.0);
            break;
            
        default:
            break;
    }
    
    return velocity;
    
}


@end
