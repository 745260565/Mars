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
#import "AllocateDetailViewController.h"
#import "LayAsideDetailViewController.h"
#import "TransactOrderDetailViewController.h"
#import "DealOrderDetailViewController.h"

@interface MainViewController () <UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@end

@implementation MainViewController
{
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIView *cView;
    UITableView *cTableView;
    NSArray *malfunctionDataArray;
    
    NSArray *categoryArray;
    NSMutableArray *caegoriesTitleArray;
    float titleViewWidth;
    float titleViewHeight;
    UIView *tabIndicatorView;
    UIScrollView *tabScrollView;
    NSInteger taskSelectedIndex;
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
    cView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 44*5+44)];
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
    cTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth-20, 44*5)];
    cTableView.bounces = NO;
    cTableView.delegate = self;
    cTableView.dataSource = self;
    [cView addSubview:cTableView];
    cView.backgroundColor = [AppDelegate sharedApplicationDelegate].backgroundGrayColor;
    titleViewWidth = (kScreenWidth -20)/4;
    titleViewHeight = 44;
    tabScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 44)];
    tabScrollView.showsHorizontalScrollIndicator = NO;
    
    caegoriesTitleArray = [NSMutableArray array];
    categoryArray = @[@"故障",@"线路",@"隐患",@"基站"];
    for (int i = 0; i<categoryArray.count; i++) {
        NSString *title = [categoryArray objectAtIndex:i];
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(i*titleViewWidth, 0, titleViewWidth, titleViewHeight)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleViewWidth, titleViewHeight)];
        [label setText:title];
        [label setTextAlignment:NSTextAlignmentCenter];
        if (i ==0) {
            [label setTextColor:[AppDelegate sharedApplicationDelegate].tintColor];
        }else{
            label.textColor = [UIColor blackColor];
        }
        [caegoriesTitleArray addObject:label];
        [titleView addSubview:label];
        titleView.tag = i;
        [titleView setUserInteractionEnabled:YES];
        [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabTapHandler:)]];
        [tabScrollView addSubview:titleView];
    }
    tabScrollView.contentSize = CGSizeMake(categoryArray.count*titleViewWidth, 44);
    tabIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, titleViewWidth, 3)];
    [tabIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tabIndicatorView setBackgroundColor:[AppDelegate sharedApplicationDelegate].tintColor];
    [tabScrollView addSubview:tabIndicatorView];
    [cView addSubview:tabScrollView];
    [self loadTableViewData1];
}

- (void)tabTapHandler:(UITapGestureRecognizer*)gestureRecognizer{
    NSInteger index = [[gestureRecognizer view] tag];
    [self animateToTabAtIndex:index];
    taskSelectedIndex = index;
    switch (index) {
        case 0:
            [self loadTableViewData1];
            break;
        case 1:
            [self loadTableViewData2];
            break;
        case 2:
            [self loadTableViewData3];
            break;
        case 3:
            [self loadTableViewData4];
            break;
        default:
            break;
    }
}

- (void)animateToTabAtIndex:(NSInteger)index {
    [self animateToTabAtIndex:index animated:YES];
}

- (void)animateToTabAtIndex:(NSInteger)index animated:(BOOL)animated{
    for (int i = 0; i<caegoriesTitleArray.count; i++) {
        UILabel *label = [caegoriesTitleArray objectAtIndex:i];
        if (i == index) {
            label.textColor = [AppDelegate sharedApplicationDelegate].tintColor;
        }else{
            label.textColor = [UIColor blackColor];
        }
    }
    CGFloat animateDuration = 0.4f;
    if (!animated) {
        animateDuration = 0.0f;
    }
    [UIView animateWithDuration:animateDuration animations:^{
        tabIndicatorView.center = CGPointMake((index+0.5)*titleViewWidth, tabIndicatorView.center.y);
    } completion:^(BOOL finished) {
        if (finished) {
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            float width = screenSize.width;
            if (titleViewWidth*(index+1)>tabScrollView.contentOffset.x+width) {
                [tabScrollView scrollRectToVisible:CGRectMake(titleViewWidth * (index + 1) - width, tabScrollView.contentOffset.y, width, titleViewHeight) animated:YES];
            }else if (titleViewWidth * index  < tabScrollView.contentOffset.x) {
                [tabScrollView scrollRectToVisible:CGRectMake(titleViewWidth * index, tabScrollView.contentOffset.y, width, titleViewHeight) animated:YES];
            }
        }
    }];
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
//    [requestDictionary setObject:@"5" forKey:@"size"];
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

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    switch (taskSelectedIndex) {
        case 0:
        {
            NSDictionary *orderDictionary = [malfunctionDataArray objectAtIndex:indexPath.row];
            NSString *stateString = [orderDictionary objectForKey:@"faultState"];
            if ([stateString isEqualToString:@"已派单"]) {
                AllocateDetailViewController *viewController = [[AllocateDetailViewController alloc] initWithId:[orderDictionary objectForKey:@"id"] withHandleMenus:@[@"故障分派",@"退单"]];
                viewController.completion = ^void (BOOL needRefresh){
                    if (needRefresh) {
                        [self loadTableViewData1];
                    }
                };
                [self.navigationController pushViewController:viewController animated:YES];
            }else if ([stateString isEqualToString:@"待处理"]||[stateString isEqualToString:@"处理中"]) {
                TransactOrderDetailViewController *viewController = [[TransactOrderDetailViewController alloc] initWithId:[orderDictionary objectForKey:@"id"] withHandleMenus:@[@"故障保存",@"故障处理",@"退单",@"故障挂起"]];
                viewController.completion = ^void (BOOL needRefresh){
                    if (needRefresh) {
                        [self loadTableViewData1];
                    }
                };
                [self.navigationController pushViewController:viewController animated:YES];
            }else if([stateString isEqualToString:@"待确认"]) {
                DealOrderDetailViewController *viewController = [[DealOrderDetailViewController alloc] initWithId:[orderDictionary objectForKey:@"id"] withHandleMenus:@[@"故障确认",@"退单"]];
                viewController.completion = ^void (BOOL needRefresh){
                    if (needRefresh) {
                        [self loadTableViewData1];
                    }
                };
                [self.navigationController pushViewController:viewController animated:YES];
            }else if([stateString isEqualToString:@"已挂起"]||[stateString isEqualToString:@"待挂起"]) {
                NSArray *menuArray = nil;
                if ([stateString isEqualToString:@"待挂起"]) {
                    menuArray = @[@"通过",@"驳回"];
                }else{
                    menuArray = @[@"解除挂起"];
                }
                LayAsideDetailViewController *viewController = [[LayAsideDetailViewController alloc] initWithId:[orderDictionary objectForKey:@"id"] withHandleMenus:menuArray];
                viewController.completion = ^void (BOOL needRefresh){
                    if (needRefresh) {
                        [self loadTableViewData1];
                    }
                };
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
            break;
        default:
            break;
    }
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
