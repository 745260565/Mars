//
//  AlertAndAffectedSitesViewController.m
//  Unicom-iOS
//
//  Created by jiamai on 15/12/15.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import "AlertAndAffectedSitesViewController.h"
#import "AlertInformationTableViewController.h"
#import "AffectedSitesViewController.h"

@interface AlertAndAffectedSitesViewController ()

@end

@implementation AlertAndAffectedSitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"受影响基站和告警信息";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareViewControllers{
    [super prepareViewControllers];
    viewControllersArray = [NSMutableArray array];
    [viewControllersArray addObject:[[AffectedSitesViewController alloc]initWithOrderId:self.orderId]];
    [viewControllersArray addObject:[[AlertInformationTableViewController alloc]initWithOrderCode:self.orderCode]];
}

- (UIColor*)tabIndicatorColor{
    return [UIColor colorWithRed:16.0/255 green:164.0/255 blue:231.0/255 alpha:1.0f];
}

- (NSString *)titleForIndex:(NSUInteger)index{
    switch (index) {
        case 0:
            return @"受影响基站";
            break;
        case 1:
            return @"告警信息";
            break;
        default:
            return @"未知";
            break;
    }
}

@end
