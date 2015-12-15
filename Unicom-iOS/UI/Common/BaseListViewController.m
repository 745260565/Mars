//
//  BaseListViewController.m
//  rainbow-core
//
//  Created by Franklin Zhang on 9/21/14.
//  Copyright (c) 2014 Macrame. All rights reserved.
//

#define LOAD_HEADER_HEIGHT 44.0f
#import "BaseListViewController.h"
@interface BaseListViewController ()
{
    NSInteger topEdgeHeight, bottomEdgeHeight;
}
@end

@implementation BaseListViewController
@synthesize requestData, requestUrl;
- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        topEdgeHeight = bottomEdgeHeight = 0;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if((self.edgesForExtendedLayout&UIRectEdgeTop) || self.navigationController != nil){
        topEdgeHeight = 44;
    }
    if(self.edgesForExtendedLayout&UIRectEdgeBottom)
    {
        bottomEdgeHeight = 49;
    }
    if (tableDataList == nil) {
        tableDataList = [[NSMutableArray alloc] init];
    }
    [self buildLayout];
    
    [standardTableView setSeparatorInset:UIEdgeInsetsZero];
    if([standardTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [standardTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self loadList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) buildLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect viewRect = self.view.frame;
    //NSLog(@"base list view controller:buildLayout->self.View  frame.size.height %fd, bounds.size.height %ff ",self.view.frame.size.height, self.view.bounds.size.height);
    
    standardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topEdgeHeight, viewRect.size.width, viewRect.size.height-topEdgeHeight) style:UITableViewStylePlain];
    //standardTableView.backgroundColor = [UIColor brownColor];
    standardTableView.dataSource = self;
    standardTableView.delegate = self;
    standardTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    standardTableView.separatorInset = UIEdgeInsetsZero;
    //[self.view addSubview:standardTableView];
    [self.view addSubview:standardTableView];
    //NSLog(@"base list view controller:buildLayout->standardTableView  frame.size.height %fd, contentSize.height %ff ",standardTableView.frame.size.height, standardTableView.contentSize.height);

    /*refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, 50)];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新数据"]];
    [standardTableView addSubview: refreshControl];
    */
    
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -LOAD_HEADER_HEIGHT, viewRect.size.width, LOAD_HEADER_HEIGHT)];
    //headerView.backgroundColor = [UIColor purpleColor];
    refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshIndicator.frame = CGRectMake(viewRect.size.width/2 - 90, 2, 36, 36);
    //loadMoreIndicator.hidesWhenStopped = NO;
    [headerView addSubview:refreshIndicator];
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewRect.size.width/2 - 50, 9, 140, 22)];
    refreshLabel.text = @"下拉刷新数据";
    [headerView addSubview:refreshLabel];
    //standardTableView.tableHeaderView = headerView;
    [standardTableView addSubview:headerView];
    //headerView.alpha = 0.0;
    //[self.view addSubview:headerView];
    
}
#pragma mark - function
- (void) startLoading
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Common.Loading",nil)];
    if(refreshing)
        [self startRefreshing];
}
- (void) completeLoading
{
    refreshing = NO;
    //[refreshControl endRefreshing];
    [self stopRefreshing];
    [SVProgressHUD dismiss];
}
- (void) startRefreshing
{
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    UIEdgeInsets inset = standardTableView.contentInset;
    inset.top += LOAD_HEADER_HEIGHT;
    standardTableView.contentInset = inset;
    refreshLabel.text = @"正在加载数据...";
    [refreshIndicator startAnimating];
    [UIView commitAnimations];
    
}
- (void) stopRefreshing
{
    
    isLoading = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopRefreshingComplete:finished:context:)];
    UIEdgeInsets inset = standardTableView.contentInset;
    inset.top -= LOAD_HEADER_HEIGHT;
    standardTableView.contentInset = inset;
    [UIView commitAnimations];
}
- (void)stopRefreshingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [refreshIndicator stopAnimating];
    refreshLabel.text = @"下拉刷新数据";
}
- (void) refreshView:(id) sender
{
    [self refresh];
}
- (void) refresh
{
    /*double delayInSeconds = 1.0f;
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        [self emptyEntities];
        [standardTableView reloadData];
        
    });*/
    [self emptyEntities];
    [standardTableView reloadData];
    refreshing = YES;
    [self loadList];
}
- (void) loadList
{
    isLoading = YES;
    [self startLoading];
    [HttpNetworkManager request:requestData withPath:requestUrl targetClass:[NSArray class] completion:^(NSArray *resultArray, NSError *error) {
        if(error)
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"加载失败:%@",error.localizedDescription]];
        }
        else
        {
            [self handleListData:resultArray];
            [standardTableView reloadData];
        }
        isLoading = NO;
        [self completeLoading];
    } withMethod:HttpMethodPost];
}
- (UITableViewCell *) generateListCellWithDataEntity:(id) dataEntity
{
    static NSString *cellIdentifier = @"tableListCell";
    UITableViewCell *   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.autoresizesSubviews = YES;
    return cell;
}
- (void)fillInCell:(UITableViewCell *)tableCell withDataEntity:(id)dataEntity
{
    //subclass shoud implement this method
}
- (NSUInteger) handleListData:(NSArray *) listItems
{
    for(NSDictionary *dictionary in listItems)
    {
        id entity = [self parseItem:dictionary];
        if(entity != nil){
            [self appendEntity:entity];
        }
    }
    if(listItems.count==0)
    {
        //notify user there is no more data
        //[super showShortWarning:@"没有符合条件的数据."];
    }
    return listItems.count;
}


- (void) appendEntities: (NSArray *) entities
{
    [tableDataList addObjectsFromArray:entities];
    
}
- (void) appendEntity: (id) entity
{
    [tableDataList addObject:entity];
    
}
- (void) emptyEntities
{
    [tableDataList removeAllObjects];
}
- (id) parseItem:(NSDictionary *)dictionary
{
    return dictionary;
}
- (void) viewItem:(id)item
{
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    //isDragging = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        //standardTableView.contentInset = UIEdgeInsetsMake(0, 0, LOAD_FOOTER_HEIGHT, 0);
    }else if (scrollView.contentOffset.y < 0 ) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        //refreshArrow.hidden = NO;
        if (scrollView.contentOffset.y <= -LOAD_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = @"放开刷新数据";
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = @"下拉刷新数据";
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            
            //headerView.alpha = (scrollView.contentOffset.y+offsetHeight)/-LOAD_HEADER_HEIGHT;
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading)
        return;
    
    if(scrollView.contentOffset.y  <= -LOAD_HEADER_HEIGHT){
         [self refresh];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableDataList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    id dataEntity  = [tableDataList objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"tableListCell";
    UITableViewCell *cell = [standardTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [self generateListCellWithDataEntity:dataEntity];
    }
    
    //if (row%2 == 0) {
    //    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.98f alpha:1];
    //} else {
    //    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.96f alpha:1];
    //}
    [self fillInCell:cell withDataEntity:dataEntity];
    
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!standardTableView.editing)
    {
        id dataEntity = [tableDataList objectAtIndex:indexPath.row];
        [self viewItem:dataEntity];
    }
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[cell setSeparatorInset:UIEdgeInsetsZero];
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
