//
//  LoginViewController.m
//  Mars
//
//  Created by jiamai on 15/9/29.
//  Copyright (c) 2015年 runsdata. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "MainViewController.h"
#import "Constant.h"
#import "AppDelegate.h"
//#import "HttpNetworkManager.h"
#import "RSLeftMenuViewController.h"
#import "EstimateEquipmentType.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
//@property (weak, nonatomic) IBOutlet UINavigationBar *loginNavigationBar;

@end



@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.loginNavigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back123"]];
    self.password.secureTextEntry = YES;
    self.userName.delegate = self;
    self.password.delegate = self;
    _iconImage.layer.cornerRadius = 40;
    _iconImage.layer.masksToBounds = true;
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back123"]];
    //    self.list;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)login:(id)sender {
    NSString *username = self.userName.text;
    NSString *password = self.password.text;
    if(![HttpNetworkManager isExistNetwork]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *localUsername = [defaults objectForKey:@"username"];
        NSString *localPassword = [defaults objectForKey:@"password"];
        
        if ([username isEqualToString:localUsername]&&[password isEqualToString:localPassword]) {
            [[AppDelegate sharedApplicationDelegate] signToMain];
            [SVProgressHUD showInfoWithStatus:@"离线登录成功" maskType:SVProgressHUDMaskTypeGradient];
        }else{
            [SVProgressHUD showInfoWithStatus:@"离线登录失败，用户名密码必须是上一个用户" maskType:SVProgressHUDMaskTypeGradient];
        }
    }else{
        if (username.length<1||password.length<1) {
            [[[UIAlertView alloc]initWithTitle:nil message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else{
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *versionBuild = [infoDictionary objectForKey:@"CFBundleVersion"];//CFBundleShortVersionString前面是build号，后面是版本号
            NSMutableDictionary *requestData = [[NSMutableDictionary alloc]init];
            [requestData setObject:username forKey:@"username"];
            [requestData setObject:password forKey:@"password"];
            [requestData setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"deviceId"];
            [requestData setObject:@"iOS" forKey:@"clientType"];
            [requestData setObject:versionBuild forKey:@"clientVersion"];
            [requestData setObject:[[EstimateEquipmentType sharedInstance] estimateEquipmentType] forKey:@"deviceDescription"];
            [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
            [HttpNetworkManager request:requestData withPath:@"/public/api/system/sysBpsUsers/login" targetClass:[NSString class] completion:^(NSString *result, NSError *error) {
                [SVProgressHUD dismiss];
                if (error) {
                    NSLog(@"Error:%@",error.description);
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"登录失败,原因:%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }else{
                    NSString *token = result;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:token forKey:@"token"];
                    [defaults setValue:username forKey:@"username"];
                    [defaults setValue:password forKey:@"password"];
                    [AppDelegate sharedApplicationDelegate].token = [defaults objectForKey:@"token"];
                    [[AppDelegate sharedApplicationDelegate] vaildToken];
                }
            } withMethod:HttpMethodPost];
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
