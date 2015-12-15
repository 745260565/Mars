//
//  LocationPatrolViewController.m
//  Mars
//
//  Created by jiamai on 15/11/19.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "LocationPatrolViewController.h"
#import "AppDelegate.h"
#import "LocationPatrolTableViewCell.h"
#import "Constant.h"
#import "LocationPatrolTableViewCell.h"

@interface LocationPatrolViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LocationPatrolViewController
{
    UITableView *locationPatrolTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    locationPatrolTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight-100) style:UITableViewStylePlain];
    locationPatrolTableView.dataSource =self;
    locationPatrolTableView.delegate = self;
    [locationPatrolTableView registerNib:[UINib nibWithNibName:@"LocationPatrolTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:locationPatrolTableView];
}

#pragma mark - tableViewDataSouce tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationPatrolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.label1.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.label2.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.label3.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.label4.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.label5.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 143;
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
