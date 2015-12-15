//
//  BatchLoadCollectionViewController.h
//  MicroBo
//
//  Created by Franklin Zhang on 1/29/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewController.h"
@interface BatchLoadCollectionViewController : BaseCollectionViewController
{
    UIView *footerView;
    UILabel *loadMoreLabel;
    UIActivityIndicatorView *loadMoreIndicator;
}
@end
