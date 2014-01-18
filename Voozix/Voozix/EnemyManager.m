//
//  EnemyManager.m
//  Voozix
//
//  Created by Norman Ackermann on 02.01.14.
//  Copyright (c) 2014 Norman Ackermann. All rights reserved.
//

#import "EnemyManager.h"
#import "ParticleManager.h"

const int MIN_SPEED = 100;
const int MAX_SPEED = 200;

@interface EnemyManager()
@property SKScene *scene;
@property (nonatomic, strong) NSMutableArray *enemies;
@property (nonatomic, strong) ParticleManager *particleManager;
@end


@implementation EnemyManager

- (ParticleManager *)particleManager {
    
    if (!_particleManager) {
        _particleManager = [[ParticleManager alloc] initWithScene:self.scene];
    }
    
    return _particleManager;
}



/**
 * @brief Removes all enemies from the scene
 * @details [long description]
 * 
 * @param enemy [description]
 * @return [description]
 */
- (void)removeAllEnemies
{
    for (EnemyBall *enemy in self.enemies) {
        [enemy removeFromParent];
    }
    
    [self.enemies removeAllObjects];
}

 /**
  * @brief Returns all enemies in the scene
  * @details [long description]
  * 
  * @param e [description]
  * @return [description]
  */
- (NSMutableArray *)enemies {
    
    if (!_enemies)
        _enemies = [[NSMutableArray alloc] init];
    
    return _enemies;
}

/**
 * Initializes enemy manager
 * @param  {SKScene *} Scene that all enemies belong to
 * @return {id}
 */
- (id)initWithScene:(SKScene *)scene {
    
    if  (self = [super init]){
        self.scene = scene;
    }
    
    return self;
}

/**
 * Creates an enemy and adds it to the scene
 */
- (void)createEnemyWithPlayerPostion:(CGPoint)playerPosition {
    
//    EnemyBall *enemy = [[EnemyBall alloc] init];
//    enemy.velocity = [self createRandomVelocity];
//    
//    /* Get random coordinates that are within the screen bounds */
//    float x = (arc4random() % (int)self.scene.frame.size.width);
//    float y = (arc4random() % (int)self.scene.frame.size.height);
//    
//    /*Take object width into consideration */
//    if (x + enemy.frame.size.width/2 > self.scene.frame.size.width)
//        x -= enemy.frame.size.width/2;
//    else if (x - enemy.frame.size.width/2 < 0)
//        x += enemy.frame.size.width/2;
//    
//    /* Take object height into consideration */
//    if (y + enemy.frame.size.height/2 > self.scene.frame.size.height )
//        y -= enemy.frame.size.height/2;
//    else if (y - enemy.frame.size.height/2 < 0)
//        y += enemy.frame.size.width/2;
//    
    /* Create and set new position */
    
    CGPoint enemyPosition = [self createRandomPosition];
    
    while (sqrt(pow(enemyPosition.x - playerPosition.x, 2) + pow(enemyPosition.y - playerPosition.y, 2)) < 300) {
        enemyPosition = [self createRandomPosition];
    }
    
    [self.particleManager createEnemySparksAtPosition:enemyPosition];
    
    EnemyBall *enemy = [[EnemyBall alloc] initAtPosition:enemyPosition];
    enemy.velocity = [self createRandomVelocity];
    enemy.physicsBody.velocity = enemy.velocity;
    
    [self.enemies addObject:enemy];
    [self.scene addChild:enemy];
    
    
    NSLog(@"%g", sqrt(pow(enemyPosition.x - playerPosition.x, 2) + pow(enemyPosition.y - playerPosition.y, 2)));
}

/**
 * @brief Updates all enemies: Movement and border collision
 * @details [long description]
 * 
 * @param  [description]
 * @return [description]
 */
- (void)update:(CFTimeInterval)currentTime {
    
    for (EnemyBall *enemy in self.enemies) {

        [enemy update:currentTime];
    }
    
}

/**
 * @brief Creates a velocity vector by first choosing a random direction (up, down, left, right) and then generating a random velocity
 * @details The range of the random velocity can be configured by setting MIN_SPEED and MAX_SPEED
 * @return [description]
 */
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

- (CGPoint)createRandomPosition {
    
    EnemyBall *enemy = [[EnemyBall alloc] init];
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
    
    return CGPointMake(x, y);
}


@end
