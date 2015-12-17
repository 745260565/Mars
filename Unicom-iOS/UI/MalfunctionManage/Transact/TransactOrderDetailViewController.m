//
//  TransactOrderDetailViewController.m
//  Mars
//
//  Created by jiamai on 15/11/10.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "TransactOrderDetailViewController.h"
#import "AppDelegate.h"
#import "CHPopoverListView.h"
#import "AlertShowWithString.h"

@interface TransactOrderDetailViewController ()<CHPopoverListDatasource,CHPopoverListDelegate,UITextFieldDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
    NSUInteger tag;
    NSDictionary *deatailOrder;
    NSArray *ideaArray;//意见数组
    NSArray *reasonArray;//故障原因数组
    NSArray *reasonSubArray;//故障原因小类数组
    UITextField *ideaTextField;//竟见栏
    NSDictionary *reasonDictionary;//所有原因
    UITextField *dealMethodTextField;//处理方法
    UITextField *reasonTextField;//故障原因
    UITextField *subReasonTextField;//故障原因小类
    UITextField *remarkTextField;//备注信息
    NSArray *chooseArray;
}
@end

@implementation TransactOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"故障处理详情";
    reasonDictionary = @{@"搬迁原因":@[@"8.1 物业纠纷",@"8.2 基站搬迁"],
                              @"传输设备故障":@[@"3.1 微波故障",@"3.2 PDH故障",@"3.3 传输2M线路故障",@"3.4 SDH故障",@"3.5 级联上级传输设备故障",@"3.6 码误",@"3.7 尾纤故障(机房内)",@"3.8 传输设备闪断"],
                              @"动力配套故障":@[@"4.1开关电源故障",@"4.2联通产权范围内的高、低压电力线路故障",@"4.3联通产权范围内的变压器问题",@"4.4低压配电箱故障",@"4.5级联上级动力要配套设备故障导致的上级光端机掉电",@"4.6空调故障导致高温",@"4.7UPS逆变器故障",@"4.8稳压器故障"],
                              @"电信原因":@[@"6.1租用电信电路",@"6.2电信产权停电类宕站",@"6.3电信产权光缆中断",@"6.4电信产权传输设备故障",@"6.5电信产权动力故障",@"6.6电信产权光缆线路割接",@"6.7电信产权伟输设备割接",@"6.8电信产权动力配套割接",@"6.9电信产权主设备割接",@"6.10电信产权其它"],
                              @"光缆线路故障":@[@"2.1人为破怀",@"2.2施工动土",@"2.3车辆刮断",@"2.4鼠虫等咬断光纤",@"2.5自然灾害",@"2.6纤芯老化",@"2.7光缆接头盒",@"2.8尾纤故障(仅限光交接箱)",@"2.9光缆线路闪断",@"2.10级联上级光缆故障"],
                              @"其它原因":@[@"7.1雷击",@"7.2光缆线路割接",@"7.3传输设备割接",@"7.4动力配套割接",@"7.5主设备割接",@"7.6被盗",@"7.7无空调高温",@"7.8网络优化",@"7.9减扩容",@"7.10第三方公司人为操作不当",@"7.11运维单位人为操作不当",@"7.12甲方人为操作不当",@"7.13主停电整改不给发电",@"市局机房硬件故障或数据错误",@"7.15工程遗留隐患",@"7.16托管未纳入代维",@"7.17机房配套问题",@"7.18误告",@"7.19归属其他地市责任",@"7.20其它",@"7.21原因待查"],
                              @"停电类原因":@[@"1.1电池老化",@"1.2无电池",@"1.3无停电告警",@"1.4按地市联通分公司要求夜间不需要发电",@"1.5大面积停电无油机保障",@"1.6发电机停机但未能给电池充电",@"1.7发电过程中发电机发生故障",@"1.8级联上级停电后客观原因发电不及时导致光机掉电",@"1.9天气原因发不了是或不能及时发电",@"1.10道路原因不能到达发电或不能及时发电",@"1.11业主不在或发电机吵业主不给发电",@"1.12维护站发电人员响应速度慢",@"1.13维护站负责人安排不合理",@"1.14外聘发电人员发电不及时",@"1.15维护站负责人安排不及时",@"1.16级联上级停电后主观原因发电不及时导致的光端机掉电",@"1.17网管通知不及时",@"1.18停电后不明原因处理"],
                              @"天馈设备故障":@[@"9.1馈线故障",@"9.2天线故障",@"9.3塔放故障",@"9.4连接线缆及接头故障",@"9.5驻波比超标",@"9.6接地不好或无接地"],
                              @"主设备故障":@[@"5.1主设备吊死",@"5.2主设备闪断",@"5.3主控制故障",@"5.4载频故障",@"5.5合路器故障",@"5.6跳线",@"5.7连接线缆及接头故障",@"5.8电源板件故障",@"5.9背板故障",@"5.10其它板件故障",@"5.11主设备其它",@"5.12SBSC或RNC设备故障"]};
    ideaArray = @[@"故障己处理，请网管核实",@"故障己自动恢复，请网管核实",@"未验收工程问题，请转派处理"];
    reasonArray = [reasonDictionary allKeys];
