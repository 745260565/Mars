//
//  RSLeftMenuViewController.m
//  NewMars
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "RSLeftMenuViewController.h"
#import "AppDelegate.h"
#import "MalfuctionSwitchVC.h"
#import "LineManageSwitchVC.h"
//#import "LoginViewController.h"

@interface RSLeftMenuViewController ()

@property (nonatomic, strong) NSMutableArray *ListArray;
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, strong) NSMutableArray *lineManage;
@property (nonatomic, strong) NSMutableArray *MalfunctionTitleArray;
@property (nonatomic, strong) NSMutableArray *LineManageTitleArray;
@end

@implementation RSLeftMenuViewController
{
    UITableView *menuTable;
    bool boolArray[10];
}
#pragma mark - 控制器初始化方法
@synthesize menuViewSize;
- (instancetype) init
{
    self = [super init];
    if(self)
    {
        menuViewSize = CGSizeMake(224, kScreenHeight);
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    [self setupUI];
    [self initData];
    [self buildLayout];
}
- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) buildLayout
{
    CGRect viewRect = self.view.frame;
    
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuViewSize.width, menuViewSize.height)];
    
    //UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"system_menu_header"]];
    //[mainView addSubview:headerImage];
    
    menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, menuViewSize.width, viewRect.size.height)];
    menuTable.dataSource = self;
    menuTable.delegate = self;
    menuTable.backgroundColor = [UIColor clearColor];
    [mainView addSubview:menuTable];
    
    UIButton *signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signinButton.frame = CGRectMake(menuViewSize.width - 30, 4, 23, 21);
    [signinButton setBackgroundImage:[UIImage imageNamed:@"menu_item_button"] forState:UIControlStateNormal];
    [signinButton addTarget:self action:@selector(checkSignin:) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 30)];
    [footerView addSubview:signinButton];
    menuTable.tableFooterView = footerView;
    
    [self.view addSubview:mainView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInformactionChanged:) name:@"userInformactionChanged" object:nil];
}
- (void) userInformactionChanged:(NSNotification *)notification
{
    NSDictionary *dataDictionary = notification.userInfo;
    NSString *name = [dataDictionary objectForKey:@"name"];
    
}

- (void) favoriteButton:(id)sender
{
    }
- (void) reserveButton:(id)sender
{
}
- (void) serviceButton:(id)sender
{
    
}
- (void) checkSignin:(id)sender
{
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            if (boolArray[section-1]) {
                return 4;
            }else{
                return 0;
            }
            break;
        case 5:
            if (boolArray[section-1]) {
                return 6;
            }else{
                return 0;
            }
            break;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, menuViewSize.width, 44)];
    hView.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        UIView *hView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, menuViewSize.width, 99)];
        hView1.backgroundColor = [UIColor clearColor];
        UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(60, 5, 50, 50)];
        userImage.image = [UIImage imageNamed:@"sidebar-boy"];
        [hView1 addSubview:userImage];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 160, 20)];
        nameLabel.text = [AppDelegate sharedApplicationDelegate].currentUserEntity.userName;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [hView1 addSubview:nameLabel];
        return hView1;
    }else if(section ==11){
        UILabel *label = [[UILabel alloc]initWithFrame:hView.frame];
        label.text = @"            退出";
        label.font = [UIFont systemFontOfSize:18];
        [hView addSubview:label];
        UITapGestureRecognizer *signOut = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signout:)];
        [hView addGestureRecognizer:signOut];
        return hView;
    }else{
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
        iconImageView.image = [UIImage imageNamed:_imageList[section-1]];
        [hView addSubview:iconImageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(44, 0, menuViewSize.width-44-44, 44)];
        label.text = _ListArray[section-1];
        [hView addSubview:label];
        UIImageView *chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(menuViewSize.width-30, 8, 24, 24)];
        if (boolArray[section-1]) {
            chooseImage.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
        }else{
            chooseImage.image = [UIImage imageNamed:@"iconfont-angledoubleright.png"];
        }
        [hView addSubview:chooseImage];
        UITapGestureRecognizer *signOut = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDetail:)];
        hView.tag = section-1;
        [hView addGestureRecognizer:signOut];
        return hView;
    }
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 99;
    }else{
        return 44;
    }
}

- (void)chooseDetail:(UITapGestureRecognizer *)sender{
    boolArray[[sender view].tag] = !boolArray[[sender view].tag];
    [menuTable reloadData];
}

- (void) signout:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
    [[AppDelegate sharedApplicationDelegate] signout];
}

- (void)setupUI
{
    _tableViewLeft.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"report_0008_bg"]];
}

- (void)initData
{
    _ListArray = [[NSMutableArray alloc]initWithObjects:@"故障管理",@"基站巡检", @"隐患管理",@"资产核查", @"线路管理",@"报表", @"线路段数据",@"转维验收报表", @"传输动力隐患报表",@"线路巡检报表",nil];
    _imageList = [[NSMutableArray alloc]initWithObjects:@"sidebar_icon_healthreport",@"sidebar_icon_setting", @"sidebar-Email",@"sidebar-Friend", @"sidebar-manege",@"report_0004_report_01_Diagram",@"sidebar_icon_setting", @"report_0005_report_02_Diagram",@"sidebar_icon_setting", @"sidebar_icon_setting",@"", nil];
    _MalfunctionTitleArray = [[NSMutableArray alloc]initWithObjects:@"故障分派",@"故障确认",@"故障处理",@"故障挂起", nil];
    _LineManageTitleArray = [[NSMutableArray alloc]initWithObjects:@"采集分派",@"线路采集",@"巡检分派",@"定位巡检",@"三盯/自动巡检",@"线路断点",nil];
    for (int i =0; i<10; i++) {
        boolArray[i] = NO;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (section == 1) {
        cell.textLabel.text = _MalfunctionTitleArray[row];
    }else if (section ==5){
        cell.textLabel.text = _LineManageTitleArray[row];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:16.0/255 green:164.0/255 blue:231.0/255 alpha:1.0f];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor clearColor];
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 1:
            //故障管理
        {
            [[AppDelegate sharedApplicationDelegate] hiddenLeftMenu :^(BOOL finished){
                if (finished){
                    NSLog(@"finished");
                }
                //                MalfuctionSwitchVC *slideSwitchVC = [[MalfuctionSwitchVC alloc] init];
                MalfuctionSwitchVC *slideSwitchVC = [[MalfuctionSwitchVC alloc] initWithInitialIndex:row];
                [self.targetNavigationController pushViewController:slideSwitchVC animated:YES];
            }];
        }
            break;
//        case 5:{//线路管理
//            [[AppDelegate sharedApplicationDelegate] hiddenLeftMenu:^(BOOL finished) {
//                if (finished) {
//                    NSLog(@"finished");
//                }
//                LineManageSwitchVC *lmsVC = [[LineManageSwitchVC alloc]initWithInitialIndex:row];
//                [self.targetNavigationController pushViewController:lmsVC animated:YES];
//            }];
//        }
        default:
            break;
    }
    
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
