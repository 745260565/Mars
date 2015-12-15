//
//  MalfunctionTableViewCell.h
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/12/3.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MalfunctionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *siteNameText;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeText;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeText;
@property (weak, nonatomic) IBOutlet UILabel *faultCategoryText;
@property (weak, nonatomic) IBOutlet UILabel *faultTypeText;

@end
