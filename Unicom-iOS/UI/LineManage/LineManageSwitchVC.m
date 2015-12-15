//
//  LineManageSwitchVC.m
//  NewMars
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "LineManageSwitchVC.h"
#import "MainViewController.h"
#import "CollectionDispatchViewController.h"
#import "LineCollectionViewController.h"
#import "PatrolDispatchViewController.h"
#import "LocationPatrolViewController.h"
#import "AutoPatrolViewController.h"
#import "BreakpointPatrolViewController.h"

@interface LineManageSwitchVC ()

@end

@implementation LineManageSwitchVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"线路巡检";
    
    // @"故障分派",@"故障确认",@"故障处理",@"故障挂起"
       //     _labelArray = @[@"采集分派",@"线路采集",@"巡检分派",@"定位巡检",@"三盯/自动巡检",@"线路断点"];
}

- (void) prepareViewControllers
{
    [super prepareViewControllers];
    //    CGRect standardTableRect = self.view.frame;
    viewControllersArray = [NSMutableArray array];
    [viewControllersArray addObject:[[CollectionDispatchViewController alloc] init]];
    [viewControllersArray addObject:[[LineCollectionViewController alloc] init]];
    [viewControllersArray addObject:[[PatrolDispatchViewController alloc] init]];
    [viewControllersArray addObject:[[LocationPatrolViewController alloc] init]];
    [viewControllersArray addObject:[[AutoPatrolViewController alloc] init]];
    [viewControllersArray addObject:[[BreakpointPatrolViewController alloc] init]];
    
}

- (NSString *) titleForIndex:(NSUInteger ) index
{
    switch (index) {
        case 0:
            return @"采集分派";
            break;
        case 1:
            return @"线路采集";
            break;
        case 2:
            return @"巡检分派";
            break;
        case 3:
            return @"定位巡检";
            break;
        case 4:
            return @"三盯/自动巡检";
            break;
        case 5:
            return @"线路断点";
            break;
        default:
            return @"未知";
    }
}

- (UIColor*)tabIndicatorColor{
    return [UIColor colorWithRed:16.0/255 green:164.0/255 blue:231.0/255 alpha:1.0f];
}

- (NSString *) badgeValueForIndex:(NSUInteger ) index{
    switch (index) {
        case 0:
            return @"1";
            break;
        case 1:
            return @"2";
            break;
        case 2:
            return @"3";
            break;
        case 3:
            return @"4";
            break;
        case 4:
            return @"5";
            break;
        case 5:
            return @"6";
            break;
        default:
            return @"未知";
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



