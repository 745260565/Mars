//
//  MalfunctionNotarizeTableViewController.m
//  Mars
//
//  Created by jiamai on 15/10/9.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "MalfunctionNotarizeTableViewController.h"
#import "AppDelegate.h"
#import "DealOrderDetailViewController.h"

@interface MalfunctionNotarizeTableViewController ()

@end

@implementation MalfunctionNotarizeTableViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *faultStateArray = @[@"待确认"];
        [self.requestData setObject:faultStateArray forKey:@"faultState"];
    }
    return self;
}
#pragma tableView delegate
- (void) viewItem:(id)item
{
    NSDictionary *entity = (NSDictionary *)item;
    DealOrderDetailViewController *viewController = [[DealOrderDetailViewController alloc] initWithId:[entity objectForKey:@"id"] withHandleMenus:@[@"故障确认",@"退单"]];
    viewController.completion = ^void (BOOL needRefresh){
        if (needRefresh) {
            [self refresh];
            [HttpNetworkManager request:nil withPath:@"/api/fault/faultOrderInfo/MyFaultWorkOrderNumber" targetClass:[NSDictionary class] completion:^(NSDictionary *resultDictionary, NSError *error) {
                if (error) {
                    NSLog(@"加载数量失败");
                }else{
                    NSLog(@"resultDictionary:%@",resultDictionary);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"countChange" object:self userInfo:resultDictionary];
                }
            } withMethod:HttpMethodPost];
        }
    };
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
