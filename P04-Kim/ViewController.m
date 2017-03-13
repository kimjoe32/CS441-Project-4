//
//  ViewController.m
//  P04-Kim
//
//  Created by ETS Admin on 3/13/17.
//  Copyright © 2017 Joe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _displayLink = [CADisplayLink displayLinkWithTarget:_gameView selector:@selector(arrange:)];
    [_displayLink setPreferredFramesPerSecond:30];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
