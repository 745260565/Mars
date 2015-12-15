//
//  CollectionMessageViewController.m
//  Mars
//
//  Created by jiamai on 15/11/25.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "CollectionMessageViewController.h"

@interface CollectionMessageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *GPSButton;
@property (weak, nonatomic) IBOutlet UIButton *netButton;
@property (weak, nonatomic) IBOutlet UIButton *autoButton;
@property (weak, nonatomic) IBOutlet UIButton *collectedButton;
@property (weak, nonatomic) IBOutlet UIButton *needCollectedButton;

@end

@implementation CollectionMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"采集信息";
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setImage:[UIImage imageNamed:@"iconfont-backicon1.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStyleDone target:self action:@selector(gotoMap)];
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc]initWithTitle:@"拍照" style:UIBarButtonItemStyleDone target:self action:@selector(gotoPhoto)];
    self.navigationItem.rightBarButtonItems = @[mapItem,photoItem];
}

- (void)goBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)gotoMap{
    NSLog(@"地图");
}

- (void)gotoPhoto{
    NSLog(@"拍照");
}
- (IBAction)GPSorientaiont:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.netButton.selected = NO;
    self.autoButton.selected = NO;
}
- (IBAction)netOrientaiont:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.GPSButton.selected = NO;
    self.autoButton.selected = NO;
}
- (IBAction)atuoOrientationtButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.GPSButton.selected = NO;
    self.netButton.selected = NO;
}

- (IBAction)collected:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.needCollectedButton.selected = NO;
}
- (IBAction)needCollect:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.collectedButton.selected = NO;
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

@end
