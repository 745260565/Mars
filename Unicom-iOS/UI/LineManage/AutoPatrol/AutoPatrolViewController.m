//
//  AutoPatrolViewController.m
//  Mars
//
//  Created by jiamai on 15/11/19.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "AutoPatrolViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "LocationPatrolTableViewCell.h"

@interface AutoPatrolViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AutoPatrolViewController
{
    UITableView *autoPatrolTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    autoPatrolTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight-100) style:UITableViewStylePlain];
    autoPatrolTableView.delegate = self;
    autoPatrolTableView.dataSource = self;
    [autoPatrolTableView registerNib:[UINib nibWithNibName:@"LocationPatrolTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:autoPatrolTableView];

}

- (void)goBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadLabel{
    NSLog(@"刷新");
}

#pragma mark UITableViewDataSource UITableViewDelegate
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