//    chooseArray = [[NSArray alloc]init];
    [self initOrderDetailData];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView{
    
    CGRect viewRect = self.view.frame;
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, 250)];
    tableHeader.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    UILabel *labe1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    labe1.font = [UIFont systemFontOfSize:18];
    labe1.text = @"意见:";
    [tableHeader addSubview:labe1];
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(70, 0, kScreenWidth -80, 40)];
    
    UITapGestureRecognizer *chooseIdea = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseIdea)];
    [buttonView addGestureRecognizer:chooseIdea];
    ideaTextField= [[UITextField alloc]initWithFrame:CGRectMake(10, 5, buttonView.frame.size.width - 60, 30)];
    ideaTextField.frame = CGRectMake(0, 0, 200, 40);
    ideaTextField.font = [UIFont systemFontOfSize:18];
    ideaTextField.text = @"重要,请尽快处理。";
    ideaTextField.returnKeyType = UIReturnKeyDone;
    ideaTextField.delegate = self;
    [buttonView addSubview:ideaTextField];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0 , 40, buttonView.frame.size.width - 60, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    [buttonView addSubview:lineView1];
    
    UIImageView *ideaChooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(buttonView.frame.size.width-40-10, 5, 30, 30)];
    ideaChooseImage.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
    [buttonView addSubview:ideaChooseImage];
    [tableHeader addSubview:buttonView];
    //处理方法
    UILabel *dealMethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 40)];
    dealMethodLabel.font = [UIFont systemFontOfSize: 16];
    dealMethodLabel.text = @"处理方法:";
    [tableHeader addSubview:dealMethodLabel];
    dealMethodTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 50, kScreenWidth-110, 40)];
    dealMethodTextField.font = [UIFont systemFontOfSize:18];
    dealMethodTextField.returnKeyType = UIReturnKeyDone;
    dealMethodTextField.delegate = self;
    [tableHeader addSubview:dealMethodTextField];
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(100 , 90, kScreenWidth - 110, 1)];
    lineView4.backgroundColor = [UIColor grayColor];
    [tableHeader addSubview:lineView4];
    //故障原因
    UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 80, 40)];
    reasonLabel.font = [UIFont systemFontOfSize: 16];
    reasonLabel.text = @"故障原因:";
    [tableHeader addSubview:reasonLabel];
    reasonTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, kScreenWidth-110-50, 40)];
    reasonTextField.font = [UIFont systemFontOfSize:18];
    reasonTextField.returnKeyType = UIReturnKeyDone;
    reasonTextField.delegate = self;
    [tableHeader addSubview:reasonTextField];
    UIImageView *reasonChooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-40-10, 110, 30, 30)];
    reasonChooseImage.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
    UITapGestureRecognizer *reasonGesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(malfunctionReason)];
    reasonChooseImage.userInteractionEnabled = YES;
    [reasonChooseImage addGestureRecognizer:reasonGesure];
    [tableHeader addSubview:reasonChooseImage];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(100 , 140, kScreenWidth - 150, 1)];
    lineView2.backgroundColor = [UIColor grayColor];
    [tableHeader addSubview:lineView2];
    //原因小类
    UILabel *subReasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 80, 40)];
    subReasonLabel.font = [UIFont systemFontOfSize: 16];
    subReasonLabel.text = @"原因小类:";
    [tableHeader addSubview:subReasonLabel];
    
    subReasonTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 150, kScreenWidth-110-50, 40)];
    reasonTextField.font = [UIFont systemFontOfSize:18];
    reasonTextField.returnKeyType = UIReturnKeyDone;
    reasonTextField.delegate = self;
    [tableHeader addSubview:subReasonTextField];
    UIImageView *subReasonChooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-40-10, 160, 30, 30)];
    subReasonChooseImage.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
    UITapGestureRecognizer *subReasonGesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(malfunctionReasonSub)];
    subReasonChooseImage.userInteractionEnabled = YES;
    [subReasonChooseImage addGestureRecognizer:subReasonGesure];
    [tableHeader addSubview:subReasonChooseImage];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(100 , 190, kScreenWidth - 150, 1)];
    lineView3.backgroundColor = [UIColor grayColor];
    [tableHeader addSubview:lineView3];
    //备注信息
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 80, 40)];
    remarkLabel.font = [UIFont systemFontOfSize: 16];
    remarkLabel.text = @"备注信息:";
    [tableHeader addSubview:remarkLabel];
    remarkTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, kScreenWidth-110, 40)];
    remarkTextField.font = [UIFont systemFontOfSize:18];
    remarkTextField.returnKeyType = UIReturnKeyDone;
    remarkTextField.delegate = self;
    [tableHeader addSubview:remarkTextField];
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(100 , 240, kScreenWidth - 110, 1)];
    lineView5.backgroundColor = [UIColor grayColor];
    [tableHeader addSubview:lineView5];
    
    mainTable.tableHeaderView = tableHeader;
