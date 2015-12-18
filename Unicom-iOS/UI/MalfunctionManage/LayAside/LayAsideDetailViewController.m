//
//  LayAsideDetailViewController.m
//  Mars
//
//  Created by jiamai on 15/11/10.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "LayAsideDetailViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "AlertShowWithString.h"

@interface LayAsideDetailViewController ()
@property (nonatomic,retain)UITextField *descriptionTextField;
@end

@implementation LayAsideDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.title = @"故障分派详情";
    // Do any additional setup after loading the view from its nib.
}

- (void)initView{
    
    CGRect viewRect = self.view.frame;
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, 100)];
    tableHeader.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
    label1.text = @"事件描述:";
    [tableHeader addSubview:label1];
    
    self.descriptionTextField = [[UITextField alloc]initWithFrame:CGRectMake(90,10 , kScreenWidth-10-90, 80)];
    self.descriptionTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.descriptionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.descriptionTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.descriptionTextField.returnKeyType = UIReturnKeyDone;
    self.descriptionTextField.delegate = self;
    [tableHeader addSubview:self.descriptionTextField];
    
    mainTable.tableHeaderView = tableHeader;
    
    
    
}


- (void)agreeToLayAside{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:orderId forKey:@"id"];
    [requestDictionary setObject:@"同意" forKey:@"actionName"];
    [self sendRequest:requestDictionary];
}

- (void)disagree{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:orderId forKey:@"id"];
    [requestDictionary setObject:@"驳回" forKey:@"actionName"];
    [self sendRequest:requestDictionary];
}

- (void)sendRequest:(NSMutableDictionary*)requestDictionary{
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/faultPending" targetClass:[NSString class] completion:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"%@出错%@",[requestDictionary objectForKey:@"actionName"],error);
            [AlertShowWithString alertShowWithString:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }else{

            [AlertShowWithString alertShowWithString:[NSString stringWithFormat:@"%@成功",[requestDictionary objectForKey:@"actionName"]]];
            //[[NSNotificationCenter defaultCenter] postNotificationName:LayAsideReload object:nil];//发送能知
            if (self.completion) {
                self.completion(true);
            }
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"request:%@",result);
        }
        
    } withMethod:HttpMethodPost];
}


- (void)disLayAside{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:orderId forKey:@"id"];
    [requestDictionary setObject:@"解除挂起" forKey:@"actionName"];
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/faultClosePending" targetClass:[NSString class] completion:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"%@出错%@",[requestDictionary objectForKey:@"actionName"],error);
            [AlertShowWithString alertShowWithString:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }else{
            [AlertShowWithString alertShowWithString:[NSString stringWithFormat:@"%@成功",[requestDictionary objectForKey:@"actionName"]]];
            //[[NSNotificationCenter defaultCenter] postNotificationName:LayAsideReload object:nil];//发送能知
            if (self.completion) {
                self.completion(true);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } withMethod:HttpMethodPost];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.descriptionTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.descriptionTextField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) handleMenu:(NSInteger)index
{
    NSString *faultState = [orderDetail objectForKey:@"faultState"];

    if ([faultState isEqualToString:@"待挂起"]) {
        switch (index) {
            case 0:
                //通过
                [self agreeToLayAside];
                break;
            case 1:
                [self disagree];
            default:
                break;
        }
    }else{
        [self disLayAside];
    }
}
@end
