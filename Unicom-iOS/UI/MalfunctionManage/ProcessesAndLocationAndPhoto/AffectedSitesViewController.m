//
//  AffectedSitesViewController.m
//  Mars
//
//  Created by jiamai on 15/11/17.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "AffectedSitesViewController.h"
#import "AppDelegate.h"
#import "AlertInformationTableViewController.h"

@interface AffectedSitesViewController ()
@property (nonatomic,retain)NSArray *deatilOrderArray;

@end

@implementation AffectedSitesViewController
{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细信息";
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc]initWithTitle:@"告警信息" style:UIBarButtonItemStyleDone target:self action:@selector(alert)];
    self.navigationItem.rightBarButtonItem = reloadItem;
//    self.navigationItem.leftBarButtonItem = leftItem;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self initDetailOrderArray];
}

- (void)alert{
    AlertInformationTableViewController *aiTVC = [[AlertInformationTableViewController alloc]init];
    aiTVC.oredrCode = self.orderCode;
    
    [self.navigationController pushViewController:aiTVC animated:YES];
}

- (void)initDetailOrderArray{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:self.orderId forKey:@"id"];
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/selectSiteByOrderId" targetClass:[NSArray class] completion:^(NSArray *resultArray, NSError *error) {
        if (error) {
            NSLog(@"加载失败");
        }else{
            self.deatilOrderArray = resultArray;
            [self.tableView reloadData];
        }
    } withMethod:HttpMethodPost];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deatilOrderArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MalfunctionNotarizeCell"];
    NSDictionary *detailDictionary = self.deatilOrderArray[indexPath.row];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MalfunctionNotarizeCell"];
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, kScreenWidth-20, 20)];
        label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 24, kScreenWidth-20, 20)];
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 46, kScreenWidth-20, 20)];
        label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 68, kScreenWidth-20, 20)];
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        [cell.contentView addSubview:label3];
        [cell.contentView addSubview:label4];
    }
    label1.text = [NSString stringWithFormat:@"基站名称:%@",[detailDictionary objectForKey:@"siteName"]];
    label2.text = [NSString stringWithFormat:@"基站编号:%@",[detailDictionary objectForKey:@"siteNo"]];
    label3.text = [NSString stringWithFormat:@"基站等级:%@",[detailDictionary objectForKey:@"siteLevel"]];
    label4.text = [NSString stringWithFormat:@"所属地区:%@",[detailDictionary objectForKey:@"area"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}


@end
