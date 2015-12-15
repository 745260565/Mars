//
//  DealProcessessViewController.m
//  Mars
//
//  Created by jiamai on 15/11/13.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "DealProcessessViewController.h"
#import "AppDelegate.h"


@interface DealProcessessViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSArray *dealProcessessArray;
@property (nonatomic,retain) UITableView *dealProcessessTabeleView;
@end

@implementation DealProcessessViewController
{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UILabel *label5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDealProcessess];
    self.dealProcessessTabeleView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, kScreenHeight)];
    self.dealProcessessTabeleView.delegate = self;
    self.dealProcessessTabeleView.dataSource = self;
    self.dealProcessessTabeleView.tableFooterView = [[UIView alloc]init];
    self.dealProcessessTabeleView.bounces = NO;
    [self.view addSubview:self.dealProcessessTabeleView];
    self.title = @"显示处理过程";
}

- (void)initDealProcessess{
    self.dealProcessessArray = [[NSArray alloc]init];
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:self.orderId forKey:@"id"];
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/faultHandleInfo" targetClass:[NSArray class] completion:^(NSArray *resultArray, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }else{
//            NSLog(@"dealProcess:%@",resultArray);
            self.dealProcessessArray = resultArray;
        }
        [self.dealProcessessTabeleView reloadData];
    } withMethod:HttpMethodPost];
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dealProcessessArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 20)];
        label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, kScreenWidth-20, 20)];
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth-20, 20)];
        label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 66, kScreenWidth-20, 20)];
        label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 88, kScreenWidth-20, 20)];
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        [cell.contentView addSubview:label3];
        [cell.contentView addSubview:label4];
        [cell.contentView addSubview:label5];
//        label1.tag = 1;
//        label2.tag = 2;
//        label3.tag = 3;
//        label4.tag = 4;
//        label5.tag = 5;
     }
//        else{
//        label1 = (UILabel *)[cell.contentView viewWithTag:1];
//        label2 = (UILabel *)[cell.contentView viewWithTag:2];
//        label3 = (UILabel *)[cell.contentView viewWithTag:3];
//        label4 = (UILabel *)[cell.contentView viewWithTag:4];
//        label5 = (UILabel *)[cell.contentView viewWithTag:5];
//    }
    NSDictionary *dealProcessDictionary = [[NSDictionary alloc]init];
    dealProcessDictionary = self.dealProcessessArray[indexPath.row];

    label1.text = [NSString stringWithFormat:@"处理步骤:%@",[dealProcessDictionary objectForKey:@"stepName"]];
    label2.text = [NSString stringWithFormat:@"处理者:%@",[dealProcessDictionary objectForKey:@"proUser"]];
    label3.text = [NSString stringWithFormat:@"处理动作:%@",[dealProcessDictionary objectForKey:@"actionName"]];
    label4.text = [NSString stringWithFormat:@"日期:%@",[dealProcessDictionary objectForKey:@"proDate"]];
    label5.text = [NSString stringWithFormat:@"意见:%@",[dealProcessDictionary objectForKey:@"msg"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
