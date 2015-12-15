//
//  MalfunctionLayAsideTableViewController.m
//  Mars
//
//  Created by jiamai on 15/10/9.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "MalfunctionLayAsideTableViewController.h"
#import "LayAsideDetailViewController.h"

@implementation MalfunctionLayAsideTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *faultStateArray = @[@"已挂起",@"待挂起"];
        [self.requestData setObject:faultStateArray forKey:@"faultState"];
    }
    return self;
}
#pragma tableView delegate
- (void) viewItem:(id)item
{
    NSDictionary *entity = (NSDictionary *)item;
    
    NSString *faultState = [entity objectForKey:@"faultState"];
    NSArray *menuArray = nil;
    if ([faultState isEqualToString:@"待挂起"]) {
        menuArray = @[@"通过",@"驳回"];
    }else{
        menuArray = @[@"解除挂起"];
    }
    LayAsideDetailViewController *viewController = [[LayAsideDetailViewController alloc] initWithId:[entity objectForKey:@"id"] withHandleMenus:menuArray];
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
