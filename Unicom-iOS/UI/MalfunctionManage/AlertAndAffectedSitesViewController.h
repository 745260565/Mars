//
//  AlertAndAffectedSitesViewController.h
//  Unicom-iOS
//
//  Created by jiamai on 15/12/15.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabPageController.h"

@interface AlertAndAffectedSitesViewController : TabPageController<TabPageDataSource,TabPageHeaderDataSource,TabPageHeaderDelegate>
@property (nonatomic,retain)NSString *orderId;
@property (nonatomic,retain)NSString *orderCode;
@end
