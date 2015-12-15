//
//  LineCollectionViewController.m
//  Mars
//
//  Created by jiamai on 15/11/19.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "LineCollectionViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "CollectionMessageViewController.h"

@interface LineCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LineCollectionViewController
{
    UITableView *lineCollectionTableView;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UIButton *loadButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    lineCollectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth -20, kScreenHeight-100) style:UITableViewStylePlain];
    lineCollectionTableView.delegate = self;
    lineCollectionTableView.dataSource = self;
    [self.view addSubview:lineCollectionTableView];
}

- (void)goBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadLabel{
    NSLog(@"刷新");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+8, kScreenWidth-20-20-50, 21)];
        label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 31+8, kScreenWidth-20-20-50, 21)];
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 55+8+2, kScreenWidth-20-20-50, 21)];
        label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80+8+3, kScreenWidth-20-20-50, 21)];
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        [cell.contentView addSubview:label3];
        [cell.contentView addSubview:label4];
        loadButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-20-10-50, 35+8, 50, 25)];
        loadButton.backgroundColor = [AppDelegate sharedApplicationDelegate].backgroundGrayColor;
        [loadButton setTitle:@"下载" forState:UIControlStateNormal];
        [cell.contentView addSubview:loadButton];
        label1.tag = 1;
        label2.tag = 2;
        label3.tag = 3;
        label4.tag = 4;
        loadButton.tag = 5;
    }else{
        label1 = (UILabel *)[cell.contentView viewWithTag:1];
        label2 = (UILabel *)[cell.contentView viewWithTag:2];
        label3 = (UILabel *)[cell.contentView viewWithTag:3];
        label4 = (UILabel *)[cell.contentView viewWithTag:4];
        loadButton = (UIButton *)[cell.contentView viewWithTag:5];
    }
    label1.text = [NSString stringWithFormat:@"所属区域:%ld",indexPath.row];
    label2.text = [NSString stringWithFormat:@"线路编号:%ld",indexPath.row];
    label3.text = [NSString stringWithFormat:@"线路名称:%ld",indexPath.row];
    label4.text = [NSString stringWithFormat:@"下载进度:%ld",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 117;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionMessageViewController *cmVC = [[CollectionMessageViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:cmVC];
    [self presentViewController:navc animated:NO completion:nil];
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
