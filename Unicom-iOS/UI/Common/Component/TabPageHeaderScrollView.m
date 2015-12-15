//
//  TagPageHeaderScrollView.m
//  TabPageController
//
//  Created by Franklin Zhang on 7/6/15.
//  Copyright (c) 2015 macrame. All rights reserved.
//

#import "TabPageHeaderScrollView.h"
#import "BadgeView.h"
@interface TabPageHeaderScrollView()
{
    NSMutableArray *badgeViewArray;
}
@end
@implementation TabPageHeaderScrollView
@synthesize dataSource = dataSource, tabPageHeaderDelegate = tabPageHeaderDelegate, minTitleViewWidth = minTitleViewWidth, titleViewWidth = titleViewWidth, titleViewHeight = titleViewHeight, tabIndicatorView = tabIndicatorView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        minTitleViewWidth = kMinTitleViewWidth;
        titleViewHeight = kDefaultTitleViewHeight;
    }
    return self;
}
- (void) buildLayout
{
    NSUInteger pageCount = [dataSource numberOfPages];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float width = screenSize.width;
    if (pageCount > 0) {
        
        if (minTitleViewWidth * pageCount > screenSize.width) {
            width = minTitleViewWidth * pageCount;
            titleViewWidth = minTitleViewWidth;
        }else{
            titleViewWidth = width/pageCount;
        }
    }
    self.contentSize = CGSizeMake(width, titleViewHeight);

    if ([dataSource respondsToSelector:@selector(titleViewForIndex:)]) {
        for (NSUInteger i = 0; i < pageCount; i++) {
            UIView *view;
            if ((view = [dataSource titleViewForIndex:i]) != nil) {
                view.tag = i;
                [view setUserInteractionEnabled:YES];
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabTapHandler:)]];
                [self addSubview:view];
            }
        }
    } else {
        badgeViewArray = [NSMutableArray array];
        UIColor *backgroundColor;
        if ([dataSource respondsToSelector:@selector(tabBackgroundColor)]) {
            backgroundColor = [dataSource tabBackgroundColor];
        }else{
            backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        }
        
        self.backgroundColor = backgroundColor;
        UIFont *font;
        if ([dataSource respondsToSelector:@selector(titleFont)]) {
            font = [[self dataSource] titleFont];
        } else {
            font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0f];
        }
        
        UIColor *textColor;
        if ([[self dataSource] respondsToSelector:@selector(titleColor)]) {
            textColor = [[self dataSource] titleColor];
        } else {
            textColor = [UIColor blackColor];
        }
        CGSize offset;
        if ([[self dataSource] respondsToSelector:@selector(titleOffset)]) {
            offset = [[self dataSource] titleOffset];
        } else {
            offset = CGSizeMake(0, 0);
        }
        for (NSUInteger i = 0; i < pageCount; i++) {
            NSString *title = nil;
            if ([dataSource respondsToSelector:@selector(titleForIndex:)]) {
                title = [[self dataSource] titleForIndex:i];
            }
            if (title == nil) {
                
                title = [NSString stringWithFormat:@"Tab-%lu",(unsigned long)i];
            }
//            NSString *countNumber = nil;
//            if ([dataSource respondsToSelector:@selector(countNumberForIndex:)]) {
//                countNumber = [[self dataSource] countNumberForIndex:i];
//            }
//            if (countNumber == nil) {
////                countNumber = [NSString stringWithFormat:@"%lu",(unsigned long)i];
//                countNumber = @"0";
//            }

            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * titleViewWidth, 0, titleViewWidth, titleViewHeight)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offset.width, offset.height, titleViewWidth - offset.width * 2, titleViewHeight - offset.height)];
//            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleViewWidth-20, 2, 20, 20)];
//            numberLabel.layer.masksToBounds = YES;
//            numberLabel.backgroundColor = [UIColor redColor];
//            numberLabel.layer.cornerRadius = 10;
//            numberLabel.text = countNumber;
//            numberLabel.textColor = [UIColor whiteColor];
//            [numberLabel setTextAlignment:NSTextAlignmentCenter];
//            if (![countNumber isEqualToString:@"0"]) {
//                [view addSubview:numberLabel];
//            }
            [label setText:title];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:font];
            [label setTextColor:textColor];
            //[label sizeToFit];
            [view addSubview:label];
            view.tag = i;
            [view setUserInteractionEnabled:YES];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabTapHandler:)]];
            
            NSString *badgeValue;
            if ([dataSource respondsToSelector:@selector(badgeValueForIndex:)]){
                badgeValue = [[self dataSource] badgeValueForIndex:i];
            }else{
                badgeValue = @"0";
            }
            BadgeView *badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(titleViewWidth - 12, 2, 20, 20)];
            if (badgeValue == nil ||[badgeValue isEqualToString:@"0"]) {
                badgeView.hidden = YES;
            }else{
                badgeView.badgeLabel.text = badgeValue;
            }
            [view addSubview:badgeView];
            [badgeViewArray addObject:badgeView];

