//
//  CHPopoverListView.h
//  Mars
//
//  Created by jiamai on 15/10/10.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHPopoverListView;
@protocol CHPopoverListDatasource <NSObject>

- (NSInteger)popoverListView:(CHPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)popoverListView:(CHPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol CHPopoverListDelegate <NSObject>

- (void)popoverListView:(CHPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)popoverListView:(CHPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface CHPopoverListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,assign)id <CHPopoverListDelegate>delegate;
@property (nonatomic, retain)id <CHPopoverListDatasource>datasource;

- (void)show;
- (void)dismiss;
- (void)touchForDismissSelf;

- (id)dequeueReusablePopoverCellWithIdentifier:(NSString *)identitier;
- (UITableViewCell *)popoverCellForRowAtIndexPath:(NSIndexPath *)indexPath;            // returns nil if cell is not visible or index path is out o

- (NSIndexPath *)indexPathForSelectRow;

@end
