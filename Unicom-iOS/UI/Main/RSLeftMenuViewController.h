//
//  RSLeftMenuViewController.h
//  NewMars
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSLeftMenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableViewLeft;
    UINavigationController *_navSlideSwitchVC;                //滑动切换视图
    UINavigationController *_navCommonComponentVC;              //通用控件
}
@property (nonatomic, retain) UINavigationController *targetNavigationController;
@property CGSize menuViewSize;
//@property (nonatomic, strong) IBOutlet UITableView *tableViewLeft;


@end
