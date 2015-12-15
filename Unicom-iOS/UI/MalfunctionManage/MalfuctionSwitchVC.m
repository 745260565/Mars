//
//  MalFuctionSwitchVC.m
//  NewMars
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "MalfuctionSwitchVC.h"
//#import "MainViewController.h"
#import "MalfunctionAllocateViewController.h"
#import "MalfunctionNotarizeTableViewController.h"
#import "MalfunctionTransactTableViewController.h"
#import "MalfunctionLayAsideTableViewController.h"
#import "HttpNetworkManager.h"

@interface MalfuctionSwitchVC ()

@end

@implementation MalfuctionSwitchVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"故障列表";
    [self loadNumberofIndex];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadCount:) name:@"countChange" object:nil];
}

- (void)uploadCount:(NSNotification *)notfication{
    
    NSString *confirmNumber = [NSString stringWithFormat:@"%@",[[notfication userInfo] objectForKey:@"confirmTotal"]];
    NSString *pendingNumber = [NSString stringWithFormat:@"%@",[[notfication userInfo] objectForKey:@"pendingTotal"]];
    NSString *handleNumber = [NSString stringWithFormat:@"%@",[[notfication userInfo] objectForKey:@"handleTotal"]];
    NSString *dispatchNumber = [NSString stringWithFormat:@"%@",[[notfication userInfo] objectForKey:@"dispatchTotal"]];
    NSLog(@"notfication%@",notfication);
    [self.headerView updateBadgeValue:dispatchNumber atIndex:0];
    [self.headerView updateBadgeValue:confirmNumber atIndex:1];
    [self.headerView updateBadgeValue:handleNumber atIndex:2];
    [self.headerView updateBadgeValue:pendingNumber atIndex:3];
//    [ updateBadgeValue:count atIndex:[index longValue]];
}


- (void) prepareViewControllers
{
    [super prepareViewControllers];
//    CGRect standardTableRect = self.view.frame;
    viewControllersArray = [NSMutableArray array];
    [viewControllersArray addObject:[[MalfunctionAllocateViewController alloc] init]];
    [viewControllersArray addObject:[[MalfunctionNotarizeTableViewController alloc] init]];
    [viewControllersArray addObject:[[MalfunctionTransactTableViewController alloc] init]];
    [viewControllersArray addObject:[[MalfunctionLayAsideTableViewController alloc] init]];
    
    
}
- (NSString *) titleForIndex:(NSUInteger ) index
{
    switch (index) {
        case 0:
            return @"故障分派";
            break;
        case 1:
            return @"故障确认";
            break;
        case 2:
            return @"故障处理";
            break;
        case 3:
            return @"故障挂起";
            break;
        default:
            return @"未知";
    }
}

- (UIColor*)tabIndicatorColor{
    return [UIColor colorWithRed:16.0/255 green:164.0/255 blue:231.0/255 alpha:1.0f];
}

- (void)loadNumberofIndex{
    [HttpNetworkManager request:nil withPath:@"/api/fault/faultOrderInfo/MyFaultWorkOrderNumber" targetClass:[NSDictionary class] completion:^(NSDictionary *resultDictionary, NSError *error) {
        if (error) {
            NSLog(@"加载数量失败");
        }else{
            NSLog(@"resultDictionary:%@",resultDictionary);
            NSString *confirmNumber = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"confirmTotal"]];
            NSString *pendingNumber = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"pendingTotal"]];
            NSString *handleNumber = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"handleTotal"]];
            NSString *dispatchNumber = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"dispatchTotal"]];
            [self.headerView updateBadgeValue:dispatchNumber atIndex:0];
            [self.headerView updateBadgeValue:confirmNumber atIndex:1];
            [self.headerView updateBadgeValue:handleNumber atIndex:2];
            [self.headerView updateBadgeValue:pendingNumber atIndex:3];
        }
    } withMethod:HttpMethodPost];
}

//- (NSString *) badgeValueForIndex:(NSUInteger ) index{
//    switch (index) {
//        case 0:
//            return _dispatchTotal;
//            break;
//        case 1:
//            return _confirmTotal;
//            break;
//        case 2:
//            return _handleTotal;
//            break;
//        case 3:
//            return _pendingTotal;
//            break;
//        default:
//            return nil;
//    }
//}


@end
