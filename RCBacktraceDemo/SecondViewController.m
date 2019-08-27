//
//  SecondViewController.m
//  RCBacktraceDemo
//
//  Created by roy.cao on 2019/8/27.
//  Copyright © 2019 roy. All rights reserved.
//

#import "SecondViewController.h"
#import "RCBacktraceDemo-Swift.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)foo {
    [self bar];
}

- (void)bar {
    [self baz];
}

- (void)baz {
    while (true) {
        ;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"second page";
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [Backtrace callstackWithThread:[NSThread mainThread]];
    });
    [self foo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
