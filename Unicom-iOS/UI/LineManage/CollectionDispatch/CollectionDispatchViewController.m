//
//  CollectionDispatchViewController.m
//  Mars
//
//  Created by jiamai on 15/11/19.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "CollectionDispatchViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "CollectionDispatchTableViewCell.h"

@interface CollectionDispatchViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CollectionDispatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"采集分派";
    
    UITableView *collectionDispatchTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight) style:UITableViewStylePlain];
    collectionDispatchTableView.delegate = self;
    collectionDispatchTableView.dataSource = self;
    [collectionDispatchTableView registerNib:[UINib nibWithNibName:@"CollectionDispatchTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:collectionDispatchTableView];
}

- (void)goBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadLabel{
    NSLog(@"刷新");
}

#pragma mark --UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionDispatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.label1.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.label2.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.label3.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
