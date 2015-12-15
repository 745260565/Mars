//
//  TabPageHeaderScrollView.h
//  TabPageController
//
//  Created by Franklin Zhang on 7/6/15.
//  Copyright (c) 2015 macrame. All rights reserved.
//

#define kDefaultTitleViewHeight 44.0
#define kMinTitleViewWidth 100.0
#import <UIKit/UIKit.h>
@protocol TabPageHeaderDataSource <NSObject>

@required
- (NSUInteger )numberOfPages;
@optional
- (UIView *) titleViewForIndex:(NSUInteger ) index;
- (NSString *) titleForIndex:(NSUInteger ) index;
//- (NSString *) countNumberForIndex:(NSUInteger) index;
- (CGFloat)tabHeight;
- (UIColor *)titleViewBackgroundColor;
- (UIColor *)tabBackgroundColor;
- (UIColor *)tabIndicatorColor;
- (UIFont *)titleFont;
- (UIColor *)titleColor;
- (CGSize ) titleOffset;
- (NSString *) badgeValueForIndex:(NSUInteger ) index;
@end


@protocol TabPageHeaderDelegate;
@interface TabPageHeaderScrollView : UIScrollView
@property id<TabPageHeaderDataSource> dataSource;

@property (weak, nonatomic) id<TabPageHeaderDelegate> tabPageHeaderDelegate;
@property CGFloat titleViewHeight;
@property (readonly) CGFloat titleViewWidth;
@property CGFloat minTitleViewWidth;
@property UIView *tabIndicatorView;
- (void) buildLayout;
- (void) updateBadgeValue:(NSString *) badgeValue atIndex:(NSInteger)index;
- (void) clearBadgeValue:(NSInteger) index;
- (void)animateToTabAtIndex:(NSInteger)index;

- (void)animateToTabAtIndex:(NSInteger)index animated:(BOOL)animated;
@end
@protocol TabPageHeaderDelegate <NSObject>
@required
- (void)tabScrollView:(TabPageHeaderScrollView *)tabScrollView didSelectTabAtIndex:(NSInteger)index;

@optional
//- (void) updateBadgeValue:(NSString *) badgeValue atIndex:(NSInteger)index;
//- (void) clearBadgeValue:(NSInteger) index;
@end

