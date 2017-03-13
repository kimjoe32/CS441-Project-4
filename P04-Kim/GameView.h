//
//  GameView.h
//  P04-Kim
//
//  Created by ETS Admin on 3/13/17.
//  Copyright © 2017 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Brick.h"

@interface GameView : UIView {
    
}
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) NSMutableArray *bricks;
@property (nonatomic) float globalDy;
@property (nonatomic, strong) UIImageView * powerUp;
-(void)arrange:(CADisplayLink *)sender;

@end
