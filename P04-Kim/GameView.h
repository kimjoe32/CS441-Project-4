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
@property (nonatomic, strong) Brick *brick1, *brick2, *brick3,  *brick4, *brick5;
-(void)arrange:(CADisplayLink *)sender;

@end
