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
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        CGRect bounds = [self bounds];
        //create player (copied from doodle jump code)
        player = [[Player alloc] initWithFrame:CGRectMake(bounds.size.width/2, bounds.size.height - 20, 20, 20)];
        [player setBackgroundColor:[UIColor redColor]];
        [player setDx:0];
        [player setPosition:3];
        [self addSubview:player];
        
        //alloc the blocks
        
    }
    return self;
}
@end