//    mainTable.contentSize = CGSizeMake(kScreenWidth, 200+250+60+12*44);
}

- (void)initAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"故障确认" message:@"是否进行到站确认" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    alert.delegate = self;
    [alert show];
}

- (void)initOrderDetailData{
    deatailOrder = [[NSDictionary alloc]init];
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:orderId forKey:@"id"];
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/load" targetClass:[NSDictionary class] completion:^(NSDictionary *resultDictionary, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }else{
            deatailOrder = resultDictionary;
            NSString *siteArrivalTime = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"siteArrivalTime"]];
            if ([siteArrivalTime isEqualToString:@"<null>"]) {
                [self initAlert];
            }
//            NSLog(@"%@",[deatailOrder objectForKey:@"faultSpecificTreatment"]);
            if (![[deatailOrder objectForKey:@"faultSpecificTreatment"] isKindOfClass:[NSNull class]]) {
                NSLog(@"faultSpecificTreatment:%@",[deatailOrder objectForKey:@"faultSpecificTreatment"]);
                dealMethodTextField.text = [deatailOrder objectForKey:@"faultSpecificTreatment"];
            }
            if (![[deatailOrder objectForKey:@"faultReason"] isKindOfClass:[NSNull class]]) {
                reasonTextField.text = [deatailOrder objectForKey:@"faultReason"];
            }
            if (![[deatailOrder objectForKey:@"faultReasonSub"] isKindOfClass:[NSNull class]]) {
                subReasonTextField.text = [deatailOrder objectForKey:@"faultReasonSub"];
            }
            if (![[deatailOrder objectForKey:@"remark"] isKindOfClass:[NSNull class]]) {
                remarkTextField.text = [deatailOrder objectForKey:@"remark"];
            }
        }
        [self reloadInputViews];
    } withMethod:HttpMethodPost];
}


//选择意见
- (void)chooseIdea{
    chooseArray = ideaArray;
    CHPopoverListView *listView = [[CHPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 300, ideaArray.count*44)];
    listView.datasource = self;
    listView.delegate = self;
    tag = 1;
    [listView show];
}
//选择原因
- (void)malfunctionReason{
    chooseArray = reasonArray;
    CHPopoverListView *listView;
    listView = [[CHPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 200, 44*chooseArray.count)];
    listView.delegate = self;
    listView.datasource = self;
    tag = 2;
    [listView show];
}

