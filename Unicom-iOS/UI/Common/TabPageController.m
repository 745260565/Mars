//
//  TabPageController.m
//  TabPageController
//
//  Created by Franklin Zhang on 7/6/15.
//  Copyright (c) 2015 macrame. All rights reserved.
//

#import "TabPageController.h"

@interface TabPageController ()
{
    TabPageHeaderScrollView *headerView;
    UIPageViewController *pageViewController;
    NSInteger initialIndex;
    NSInteger targetViewControllerIndex;
}
@end

@implementation TabPageController
@synthesize headerView = headerView, dataSource = dataSource, delegate = delegate, selectedIndex = selectedIndex, headerHidden = headerHidden;
- (instancetype) init
{
    self = [super init];
    if (self) {
        viewControllersArray = [NSMutableArray array];
        headerHidden = NO;
    }
    return self;
}
- (instancetype) initWithInitialIndex:(NSInteger )index
{
    self = [self init];
    if (self) {
        initialIndex = index;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self prepareViewControllers];
    [self buildLayout];
//    if (initialIndex > 0) {
//        [self switchToPageIndex:initialIndex];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) prepareViewControllers
{
    //subclass can initialize view controllers here.
    
    self.dataSource = self;
}
- (void) buildLayout
{
    
    CGRect appBound = [[UIScreen mainScreen] applicationFrame];
    float topOffset = 0;
    if (self.navigationController && self.edgesForExtendedLayout & UIRectEdgeTop) {
        topOffset += 64;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!self.headerHidden) {
        headerView = [[TabPageHeaderScrollView alloc] initWithFrame:CGRectMake(0, topOffset, appBound.size.width, kDefaultTitleViewHeight)];
        headerView.dataSource = self;
        headerView.tabPageHeaderDelegate = self;
        [headerView buildLayout];
        [self.view addSubview:headerView];
        topOffset += kDefaultTitleViewHeight;
    }
    pageViewController.automaticallyAdjustsScrollViewInsets = NO;
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;CGRect r = self.view.frame;
    NSLog(@"Build layout for TabPageController : buildLayout > pageViewController.view.frame -----    x:%d,y:%fd,  frame.size.width %fd, frame.size.height %fd ",0, topOffset, appBound.size.width, appBound.size.height - kDefaultTitleViewHeight);
    pageViewController.view.frame = CGRectMake(0, topOffset, appBound.size.width, appBound.size.height - topOffset);
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
    
    
    [pageViewController setViewControllers:@[[viewControllersArray objectAtIndex:initialIndex]]
                                 direction:UIPageViewControllerNavigationDirectionReverse
                                  animated:NO
                                completion:nil];
    if (initialIndex > 0  && !self.headerHidden) {
        [headerView animateToTabAtIndex:initialIndex];
    }
    //[self setSelectedIndex:0];
    NSLog(@"After Build layout for TabPageController : viewControllerBeforeViewController > pageViewController.view.frame -----    x:%fd,y:%fd,  frame.size.width %fd, frame.size.height %fd ",pageViewController.view.frame.origin.x, pageViewController.view.frame.origin.y, pageViewController.view.frame.size.width, pageViewController.view.frame.size.height);
    [pageViewController.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        NSLog(@"new value:%@",change);
    }
}
- (void) viewDidLayoutSubviews{
    [self autoAdjustPageViewControllerFrame];
}
- (void) autoAdjustPageViewControllerFrame    
{
    NSLog(@"TabPageController -- viewDidLayoutSubviews > pageViewController.view.frame -----    x:%fd,y:%fd,  frame.size.width %fd, frame.size.height %fd ",pageViewController.view.frame.origin.x, pageViewController.view.frame.origin.y, pageViewController.view.frame.size.width, pageViewController.view.frame.size.height);
    float topOffset = 0;
    if (self.navigationController && self.edgesForExtendedLayout & UIRectEdgeTop) {
        topOffset += 64;
    }
    if (!self.headerHidden) {
        topOffset += kDefaultTitleViewHeight;
    }
    float bottomOffset = 0;
    if (self.tabBarController && self.edgesForExtendedLayout & UIRectEdgeBottom) {
        bottomOffset += 49;
    }
    CGRect viewRect = self.view.frame;
    pageViewController.view.frame = CGRectMake(0, topOffset , viewRect.size.width, viewRect.size.height - topOffset - bottomOffset);
}
- (void) adjustPageViewControllerFrame:(CGRect) frame
{
    
    pageViewController.view.frame = frame;
    
    NSLog(@"adjustPageViewControllerFrame > pageViewController.view.frame -----    x:%fd,y:%fd,  frame.size.width %fd, frame.size.height %fd ",pageViewController.view.frame.origin.x, pageViewController.view.frame.origin.y, pageViewController.view.frame.size.width, pageViewController.view.frame.size.height);
}
- (void) switchToPageIndex:(NSInteger) index
{
    [self tabScrollView:headerView didSelectTabAtIndex:index];
    [headerView animateToTabAtIndex:index];
}
#pragma mark - TabPageHeaderDataSource
- (NSUInteger )numberOfPages
{
    return viewControllersArray.count;
}
- (UIViewController *)viewControllerForIndex:(NSInteger)index
{
    return [viewControllersArray objectAtIndex:index];
}
- (void)tabScrollView:(TabPageHeaderScrollView *)tabScrollView didSelectTabAtIndex:(NSInteger)index
{
    if (index != [self selectedIndex]) {
        __weak TabPageController *weakSelf = self;
        if ([[self delegate] respondsToSelector:@selector(tabPager:willTransitionToTabAtIndex:)]) {
            [[self delegate] tabPager:self willTransitionToTabAtIndex:index];
        }
        
        [pageViewController  setViewControllers:@[viewControllersArray[index]]
                                             direction:(index > [self selectedIndex]) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                              animated:YES
                                            completion:^(BOOL finished) {
                                                selectedIndex = index;
                                                
                                                if ([[weakSelf delegate] respondsToSelector:@selector(tabPager:didTransitionToTabAtIndex:)]) {
                                                    [[weakSelf delegate] tabPager:weakSelf didTransitionToTabAtIndex:[weakSelf selectedIndex]];
                                                }
                                            }];
    }
}
- (NSString *) titleForIndex:(NSUInteger ) index
{
    if(self.associatedTitle){
        return ((UIViewController *)[viewControllersArray objectAtIndex:index]).title;
    }else{
        return nil;
    }
}
#pragma mark - Page View Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (viewControllersArray.count > 0) {
        NSUInteger pageIndex = [viewControllersArray indexOfObject:viewController];
        return pageIndex > 0 ? viewControllersArray[pageIndex - 1]: nil;
    }else{
        return nil;
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    if (viewControllersArray.count > 0) {
        NSUInteger pageIndex = [viewControllersArray indexOfObject:viewController];
        return pageIndex < viewControllersArray.count - 1 ? viewControllersArray[pageIndex + 1]: nil;
    }else{
        return nil;
    }
}
#pragma mark - Page View Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    NSLog(@"willTransitionToViewControllers : viewControllerBeforeViewController > pageViewController.view.frame -----    x:%fd,y:%fd,  frame.size.width %fd, frame.size.height %fd ",pageViewController.view.frame.origin.x, pageViewController.view.frame.origin.y, pageViewController.view.frame.size.width, pageViewController.view.frame.size.height);
    
    
    NSInteger index = [viewControllersArray indexOfObject:pendingViewControllers[0]];
    targetViewControllerIndex = index;
    
    if ([[self delegate] respondsToSelector:@selector(tabPager:willTransitionToTabAtIndex:)]) {
        [[self delegate] tabPager:self willTransitionToTabAtIndex:index];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        
        selectedIndex = targetViewControllerIndex;
        if (!self.headerHidden) {
            [headerView animateToTabAtIndex:targetViewControllerIndex];
        }
        NSLog(@"didFinishAnimating : viewControllerBeforeViewController > pageViewController.view.frame -----    x:%fd,y:%fd,  frame.size.width %fd, frame.size.height %fd ",pageViewController.view.frame.origin.x, pageViewController.view.frame.origin.y, pageViewController.view.frame.size.width, pageViewController.view.frame.size.height);
        
        if ([[self delegate] respondsToSelector:@selector(tabPager:didTransitionToTabAtIndex:)]) {
            [[self delegate] tabPager:self didTransitionToTabAtIndex:selectedIndex];
        }
    }
}
@end
