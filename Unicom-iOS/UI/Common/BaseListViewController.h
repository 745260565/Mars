//
//  BaseListViewController.h
//  rainbow-core
//
//  Created by Franklin Zhang on 9/21/14.
//  Copyright (c) 2014 Macrame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "HttpNetworkManager.h"
@interface BaseListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    //UIRefreshControl *refreshControl;
    UIView *headerView;
    UILabel *refreshLabel;
    UIActivityIndicatorView *refreshIndicator;
    UITableView *standardTableView;
    NSMutableArray *tableDataList;
    NSMutableDictionary *requestData;
    NSString *requestUrl;
    BOOL refreshing;
    BOOL isLoading;
}
@property (nonatomic, retain) NSMutableDictionary *requestData;
@property (nonatomic, retain) NSString *requestUrl;
- (void) buildLayout;
- (void) loadList;
- (void) refresh;
- (void) appendEntities: (NSArray *) entries;
- (void) appendEntity: (id) entity;
- (void) emptyEntities;
- (NSUInteger) handleListData:(NSArray *) data;
- (id) parseItem:(NSDictionary *)dictionary;

- (void) startLoading;
- (void) completeLoading;
@end
