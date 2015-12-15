//
//  MalfunctionAllocateViewController.m
//  Mars
//
//  Created by jiamai on 15/10/9.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "MalfunctionAllocateViewController.h"
#import "AllocateDetailViewController.h"


@interface MalfunctionAllocateViewController ()

@end

@implementation MalfunctionAllocateViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *faultStateArray = @[@"已派单"];
        [self.requestData setObject:faultStateArray forKey:@"faultState"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}




#pragma tableView delegate
- (void) viewItem:(id)item
{
    NSDictionary *entity = (NSDictionary *)item;
    AllocateDetailViewController *viewController = [[AllocateDetailViewController alloc] initWithId:[entity objectForKey:@"id"] withHandleMenus:@[@"故障分派",@"退单"]];
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
