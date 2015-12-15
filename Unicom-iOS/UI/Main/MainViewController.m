//
//  MainViewController.m
//  NewMars
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "AccordionView.h"

@interface MainViewController () <UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@end

@implementation MainViewController
{
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIView *cView;
    UIView *lView1;
    UIView *lView2;
    UIView *lView3;
    UIView *lView4;
    UITableView *cTableView;
    NSArray *malfunctionDataArray;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    malfunctionDataArray = [[NSArray alloc]init];
    // Do any additional setup after loading the view.
    [self buildLayout];
    [self buildAccordionView];
    [self initData];
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
- (void) buildLayout
{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"现场运维";
    UIImageView *portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    portraitView.layer.masksToBounds = YES;
    portraitView.layer.cornerRadius = portraitView.bounds.size.width/2;
    portraitView.layer.borderWidth = 2;
    portraitView.layer.borderColor = [[UIColor whiteColor] CGColor];
    //if([AppDelegate sharedApplicationDelegate].token == nil || [AppDelegate sharedApplicationDelegate].currentUserEntity == nil)
    //{
    portraitView.image = [UIImage imageNamed:@"photo_placeholder"];
    //}
    //else
    //{
    //    [portraitView setImageWithURL:[NSURL URLWithString:[AppDelegate sharedApplicationDelegate].currentUserEntity.memberFace] placeholderImage:[UIImage imageNamed:@"photo_placeholder"]];
    //}
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accountButton.frame = CGRectMake(0, 0, 38, 38);
    [accountButton addSubview:portraitView];
    UIBarButtonItem *accountBarButton = [[UIBarButtonItem alloc] initWithCustomView:accountButton];
    [accountButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = accountBarButton;
    
    self.navigationController.delegate = self;

    [[AppDelegate sharedApplicationDelegate] setLeftMenuTargetNac:self.navigationController];
    
    
}

- (void)buildAccordionView{
    AccordionView *av = [[AccordionView alloc]initWithFrame:CGRectMake(10, 110, kScreenWidth-20, kScreenHeight-120)];
    UIButton *aButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 45)];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 40, 20)];
    label1.text = @"公告:";
    [aButton addSubview:label1];
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 5)];
    lineView1.backgroundColor = self.view.backgroundColor;
    [aButton addSubview:lineView1];
    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-20-20, 15, 20, 20)];
    imageView1.image = [UIImage imageNamed:@"iconfont-angledoubleright.png"];
    [aButton addSubview:imageView1];
    [aButton addTarget:self action:@selector(choose1:) forControlEvents:UIControlEventTouchUpInside];
    //    av.backgroundColor = [UIColor orangeColor];
    aButton.backgroundColor = [UIColor colorWithRed:16.0/255 green:164.0/255 blue:240.0/255 alpha:1.0f];
    
    UITableView *aTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 44*2) style:UITableViewStylePlain];
//    aTableView.backgroundColor = [UIColor redColor];
    
    
    UIButton *bButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 45)];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 40, 20)];
    label2.text = @"通报:";
    [bButton addSubview:label2];
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 5)];
    lineView2.backgroundColor = self.view.backgroundColor;
    [bButton addSubview:lineView2];
    imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-20-20, 15, 20, 20)];
    imageView2.image = [UIImage imageNamed:@"iconfont-angledoubleright.png"];
    [bButton addSubview:imageView2];
    bButton.backgroundColor = [UIColor colorWithRed:16.0/255 green:164.0/255 blue:220.0/255 alpha:1.0f];
    [bButton addTarget:self action:@selector(choose2:) forControlEvents:UIControlEventTouchUpInside];
    UITableView *bTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 44*4) style:UITableViewStylePlain];
//    bTableView.backgroundColor = [UIColor grayColor];
    
    
    UIButton *cButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 45)];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
    label3.text = @"我的任务";
    [cButton addSubview:label3];
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 5)];
    lineView3.backgroundColor = self.view.backgroundColor;
    [cButton addSubview:lineView3];
    imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-20-20, 15, 20, 20)];
    imageView3.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
    [cButton addSubview:imageView3];
    cButton.selected = YES;
    cButton.backgroundColor = [UIColor colorWithRed:16.0/255 green:164.0/255 blue:200.0/255 alpha:1.0f];
    [cButton addTarget:self action:@selector(choose3:) forControlEvents:UIControlEventTouchUpInside];
    cView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 44*5+40)];
    [self buildCView];
    [av addHeader:aButton withView:aTableView];
    [av addHeader:bButton withView:bTableView];
    [av addHeader:cButton withView:cView];
    
    
    [self.view addSubview:av];
    [av setNeedsLayout];
//    [av setAllowsEmptySelection:YES];
    [av setAllowsMultipleSelection:YES];
}