//原因小类
- (void)malfunctionReasonSub{
    if (reasonTextField.text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请选择原因" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else{
        reasonSubArray = [reasonDictionary objectForKey:reasonTextField.text];
        chooseArray = reasonSubArray;
        CHPopoverListView *listView;
        if (chooseArray.count*44<400) {
            listView = [[CHPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 300, 44*chooseArray.count)];
        }else{
            listView = [[CHPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
        }
        listView.delegate = self;
        listView.datasource = self;
        tag = 3;
        [listView show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark --故障保存
- (void)save{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    if (dealMethodTextField.text.length>0) {
        [requestDictionary setObject:dealMethodTextField.text forKey:@"faultSpecificTreatment"];//处理方法
    }
    if (reasonTextField.text.length>0) {
        [requestDictionary setObject:reasonTextField.text forKey:@"faultReason"];//原因
    }
    if (subReasonTextField.text.length>0) {
        [requestDictionary setObject:subReasonTextField.text forKey:@"faultReasonSub"];//详细
    }
    if (remarkTextField.text.length>0) {
        [requestDictionary setObject:remarkTextField.text forKey:@"remark"];//备注
    }
    if (ideaTextField.text.length>0) {
        [requestDictionary setObject:ideaTextField.text forKey:@"comment"];//意见
    }
    [requestDictionary setObject:orderId forKey:@"id"];
    [requestDictionary setObject:@"保存" forKey:@"actionName"];
    [self sendRequest:requestDictionary];
}

- (void)takeOrder{
    if (dealMethodTextField.text.length<5||reasonTextField.text.length==0||subReasonTextField.text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"处理方法不少于5个字且原因不能为空，请检查并完善处理信息" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
        if (remarkTextField.text.length>0) {
            [requestDictionary setObject:remarkTextField.text forKey:@"remark"];
        }
        [requestDictionary setObject:dealMethodTextField.text forKey:@"faultSpecificTreatment"];
        [requestDictionary setObject:reasonTextField.text forKey:@"faultReason"];
        [requestDictionary setObject:subReasonTextField.text forKey:@"faultReasonSub"];
        [requestDictionary setObject:orderId forKey:@"id"];
        [requestDictionary setObject:@"故障处理" forKey:@"actionName"];
        if (ideaTextField.text.length>0) {
            [requestDictionary setObject:ideaTextField.text forKey:@"comment"];
        }
        [self sendRequest:requestDictionary];
    }
}

- (void)sendBack{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    if (dealMethodTextField.text.length>0) {
        [requestDictionary setObject:dealMethodTextField.text forKey:@"faultSpecificTreatment"];
    }
    if (reasonTextField.text.length>0) {
        [requestDictionary setObject:reasonTextField.text forKey:@"faultReason"];
    }
    if (subReasonTextField.text.length>0) {
        [requestDictionary setObject:subReasonTextField.text forKey:@"faultReasonSub"];
    }
    if (remarkTextField.text.length>0) {
        [requestDictionary setObject:remarkTextField.text forKey:@"remark"];
    }
    if (ideaTextField.text.length>0) {
        [requestDictionary setObject:ideaTextField.text forKey:@"comment"];
    }
    [requestDictionary setObject:orderId forKey:@"id"];
    [requestDictionary setObject:@"退单" forKey:@"actionName"];
    [self sendRequest:requestDictionary];
}

- (void)layAside{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    if (dealMethodTextField.text.length>0) {
        [requestDictionary setObject:dealMethodTextField.text forKey:@"faultSpecificTreatment"];
    }
    if (reasonTextField.text.length>0) {
        [requestDictionary setObject:reasonTextField.text forKey:@"faultReason"];
    }
    if (subReasonTextField.text.length>0) {
        [requestDictionary setObject:subReasonTextField.text forKey:@"faultReasonSub"];
    }
    if (remarkTextField.text.length>0) {
        [requestDictionary setObject:remarkTextField.text forKey:@"remark"];
    }
    if (ideaTextField.text.length>0) {
        [requestDictionary setObject:ideaTextField.text forKey:@"comment"];
    }
    [requestDictionary setObject:orderId forKey:@"id"];
    [requestDictionary setObject:@"故障挂起" forKey:@"actionName"];
    [self sendRequest:requestDictionary];
}



- (void)sendRequest:(NSMutableDictionary*)requestDictionary{
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/faultHandle" targetClass:[NSString class] completion:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"%@出错%@",[requestDictionary objectForKey:@"actionName"],error);
            [AlertShowWithString alertShowWithString:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }else{
            [AlertShowWithString alertShowWithString:[NSString stringWithFormat:@"%@成功",[requestDictionary objectForKey:@"actionName"]]];
            if (self.completion) {
                self.completion(true);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }

    } withMethod:HttpMethodPost];
}



#pragma mark --CHPopoverListView dataSouce delegate

- (NSInteger)popoverListView:(CHPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  chooseArray.count;
}

- (UITableViewCell *)popoverListView:(CHPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identitfier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identitfier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identitfier];
    }
    cell.textLabel.text = chooseArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    return cell;
}

- (void)popoverListView:(CHPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tag == 1) {
        ideaTextField.text = chooseArray[indexPath.row];
    }else if(tag == 2){
        reasonTextField.text = reasonArray[indexPath.row];
        subReasonTextField.text = @"";
    }else{
        subReasonTextField.text = reasonSubArray[indexPath.row];
    }
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    [tableView touchForDismissSelf];
}

- (void)popoverListView:(CHPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [reasonTextField resignFirstResponder];
    [subReasonTextField resignFirstResponder];
    [ideaTextField resignFirstResponder];
    [dealMethodTextField resignFirstResponder];
    [remarkTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [reasonTextField resignFirstResponder];
    [subReasonTextField resignFirstResponder];
    [ideaTextField resignFirstResponder];
    [dealMethodTextField resignFirstResponder];
    [remarkTextField resignFirstResponder];
    return YES;
}


#pragma mark -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
        [requestDictionary setObject:orderId forKey:@"id"];
        [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/ToStationConfirm" targetClass:[NSString class] completion:^(NSString *resultString, NSError *error) {
        } withMethod:HttpMethodPost];
    }
}

- (void) handleMenu:(NSInteger)index
{
    switch (index) {
        case 0:
            //故障保存
            [self save];
            break;
        case 1:
            [self takeOrder];
            break;
        case 2:
            [self sendBack];
            break;
        case 3:
            [self layAside];
            break;
        default:
            break;
    }
}


@end
