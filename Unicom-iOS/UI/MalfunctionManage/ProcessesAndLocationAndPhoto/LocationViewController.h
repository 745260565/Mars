//
//  LocationViewController.h
//  Mars
//
//  Created by jiamai on 15/11/17.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationViewController : UIViewController

@property double dealLongitude;//经度
@property double dealLatutude;//纬度
@property (nonatomic,retain)NSString *siteName;
@property (nonatomic,retain)NSString *siteCode;

@end