//
//  BreakpointPatrolViewController.m
//  Mars
//
//  Created by jiamai on 15/11/19.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "BreakpointPatrolViewController.h"
#import "AppDelegate.h"

@interface BreakpointPatrolViewController ()

@end

@implementation BreakpointPatrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)goBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadLabel{
    NSLog(@"刷新");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
