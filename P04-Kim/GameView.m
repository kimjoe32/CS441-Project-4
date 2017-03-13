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
-(id)initWithCoder:(NSCoder *)aDecoder
{
    [self setGlobalDy:5];
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        CGRect bounds = [self bounds];
        //create player (copied from doodle jump code)
        player = [[Player alloc] initWithFrame:CGRectMake(bounds.size.width/2, bounds.size.height , 20, 20)];
        [player setBackgroundColor:[UIColor redColor]];
        [player setPosition:3];
        [self addSubview:player];
        
        [self setAndMakeBricks: bounds.size.width/5];
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
        [b setMoving:FALSE];
        [bricks addObject:b];
    }
}

-(void) arrange:(CADisplayLink *)sender{
    NSLog(@"asdf");
    CGRect bounds = [self bounds];
    
    //move bricks
    for (Brick *b in bricks) {
        CGPoint newCenter = b.center;
        //move brick down if it hasn't reached bottom
        
        if (b.center.y < bounds.size.height-5 && b.moving == TRUE){
            newCenter.y += [b dy];
            b.center = newCenter;
        }
        else {//brick reached bottom, send to top
            b.alpha = 0;
            newCenter.y = 20;
            [b setMoving:FALSE];
        }
    }
    
    //spawn bricks
    for (Brick *b in bricks) {
        if (!b.moving){
            if (arc4random() % 10 == 0) {
                //10% chance of spawning a new brick
                [b setMoving:TRUE];
                [b setDy:(globalDy)];
                [b setMoving:TRUE];
            }
        }
    }
    
    for (Brick *brick in bricks)
    {
        CGRect b = [brick frame];
        //collision gameover
        if (CGRectContainsPoint(b, [player center]))
        {
            //game over handler
            NSLog(@"Game Over");
        }
    }
}
@end
