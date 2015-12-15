//
//  MalfunctionListViewController.m
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/12/2.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import "MalfunctionListViewController.h"
#import "MalfunctionTableViewCell.h"
#import "Constant.h"
@interface MalfunctionListViewController ()

@end

@implementation MalfunctionListViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        NSMutableDictionary *conditionData = [[NSMutableDictionary alloc] init];
        
        NSArray *faultStateArray = @[@"已派单"];
        [conditionData setObject:faultStateArray forKey:@"faultState"];
        [conditionData setObject:@"true" forKey:@"myTask"];
        
        self.requestData = conditionData;
        self.requestUrl = @"/api/fault/faultOrderInfo/list";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    CGRect standardTableRect = standardTableView.frame;
    standardTableView.frame = CGRectMake(0, standardTableRect.origin.y -44, standardTableRect.size.width, standardTableRect.size.height+44);
}

#pragma mark - UITable Cell Function
- (UITableViewCell *) generateListCellWithDataEntity:(id) dataEntity
{
    static NSString *cellIdentifier = @"MalfunctionTableViewCell";
    MalfunctionTableViewCell *cell = [standardTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MalfunctionTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.autoresizesSubviews = YES;
    
    
    return cell;
}
- (void)fillInCell:(UITableViewCell *)tableCell withDataEntity:(id)dataEntity
{
    MalfunctionTableViewCell *cell = (MalfunctionTableViewCell *)tableCell;
    NSDictionary *entity = (NSDictionary *)dataEntity;
    
    NSString *orderCode = [entity objectForKey:@"orderCode"];//工单编号
    NSString *siteName = [entity objectForKey:@"siteName"];//基站名称
    cell.siteNameText.text = siteName;
    cell.orderCodeText.text = orderCode;
    cell.orderTimeText.text = [entity objectForKey:@"faultAppearTime"];
    cell.faultCategoryText.text = [entity objectForKey:@"faultCategory"];
    cell.faultTypeText.text = [entity objectForKey:@"faultType"];
    //tableCell.imageView.image = [UIImage imageNamed:@"hammer"];
}
- (void) viewItem:(id)item
{
    NSDictionary *entity = (NSDictionary *)item;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}



@end
