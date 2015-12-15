//
//  BaseCollectionViewController.h
//  MicroBo
//
//  Created by Franklin Zhang on 1/29/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//
#define LOAD_HEADER_HEIGHT 40.0f
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "HttpNetworkManager.h"
@interface BaseCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIView *headerView;
    UILabel *refreshLabel;
    UIActivityIndicatorView *refreshIndicator;
    UICollectionView *standardCollectionView;
    NSMutableArray *tableDataList;
    NSMutableDictionary *requestData;
    NSString *requestUrl;
    BOOL refreshing;
    BOOL isLoading;
}
@property (nonatomic, retain) NSMutableDictionary *requestData;
@property (nonatomic, retain) NSString *requestUrl;
@property NSInteger columnsNumber;
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
