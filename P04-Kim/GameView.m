//
//  GameView.m
//  P04-Kim
//
//  Created by ETS Admin on 3/13/17.
//  Copyright © 2017 Joe. All rights reserved.
//

#import "GameView.h"
@implementation GameView
@synthesize player;
@synthesize bricks;
@synthesize globalDy;
@synthesize powerUp;

NSInteger currentScore,
            powerUpCounter;
BOOL gameOverHappened = FALSE;//so we don't get gameover twice
BOOL powerUpAvailable = FALSE;//so we don't have more than 1 powerup on the screen
BOOL powerUpInAction = FALSE;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    [self setGlobalDy:6];
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        CGRect bounds = [self bounds];
        //create player (copied from doodle jump code)
        player = [[Player alloc] initWithFrame:CGRectMake(bounds.size.width/2, bounds.size.height-50 , 20, 20)];
        [player setBackgroundColor:[UIColor redColor]];
        [self addSubview:player];
        
        [self setAndMakeBricks: bounds.size.width/5];
        
        //powerup exists but not visible
        powerUp= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2xSpeed"]];
        [self addSubview:powerUp];
        powerUp.alpha=0;
    }
    return self;
}

- (void) setAndMakeBricks: (float) width {
    float height = 20;
    bricks = [[NSMutableArray alloc] init];
    for (int i =0; i < 5; i++) {
        Brick *b =[[Brick alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        [b setBackgroundColor:[UIColor blueColor]];
        [self addSubview:b];
        [b setAlpha:0];
        [b setMoving:FALSE];
        [bricks addObject:b];
    }
}

-(void) gameOverHandler {
    //set score to 0
    gameOverHappened = FALSE;
    for (Brick *b in bricks) {
        CGPoint newCenter = b.center;
        newCenter.y = 0;
        [b setMoving:FALSE];
        b.alpha = 0;
        [b setCenter:newCenter];
    }
    
    //remove powerup if available
    if (powerUpAvailable) {
        [powerUp setAlpha:0];
        powerUpAvailable=FALSE;
    }
}

-(void)arrange:(CADisplayLink *)sender{
    powerUpCounter++; //30 frames/second, so 30*x == x seconds elapsed
    if (powerUpInAction && powerUpCounter > 90) {
        powerUpInAction= FALSE;
        
    }
    
    CGRect bounds = [self bounds];
    
    //move bricks
    for (Brick *b in bricks) {
        CGPoint newCenter = b.center;
        //move brick down if it hasn't reached bottom
        if (b.center.y < bounds.size.height-10 && b.moving == TRUE){
            newCenter.y += globalDy;
            b.center = newCenter;
        }
        else {//brick reached bottom, send to top
            b.alpha = 0;
            newCenter.y = 20;
            [b setDy:0];
            b.center = newCenter;
            [b setMoving:FALSE];
        }
    }
    
    //move powerup down if spawned
    if (!powerUpAvailable) {
        CGPoint newCenter = powerUp.center;
        newCenter.y += globalDy;
        powerUp.center=newCenter;
        //powerup reached bottom, remove it
        if (powerUp.center.y > bounds.size.height-10) {
            powerUpAvailable=TRUE;
            [powerUp setAlpha:0];
        }
    }
    //1% chance of spawning a powerup
    else if (arc4random()%100 == 0 && powerUpInAction) {
        NSLog(@"powerupSpawned");
        CGPoint newCenter = CGPointMake(rand()% (int)bounds.size.width,0);
        powerUp.center = newCenter;
        
        //choose powerup to display
        switch (arc4random()%2) {
            case 0:
                [powerUp setImage:[UIImage imageNamed:@"2xSpeed"]];
                break;
                
            case 1:
                [powerUp setImage:[UIImage imageNamed:@"halfSpeed"]];
                break;
        }

        //[self addSubview:powerUp];
        [self bringSubviewToFront:powerUp];
        [powerUp setAlpha:1];
        powerUpAvailable=FALSE;
    }
    
    //spawn bricks if brick not already moving
    for (Brick *b in bricks) {
        if (!b.moving){
            if (arc4random() % 20 == 0) {
                //5% chance of spawning a new brick
                [b setMoving:TRUE];
                [b setDy:(globalDy)];
                b.alpha=1;
            }
        }
    }
    
    //check collision with bricks
    for (Brick *brick in bricks)
    {
        CGRect b = [brick frame];
        //collision gameover
        if (CGRectContainsPoint(b, [player center]) && !gameOverHappened)
        {
            gameOverHappened=TRUE;
            //game over handler
            NSLog(@"Game Over");
            [self gameOverHandler];
            
        }
    }
    
    //check collision with powerup
    if (powerUpAvailable && CGRectContainsPoint(powerUp.frame, [player center])) {
        //get data to compare images
        NSData *data1 = UIImagePNGRepresentation([UIImage imageNamed:@"2xSpeed.png"]);
        NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"halfSpeed.png"]);
        
        if (UIImagePNGRepresentation(powerUp.image) == data1){
            //double speed
            [self setGlobalDy:12];
        } else if (UIImagePNGRepresentation(powerUp.image) == data2) {
            [self setGlobalDy:3];
        }
        
        powerUpCounter = 0;
        powerUpInAction = TRUE;
    }
}

-(void)moveRight
{
    
    CGRect bounds = [self bounds];
    if (player.center.x >= (bounds.size.width) - (bounds.size.width/5)){
        return;
    }
    CGPoint newCenter = player.center;
    newCenter.x += (bounds.size.width/5);
    player.center =newCenter;
}
-(void)moveLeft
{
    CGRect bounds = [self bounds];
    if (player.center.x <=  (bounds.size.width/5)){
        return;
    }
    CGPoint newCenter = player.center;
    newCenter.x -= (bounds.size.width/5);
    player.center =newCenter;
}
@end
