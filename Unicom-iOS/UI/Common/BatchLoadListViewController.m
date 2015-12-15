//
//  BatchLoadListViewController.m
//  rainbow-core
//
//  Created by Franklin Zhang on 9/28/14.
//  Copyright (c) 2014 Macrame. All rights reserved.
//

#define LOAD_FOOTER_HEIGHT 40.0f
#import "BatchLoadListViewController.h"

@interface BatchLoadListViewController ()
{
    NSInteger pageSize;
    NSInteger nextPageNumber;
    
    
    NSInteger currentPageNumber;
    BOOL loadingMore;
    BOOL hasMoreData;
}
@end

@implementation BatchLoadListViewController
@synthesize totelItemCount;
- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        pageSize = 10;
        nextPageNumber = [Configuration sharedInstance].requestPageStartIndexValue;
        totelItemCount = 0;
        currentPageNumber = 0;
        hasMoreData = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}
- (void) buildLayout
{
    [super buildLayout];
    CGRect viewRect = standardTableView.frame;
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, viewRect.size.height, viewRect.size.width, LOAD_FOOTER_HEIGHT)];
    
    loadMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadMoreIndicator.frame = CGRectMake(viewRect.size.width/2 - 90, 2, 36, 36);
    //loadMoreIndicator.hidesWhenStopped = NO;
    [footerView addSubview:loadMoreIndicator];
    loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewRect.size.width/2 - 50, 9, 140, 22)];
    //loadMoreLabel.backgroundColor = [UIColor greenColor];
    loadMoreLabel.text = @"上拉加载更多";
    [footerView addSubview:loadMoreLabel];
    //standardTableView.tableFooterView = footerView;
    [standardTableView addSubview:footerView];
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    //isDragging = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(isLoading)
        return;
    if(scrollView.contentOffset.y < 0){
        [super scrollViewDidScroll:scrollView];
        return;
    }
    if (scrollView.contentOffset.y > 0) {
        // Update the content inset, good for section headers
        //standardTableView.contentInset = UIEdgeInsetsMake(0, 0, LOAD_FOOTER_HEIGHT, 0);
    }else if(!hasMoreData){
        loadMoreLabel.text = @"没有更多数据";
        //refreshArrow.hidden = YES;
    }else if (/*isDragging && */scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= 0 ) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        //refreshArrow.hidden = NO;
        if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -LOAD_FOOTER_HEIGHT) {
            // User is scrolling above the header
            loadMoreLabel.text = @"放开加载更多";
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            loadMoreLabel.text = @"上拉加载更多";
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(isLoading)
        return;
    if(scrollView.contentOffset.y < 0)
    {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        return;
    }
    if (!hasMoreData)
        return;
    
    if(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -LOAD_FOOTER_HEIGHT && scrollView.contentOffset.y > 0){
        loadingMore = YES;
        nextPageNumber ++;
        [self loadList];
    }
}
#pragma mark - function
- (void) startLoading
{
    if(refreshing)
        [super startLoading];
    if(loadingMore)
        [self startLoadingMore];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Common.Loading",nil)];
}
- (void) completeLoading
{
    if(loadingMore)
        [self stopLoadingMore];
    if(refreshing)
        [super completeLoading];
    [self moveFootView];
    
    [SVProgressHUD dismiss];
}

- (void) startLoadingMore
{
    isLoading = YES;
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets inset = standardTableView.contentInset;
    inset.bottom += LOAD_FOOTER_HEIGHT;
    standardTableView.contentInset = inset;
    loadMoreLabel.text = @"正在加载数据";
    [loadMoreIndicator startAnimating];
    [UIView commitAnimations];
    
}
- (void) stopLoadingMore
{
    
    isLoading = NO;
    loadingMore = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    UIEdgeInsets inset = standardTableView.contentInset;
    inset.bottom -= LOAD_FOOTER_HEIGHT;
    standardTableView.contentInset = inset;
    [UIView commitAnimations];
}
- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [loadMoreIndicator stopAnimating];
    if(!hasMoreData)
        loadMoreLabel.text = @"没有更多数据";
    else
        loadMoreLabel.text = @"上拉加载更多";
}
- (void) moveFootView
{
    CGSize size = standardTableView.contentSize;
    CGSize bounds = standardTableView.bounds.size;
    //NSLog(@"batch load list view controller:standardTableView  standardTableView.contentInset.top %fd, standardTableView.contentInset.bottom %ff ",standardTableView.contentInset.top, standardTableView.contentInset.bottom);
    if(size.height < bounds.height-standardTableView.contentInset.top - standardTableView.contentInset.bottom)
        [footerView setFrame:CGRectMake(0, bounds.height-standardTableView.contentInset.top - standardTableView.contentInset.bottom, size.width, 0)];
    else
        [footerView setFrame:CGRectMake(0, size.height, size.width, 0)];
    //NSLog(@"batch load list view controller:footerView  standardTableView.contentSize.height %fd, footerView.frame.origin.y %ff ",standardTableView.contentSize.height, footerView.frame.origin.y);
}

- (NSUInteger) handleResultData:(NSDictionary *) data
{
    totelItemCount = [[data objectForKey:[Configuration sharedInstance].totalElementsKey] integerValue];
    NSArray *listItems = [data objectForKey:[Configuration sharedInstance].pageContentKey];
    
    
    NSUInteger listItemCount = [super handleListData:listItems];
    hasMoreData = tableDataList.count < totelItemCount;
    
    currentPageNumber ++;
    
    
    if(nextPageNumber == 1 && currentPageNumber >1 )//refresh
    {
        [self refreshTable];
        currentPageNumber = 1;
    }
    else
    {
        if(nextPageNumber > 1)//load more
        {
            if(listItemCount==0)
            {
                nextPageNumber --;
                currentPageNumber --;
            }
            [self loadMoreDataToTable];
            
        }
    }
    
    return listItemCount;
}
- (void) loadList
{
    
    [requestData setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:[Configuration sharedInstance].requestPageSizeKey];
    [requestData setObject:[NSString stringWithFormat:@"%d",nextPageNumber] forKey:[Configuration sharedInstance].requestPageNumberKey];
    //[super loadList];
    
    isLoading = YES;
    [self startLoading];
    [HttpNetworkManager request:requestData withPath:requestUrl targetClass:[NSDictionary class] completion:^(NSDictionary *resultDictionary, NSError *error) {
        if(error)
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"加载失败:%@",error.localizedDescription]];
        }
        else
        {
            [self handleResultData:resultDictionary];
            [standardTableView reloadData];
        }
        isLoading = NO;
        [self completeLoading];
    } withMethod:HttpMethodPost];
    
}
#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
}

- (void) refresh
{
    nextPageNumber = [Configuration sharedInstance].requestPageStartIndexValue;
    [super refresh];
}

@end