//            if ([dataSource respondsToSelector:@selector(badgeValueForIndex:)]) {
//                BadgeView *badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(titleViewWidth - 12, 2, 20, 20)];
//                NSString *badgeValue = [[self dataSource] badgeValueForIndex:i];
//                if (badgeValue == nil ||[badgeValue isEqualToString:@"0"]) {
//                    badgeView.hidden = YES;
//                }else{
//                    badgeView.badgeLabel.text = badgeValue;
//                }
//                [view addSubview:badgeView];
//                [badgeViewArray addObject:badgeView];
//            }
            [self addSubview:view];
        }
    }
    
    if (!tabIndicatorView) {
        tabIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, titleViewHeight-5, titleViewWidth, 5)];
        [tabIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        UIColor *indicatorColor;
        if ([dataSource respondsToSelector:@selector(tabIndicatorColor)]) {
            indicatorColor = [dataSource tabIndicatorColor];
        }else{
            indicatorColor = [UIColor orangeColor];
        }
        [tabIndicatorView setBackgroundColor:indicatorColor];
    }
    
    [self addSubview:tabIndicatorView];
    NSLog(@"content Size %f, %f",self.contentSize.width, self.contentSize.height);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"finally, content Size %f, %f",self.contentSize.width, self.contentSize.height);

    });
    
}

- (void) updateBadgeValue:(NSString *) badgeValue atIndex:(NSInteger)index
{
    if (index < badgeViewArray.count) {
        BadgeView *badgeView = [badgeViewArray objectAtIndex:index];
        if (badgeValue == nil ||[badgeValue isEqualToString:@"0"]) {
            badgeView.hidden = YES;
        }else{
            badgeView.badgeLabel.text = badgeValue;
            badgeView.hidden = NO;
        }
    }else{
        [NSException raise:@"TabPageHeader Not Support" format:@"Do not support this operation as it does not implement badgeValueForIndex mothed."];
    }
}
- (void) clearBadgeValue:(NSInteger) index
{
    if (index < badgeViewArray.count) {
        BadgeView *badgeView = [badgeViewArray objectAtIndex:index];
        badgeView.hidden = YES;
    }else{
        [NSException raise:@"TabPageHeader Not Support" format:@"Do not support this operation as it does not implement badgeValueForIndex mothed."];
    }
}


- (void)animateToTabAtIndex:(NSInteger)index {
    [self animateToTabAtIndex:index animated:YES];
}

- (void)animateToTabAtIndex:(NSInteger)index animated:(BOOL)animated {
    CGFloat animatedDuration = 0.4f;
    if (!animated) {
        animatedDuration = 0.0f;
    }
    [UIView animateWithDuration:animatedDuration animations:^{
        tabIndicatorView.center = CGPointMake((index + 0.5) * titleViewWidth,tabIndicatorView.center.y);
    } completion:^(BOOL finished) {
        if(finished)
        {
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            float width = screenSize.width;
            if (titleViewWidth * (index + 1) > self.contentOffset.x + width) {

                [self scrollRectToVisible:CGRectMake(titleViewWidth * (index + 1) - width, self.contentOffset.y, width, titleViewHeight) animated:YES];
            }else if (titleViewWidth * index  < self.contentOffset.x) {

                [self scrollRectToVisible:CGRectMake(titleViewWidth * index, self.contentOffset.y, width, titleViewHeight) animated:YES];
            }
        }
    }];
}

- (void)tabTapHandler:(UITapGestureRecognizer *)gestureRecognizer {
    if ([tabPageHeaderDelegate respondsToSelector:@selector(tabScrollView:didSelectTabAtIndex:)]) {
        NSInteger index = [[gestureRecognizer view] tag];
        [tabPageHeaderDelegate tabScrollView:self didSelectTabAtIndex:index];
        [self animateToTabAtIndex:index];
    }
}
@end
