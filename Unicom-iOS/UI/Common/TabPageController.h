//
//  TabPageController.h
//  TabPageController
//
//  Created by Franklin Zhang on 7/6/15.
//  Copyright (c) 2015 macrame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabPageHeaderScrollView.h"
@protocol TabPageDataSource <NSObject, TabPageHeaderDataSource>
@required
- (UIViewController *)viewControllerForIndex:(NSInteger)index;
@optional
- (UIView *) titleViewForIndex:(NSUInteger ) index;
- (NSString *) titleForIndex:(NSUInteger ) index;
- (CGFloat)tabHeight;
- (UIColor *)titleViewBackgroundColor;
- (UIColor *)tabBackgroundColor;
- (UIFont *)titleFont;
- (UIColor *)titleColor;
- (CGSize ) titleOffset;
@end
@protocol TabPageDelegate;
@interface TabPageController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate,TabPageDataSource,TabPageHeaderDelegate>
{
    
    NSMutableArray *viewControllersArray;
}
- (instancetype) initWithInitialIndex:(NSInteger )index;
@property (nonatomic, retain, readonly) TabPageHeaderScrollView *headerView;
@property id<TabPageDataSource> dataSource;
@property id<TabPageDelegate> delegate;
@property NSUInteger selectedIndex;
@property BOOL associatedTitle;//ture indicates it will use the title of view controller for header title label
@property BOOL headerHidden;
- (void) prepareViewControllers;
- (void) buildLayout;
- (void) adjustPageViewControllerFrame:(CGRect) frame;
- (void) switchToPageIndex:(NSInteger) index;
@end

@protocol TabPageDelegate <NSObject>
@optional
- (void)tabPager:(TabPageController *)tabPager willTransitionToTabAtIndex:(NSInteger)index;
- (void)tabPager:(TabPageController *)tabPager didTransitionToTabAtIndex:(NSInteger)index;


@end