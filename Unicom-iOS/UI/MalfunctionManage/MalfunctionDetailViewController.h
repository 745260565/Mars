//
//  MalfunctionDetailViewController.h
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/12/2.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MalfunctionDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate>
{
    
    NSString *orderId;
    NSDictionary *orderDetail;
    UITableView *mainTable;
}
- (instancetype)initWithId:(NSString *) orderIdValue withHandleMenus:(NSArray *)handleMenusArray;
//Order data has loaded.
- (void) orderDataDidLoad;
//Handle the menu action
- (void) handleMenu:(NSInteger)index;
@property (nonatomic, copy) void(^completion)(BOOL needRefresh);
@end
