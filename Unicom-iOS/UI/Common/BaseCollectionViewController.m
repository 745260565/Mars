//
//  BaseCollectionViewController.m
//  MicroBo
//
//  Created by Franklin Zhang on 1/29/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "GenericCollectionViewCell.h"
@interface BaseCollectionViewController ()
{
    NSInteger topOffset;
}
@end

@implementation BaseCollectionViewController
@synthesize requestData, requestUrl;
- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        topOffset = 0;
        self.columnsNumber = 3;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    if(self.edgesForExtendedLayout & UIRectEdgeTop)
    {
        topOffset = 64;
    }
    if (tableDataList == nil) {
        tableDataList = [[NSMutableArray alloc] init];
    }
    [self buildLayout];
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    float gridWidth = (viewRect.size.width - self.columnsNumber*10)/self.columnsNumber;
    flowLayout.itemSize = CGSizeMake(gridWidth, gridWidth+15);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    NSInteger bottomOffset = 64;
    if(self.edgesForExtendedLayout & UIRectEdgeTop)
    {
        bottomOffset = 0;
    }
    standardCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, viewRect.size.height-bottomOffset) collectionViewLayout:flowLayout];
    standardCollectionView.dataSource = self;
    standardCollectionView.delegate = self;
    standardCollectionView.allowsSelection = YES;
    standardCollectionView.backgroundColor = [UIColor whiteColor];
    standardCollectionView.alwaysBounceVertical = YES;
    [standardCollectionView registerClass:[GenericCollectionViewCell class] forCellWithReuseIdentifier:@"grid_cell_identifier"];
    
    standardCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    standardCollectionView.contentSize = CGSizeMake(viewRect.size.width, viewRect.size.height*2);
    [self.view addSubview:standardCollectionView];
    //NSLog(@"base list view controller:buildLayout->standardCollectionView  frame.size.height %fd, contentSize.height %ff ",standardCollectionView.frame.size.height, standardCollectionView.contentSize.height);
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -LOAD_HEADER_HEIGHT, viewRect.size.width, LOAD_HEADER_HEIGHT)];
    
    refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshIndicator.frame = CGRectMake(viewRect.size.width/2 - 90, 2, 36, 36);
    //loadMoreIndicator.hidesWhenStopped = NO;
    [headerView addSubview:refreshIndicator];
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewRect.size.width/2 - 50, 9, 140, 22)];
    refreshLabel.text = @"下拉刷新数据";
    [headerView addSubview:refreshLabel];
    [standardCollectionView addSubview:headerView];

    
    
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
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets inset = standardCollectionView.contentInset;
    inset.top += LOAD_HEADER_HEIGHT;
    standardCollectionView.contentInset = inset;
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
    UIEdgeInsets inset = standardCollectionView.contentInset;
    inset.top -= LOAD_HEADER_HEIGHT;
    standardCollectionView.contentInset = inset;
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
    [self emptyEntities];
    [standardCollectionView reloadData];
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
            [standardCollectionView reloadData];
        }
        isLoading = NO;
        [self completeLoading];
    } withMethod:HttpMethodPost];
}
- (UICollectionViewCell *) generateListCellWithDataEntity:(id) dataEntity forItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"grid_cell_identifier";
    UICollectionViewCell *cell = [standardCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.autoresizesSubviews = YES;
    return cell;
}
- (void)fillInCell:(UICollectionViewCell *)collectionViewCell withDataEntity:(id)dataEntity
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
        if (scrollView.contentOffset.y <= -LOAD_HEADER_HEIGHT-topOffset) {
            // User is scrolling above the header
            refreshLabel.text = @"放开刷新数据";
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = @"下拉刷新数据";
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading)
        return;
    if(scrollView.contentOffset.y  <= -LOAD_HEADER_HEIGHT-topOffset){
        
        [self refresh];
    }
}
#pragma mark - UICollectionViewDataSource


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return tableDataList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    id dataEntity  = [tableDataList objectAtIndex:indexPath.row];
    UICollectionViewCell *cell = cell = [self generateListCellWithDataEntity:dataEntity forItemAtIndexPath:indexPath];
    [self fillInCell:cell withDataEntity:dataEntity];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = indexPath.row;
    id dataEntity = [tableDataList objectAtIndex:row];
    [self viewItem:dataEntity];
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
