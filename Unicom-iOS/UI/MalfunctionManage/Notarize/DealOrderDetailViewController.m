//
//  DealOrderDetailViewController.m
//  Mars
//
//  Created by jiamai on 15/11/9.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "DealOrderDetailViewController.h"
#import "Constant.h"
#import "CHPopoverListView.h"
#import "HttpNetworkManager.h"
#import "AlertShowWithString.h"

@interface DealOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CHPopoverListDatasource,CHPopoverListDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    NSDictionary *detailOrder;
    NSArray *chooseArray;
    UITextField *ideaTextField;
}
@end

@implementation DealOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.title = @"故障确认详情";
    // Do any additional setup after loading the view from its nib.
}

- (void)initView{
    CGRect viewRect = self.view.frame;
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, 50)];
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
    mainTable.tableHeaderView = tableHeader;
}

#pragma mark --textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [ideaTextField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)allot{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setValue:@"故障确认" forKey:@"actionName"];
    [requestDictionary setValue:orderId forKey:@"id"];
    if (ideaTextField.text.length>0) {
        [requestDictionary setObject:ideaTextField.text forKey:@"comment"];
    }
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/faultConfirm" targetClass:[NSString class] completion:^(NSString *resultString, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
                [AlertShowWithString alertShowWithString:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            }else{
                NSLog(@"resultString:%@",resultString);
                [AlertShowWithString alertShowWithString:@"故障确认成功"];
                if (self.completion) {
                    self.completion(true);
                }
                [self.navigationController popViewControllerAnimated:YES];

            }
        } withMethod:HttpMethodPost];
}

- (void)sendBack{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setValue:@"退单" forKey:@"actionName"];
    [requestDictionary setValue:orderId forKey:@"id"];
    if (ideaTextField.text.length>0) {
        [requestDictionary setObject:ideaTextField.text forKey:@"comment"];
    }
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/faultConfirm" targetClass:[NSString class] completion:^(NSString *resultString, NSError *error) {
        if (error) {
            NSLog(@"退单error:%@",error);
            [AlertShowWithString alertShowWithString:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }else{
            [AlertShowWithString alertShowWithString:@"退单成功"];
            if (self.completion) {
                self.completion(true);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } withMethod:HttpMethodPost];
}

- (void) handleMenu:(NSInteger)index
{
    switch (index) {
        case 0:
            //故障处理
            [self allot];
            break;
        case 1:
            [self sendBack];
        default:
            break;
    }
}


- (void)chooseIdea{
    chooseArray = @[@"己确认，尽快安排处理",@"任务多，需协助。",@"休假中，请转派其他同事",@"未交维，请转派工程处理",@"请转其他专业"];
    CHPopoverListView *listView = [[CHPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 260, 44*chooseArray.count)];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [ideaTextField resignFirstResponder];
}


#pragma mark CHPopoverListView dataSouce delegate
- (NSInteger)popoverListView:(CHPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section{
    return chooseArray.count;
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
    ideaTextField.text = chooseArray[indexPath.row];
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    [tableView touchForDismissSelf];
}

- (void)popoverListView:(CHPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
}


@end
