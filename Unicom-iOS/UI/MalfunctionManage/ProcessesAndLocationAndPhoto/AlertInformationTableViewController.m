//
//  AlertInformationTableViewController.m
//  Mars
//
//  Created by jiamai on 15/11/23.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "AlertInformationTableViewController.h"
#import "AppDelegate.h"

@interface AlertInformationTableViewController ()
@property (nonatomic,retain)NSArray *alertDeatilArray;
@end

@implementation AlertInformationTableViewController

{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UILabel *label5;
    UILabel *label6;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"告警信息";
    
    self.alertDeatilArray = [[NSArray alloc]init];
    [self initAlertDeatilArray];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)initAlertDeatilArray{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:self.oredrCode forKey:@"orderCode"];
    [SVProgressHUD showInfoWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/selectAlarmByOrderCode" targetClass:[NSArray class] completion:^(NSArray *resultArray, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"加载失败");
        }else{
            self.alertDeatilArray = resultArray;
            if (resultArray.count ==0) {
                [SVProgressHUD showInfoWithStatus:@"没有告警" maskType:SVProgressHUDMaskTypeClear];
            }
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
    return self.alertDeatilArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *detailDictionary = self.alertDeatilArray[indexPath.row];
    cell.userInteractionEnabled = NO;
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, kScreenWidth-20, 20)];
        label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 24, kScreenWidth-20, 20)];
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 46, kScreenWidth-20, 20)];
        label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 68, kScreenWidth-20, 20)];
        label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, kScreenWidth-20, 20)];
        label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 112, kScreenWidth-20, 20)];
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        [cell.contentView addSubview:label3];
        [cell.contentView addSubview:label4];
        [cell.contentView addSubview:label5];
        [cell.contentView addSubview:label6];
    }
    label1.text = [NSString stringWithFormat:@"告警标题:%@",[detailDictionary objectForKey:@"alarmtitle"]];
    label2.text = [NSString stringWithFormat:@"告警发生时间:%@",[detailDictionary objectForKey:@"alarmcreatetime"]];
    label3.text = [NSString stringWithFormat:@"设备厂商:%@",[detailDictionary objectForKey:@"alarmvendor"]];
    label4.text = [NSString stringWithFormat:@"告警级别:%@",[detailDictionary objectForKey:@"alarmlevel"]];
    label5.text = [NSString stringWithFormat:@"告警处理响应级别:%@",[detailDictionary objectForKey:@"alarmhandlelevel"]];
    label6.text = [NSString stringWithFormat:@"告警恢复时间:%@",[detailDictionary objectForKey:@"correspondingaccept"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
