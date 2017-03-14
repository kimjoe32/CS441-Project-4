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

NSInteger currentScore = 0,
            powerUpCounter,
            powerUpType;
BOOL gameOverHappened = FALSE;//so we don't get gameover twice
BOOL powerUpSpawnable = TRUE;//so we don't have more than 1 powerup on the screen
BOOL powerUpInAction = FALSE;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    [self setGlobalDy:8];
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
        powerUpType =1;
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
    if (!powerUpSpawnable) {
        [powerUp setAlpha:0];
        powerUpSpawnable=TRUE;
    }
    
    if (powerUpInAction) {
        powerUpInAction=FALSE;
        [self setGlobalDy:8];
    }
    
    //setscore to 0
    for (UIView *i in self.subviews){
        if([i isKindOfClass:[UILabel class]]){
            UILabel * lbl = (UILabel*) i;
            if([lbl.text isEqualToString:@"Score: "])//wrong label, skip
                continue;
            currentScore=0;
            [lbl setText:[NSString stringWithFormat:@"%d", 0]];
            break;
        }
    }
}

-(void)arrange:(CADisplayLink *)sender{
    powerUpCounter = (powerUpCounter+1)% 1000; //30 frames/second, so 30*x == x seconds elapsed
    
    if (powerUpInAction && powerUpCounter > 90) {
        powerUpInAction= FALSE;
        [self setGlobalDy:8];
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
        else if (b.center.y > bounds.size.height-10){
            //brick reached bottom, send to top
            b.alpha = 0;
            newCenter.y = 50;
            [b setDy:0];
            b.center = newCenter;
            [b setMoving:FALSE];
        }
    }
    
    //spawn bricks if brick not already moving
    for (Brick *b in bricks) {
        if (!b.moving){
            if (arc4random() % 20 == 0) {
                //5% chance of spawning a new brick
                [b setMoving:TRUE];
                [b setDy:(globalDy)];
                b.alpha=1;
                //new brick = +1 to score
                for (UIView *i in self.subviews){
                    if([i isKindOfClass:[UILabel class]]){
                        UILabel * lbl = (UILabel*) i;
                        if([lbl.text isEqualToString:@"Score: "])//wrong label, skip
                            continue;
                        currentScore++;
                        [lbl setText:[NSString stringWithFormat:@"%ld", currentScore]];
                        break;
                    }
                }
            }
        }
    }
    
    //move powerup down if spawned
    if (!powerUpSpawnable) {
        CGPoint newCenter = powerUp.center;
        newCenter.y += globalDy;
        powerUp.center=newCenter;
        //powerup reached bottom, remove it
        
        if (powerUp.center.y > bounds.size.height-10) {
            [powerUp setAlpha:0];
        }
    }
    //10% chance of spawning a powerup
    else if (arc4random()%10 == 0 && !powerUpInAction) {
        CGPoint newCenter = CGPointMake((rand()%5)*(int)bounds.size.width/5 -30,50);
        powerUp.center = newCenter;
        
        //choose powerup to display
        switch (arc4random()%2) {
            case 0:
                powerUpType=1;
                [powerUp setImage:[UIImage imageNamed:@"2xSpeed"]];
                break;
                
            case 1:
                powerUpType=0;
                [powerUp setImage:[UIImage imageNamed:@"halfSpeed"]];
                break;
        }

        //[self addSubview:powerUp];
        [self bringSubviewToFront:powerUp];
        [powerUp setAlpha:1];
        powerUpSpawnable=FALSE;
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
    if (!powerUpSpawnable && CGRectContainsPoint(powerUp.frame, [player center])) {
        //get data to compare images
        
        if (powerUpType){
            //double speed
            [self setGlobalDy:16];
            
        } else if (!powerUpType) {
            //half speed
            [self setGlobalDy:4];
        }
        [powerUp setAlpha:0];
        powerUpSpawnable=TRUE;
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
