//
//  BatchLoadListViewController.h
//  rainbow-core
//
//  Created by Franklin Zhang on 9/28/14.
//  Copyright (c) 2014 Macrame. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseListViewController.h"
@interface BatchLoadListViewController : BaseListViewController
{
    UIView *footerView;
    UILabel *loadMoreLabel;
    UIActivityIndicatorView *loadMoreIndicator;
}
@property NSInteger totelItemCount;
@end