- (void)buildCView{
    cTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth-20, 44*5)];
    cTableView.bounces = NO;
    [cView addSubview:cTableView];
    cView.backgroundColor = [AppDelegate sharedApplicationDelegate].backgroundGrayColor;
    CGFloat lWidth = (kScreenWidth-20)/4;
    CGFloat lHeight = 40;
    button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, lWidth, lHeight)];
    button2 = [[UIButton alloc]initWithFrame:CGRectMake(lWidth, 0,lWidth, lHeight)];
    button3 = [[UIButton alloc]initWithFrame:CGRectMake(2*lWidth, 0, lWidth, lHeight)];
    button4 = [[UIButton alloc]initWithFrame:CGRectMake(3*lWidth, 0, lWidth, lHeight)];
    [button1 setTitle:@"故障" forState:UIControlStateNormal];
    [button2 setTitle:@"线路" forState:UIControlStateNormal];
    [button3 setTitle:@"隐患" forState:UIControlStateNormal];
    [button4 setTitle:@"基站" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cView addSubview:button1];
    [cView addSubview:button2];
    [cView addSubview:button3];
    [cView addSubview:button4];
    lView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 35, lWidth, 5)];
    lView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 35, lWidth, 5)];
    lView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 35, lWidth, 5)];
    lView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 35, lWidth, 5)];
    lView1.backgroundColor = [AppDelegate sharedApplicationDelegate].tintColor;
    lView2.backgroundColor = [AppDelegate sharedApplicationDelegate].tintColor;
    lView3.backgroundColor = [AppDelegate sharedApplicationDelegate].tintColor;
    lView4.backgroundColor = [AppDelegate sharedApplicationDelegate].tintColor;
    [button1 addSubview:lView1];
    [button2 addSubview:lView2];
    [button3 addSubview:lView3];
    [button4 addSubview:lView4];
    lView2.hidden = YES;
    lView3.hidden = YES;
    lView4.hidden = YES;
    
    [button1 addTarget:self action:@selector(tapButton1:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(tapButton2:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(tapButton3:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(tapButton4:) forControlEvents:UIControlEventTouchUpInside];
    cTableView.delegate = self;
    cTableView.dataSource = self;
    [self loadTableViewData1];
}

- (void)tapButton1:(UIButton *)sender{
    lView1.hidden = NO;
    lView2.hidden = YES;
    lView3.hidden = YES;
    lView4.hidden = YES;
    [self loadTableViewData1];
}

- (void)tapButton2:(UIButton *)sender{
    lView1.hidden = YES;
    lView2.hidden = NO;
    lView3.hidden = YES;
    lView4.hidden = YES;
    [self loadTableViewData2];
}

- (void)tapButton3:(UIButton *)sender{
    lView1.hidden = YES;
    lView2.hidden = YES;
    lView3.hidden = NO;
    lView4.hidden = YES;
    [self loadTableViewData3];
}

- (void)tapButton4:(UIButton *)sender{
    lView1.hidden = YES;
    lView2.hidden = YES;
    lView3.hidden = YES;
    lView4.hidden = NO;
    [self loadTableViewData4];
}

- (void)choose1:(UIButton*)sender{
    if (sender.selected) {
        imageView1.image = [UIImage imageNamed:@"iconfont-angledoubleright.png"];
    }else{
        imageView1.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
    }

}

- (void)choose2:(UIButton*)sender{
    if (sender.selected) {
        imageView2.image = [UIImage imageNamed:@"iconfont-angledoubleright.png"];
    }else{
        imageView2.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
    }
    
}

- (void)choose3:(UIButton*)sender{
    if (sender.selected) {
        imageView3.image = [UIImage imageNamed:@"iconfont-angledoubleright.png"];
    }else{
        imageView3.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
    }
    
}

- (void)loadTableViewData1{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:@[@"待确认",@"已挂起",@"待挂起",@"待处理",@"处理中",@"已派单"] forKey:@"faultState"];
    [requestDictionary setObject:@"5" forKey:@"size"];
    [requestDictionary setObject:@"true" forKey:@"myTask"];
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/list" targetClass:[NSDictionary class] completion:^(NSDictionary *resultDictionary, NSError *error) {
        if(error){
            
        }else{
            NSLog(@"resultDictionary%@",resultDictionary);
            malfunctionDataArray = [resultDictionary objectForKey:@"content"];
            [cTableView reloadData];
        }
    } withMethod:HttpMethodPost];
}

- (void)loadTableViewData2{
    malfunctionDataArray = nil;
    [cTableView reloadData];
}

- (void)loadTableViewData3{
    malfunctionDataArray = nil;
    [cTableView reloadData];
}

- (void)loadTableViewData4{
    malfunctionDataArray = nil;
    [cTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return malfunctionDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identitfier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identitfier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identitfier];
    }
    NSDictionary *itemDictionary = [[NSDictionary alloc]init];
    itemDictionary = malfunctionDataArray[indexPath.row];
    cell.textLabel.text = [itemDictionary objectForKey:@"siteName"];
    cell.detailTextLabel.text = [itemDictionary objectForKey:@"faultAppearTime"];
    return cell;
}


- (void) initData
{
    self.userNameText.text = [AppDelegate sharedApplicationDelegate].currentUserEntity.userName;
}
- (void)showMenu:(id)sender
{
  //  [[AppDelegate sharedApplicationDelegate] showMenuTo:self.navigationController];
    [[AppDelegate sharedApplicationDelegate] showLeftMenu:self.navigationController];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger num = navigationController.viewControllers.count ;
    NSLog(@"navigationController num %u",num );
    if (num < 2) {
        [[AppDelegate sharedApplicationDelegate]setMMDrawerControllerRecognizeTouch];
    }else {
        [[AppDelegate sharedApplicationDelegate]setMMDrawerControllerUnRecognizeTouch];
    }
}

@end
