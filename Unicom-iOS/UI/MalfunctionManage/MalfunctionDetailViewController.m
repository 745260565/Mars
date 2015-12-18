//
//  MalfunctionDetailViewController.m
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/12/2.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import "MalfunctionDetailViewController.h"
#import "AppDelegate.h"
#import "KxMenu.h"
#import "MapLocationViewController.h"
#import "DealProcessessViewController.h"
#import "AlertAndAffectedSitesViewController.h"
#import "LocationViewController.h"
#import "UploadImageWithPath.h"
@interface MalfunctionDetailViewController ()
{
    NSMutableArray *menuArray;
    UIImagePickerController *imagePickerController;
    NSArray *dynamicMenuArray;
}
@end

@implementation MalfunctionDetailViewController
- (instancetype)initWithId:(NSString *) orderIdValue withHandleMenus:(NSArray *)handleMenusArray
{
    self = [super init];
    if (self) {
        orderId = orderIdValue;
        menuArray = [NSMutableArray array];
        dynamicMenuArray = handleMenusArray;
        NSInteger k = 0;
        for (NSString *menu in handleMenusArray) {
            KxMenuItem *menuItem = [KxMenuItem menuItem:menu image:[UIImage imageNamed:@"sidebar-manege"] target:self action:@selector(handleAction:)];
            menuItem.tag = k++;
            [menuArray addObject:menuItem];
        }
        for (NSString *menu in @[@"站点位置",@"拍照上传",@"处理过程"]) {
            KxMenuItem *menuItem = [KxMenuItem menuItem:menu image:[UIImage imageNamed:@"sidebar-manege"] target:self action:@selector(handleAction:)];
            menuItem.tag = k++;
            [menuArray addObject:menuItem];
        }
    }
    return self;
    
}
- (void)loadView {
    [super loadView];
    // Do any additional setup after loading the view.
    [self buildLayout];
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buildLayout
{
    CGRect viewRect = self.view.frame;
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.title = @"故障详情";
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidebar_icon_healthreport"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
    self.navigationItem.rightBarButtonItem = actionButton;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, viewRect.size.height)];
    
    
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, viewRect.size.height)];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    
    [mainView addSubview:mainTable];
    
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(20, 5, viewRect.size.width-40, 50);
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:14];
    bottomButton.layer.borderWidth = 1;
    bottomButton.layer.cornerRadius = 5;
    bottomButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bottomButton.backgroundColor = [AppDelegate sharedApplicationDelegate].tintColor;
    [bottomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [bottomButton setTitle:@"查看受影响的基站和告警信息" forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(showSites:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, 60)];
    [footerView addSubview:bottomButton];
    mainTable.tableFooterView = footerView;
    
    
    [self.view addSubview:mainView];
    
}
- (void) showMenu:(id)sender
{
    [KxMenu setTintColor:[AppDelegate sharedApplicationDelegate].tintColor];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(kScreenWidth-36,0+60, 10, 10) menuItems:menuArray];
}
- (void) handleAction:(id)sender
{
    KxMenuItem *menuItem = sender;
    if (menuItem.tag < dynamicMenuArray.count) {
        [self handleMenu:menuItem.tag];
        return;
    }
    switch (menuItem.tag - dynamicMenuArray.count) {
        case 0:
            [self showMap];
            break;

        case 1:
            [self setPhoto:sender];
            break;
        case 2:
            [self showProcess];
        default:
            break;
    }
}
- (void) handleMenu:(NSInteger)index
{
    
}
- (void) loadData
{
    
    NSMutableDictionary *requestData = [[NSMutableDictionary alloc]init];
    [requestData setObject:orderId forKey:@"id"];
//    [SVProgressHUD showWithStatus:NSLocalizedString(@"Common.Loading", nil) maskType:SVProgressHUDMaskTypeClear];
    [HttpNetworkManager request:requestData withPath:@"/api/fault/faultOrderInfo/load" targetClass:[NSDictionary class] completion:^(NSDictionary *resultDictionary, NSError *error) {
//        [SVProgressHUD dismiss];
        if (error) {
//            [SVProgressHUD showErrorWithStatus:error.description];
        }else{
            orderDetail = resultDictionary;
            [self orderDataDidLoad];
            [mainTable reloadData];
        }
        
    } withMethod:HttpMethodPost];
    
}
- (void) orderDataDidLoad
{
    //Subclass can override this method
}
#pragma mark - UITableViewDataSrouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"subtitleTableCell";
    UITableViewCell *cell = [mainTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *labelArray = @[@"提交日期:",@"受理编号:",@"故障分类:",@"故障类型:",@"故障级别:",@"站点名称:",@"站点编号:",@"基站等级:",@"基站地址:",@"所属区域:",@"申 报 人:",@"故障描述:"];
    NSString *string = [NSString string];
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            string = @"declarerDate";
            break;
        case 1:
            string = @"orderCode";
            break;
        case 2:
            string = @"faultCategory";
            break;
        case 3:
            string = @"faultType";
            break;
        case 4:
            string = @"faultGradle";
            break;
        case 5:
            string = @"siteName";
            break;
        case 6:
            string = @"siteCode";
            break;
        case 7:
            string = @"siteLevel";
            break;
        case 8:
            string = @"address";
            break;
        case 9:
            string = @"area";
            break;
        case 10:
            string = @"declarer";
            break;
        case 11:
            string = @"faultEventDescription";
            break;
    }
    cell.textLabel.text = [labelArray objectAtIndex:row];
    NSString *value = [orderDetail objectForKey:string];
    if (value != [NSNull null] && ![value isEqualToString:@"<null>"]) {
        cell.detailTextLabel.text = value;
    }
    

    return cell;
}


#pragma mark - Handle Menu
- (void) showMap
{
    LocationViewController *viewController = [[LocationViewController alloc]init];
    viewController.dealLongitude = [[orderDetail objectForKey:@"longitude"] doubleValue];
    viewController.dealLatutude = [[orderDetail objectForKey:@"latitude"] doubleValue];
    viewController.siteName = [orderDetail objectForKey:@"siteName"];
    viewController.siteCode = [orderDetail objectForKey:@"siteCode"];
    [self.navigationController presentViewController:viewController animated:NO completion:nil];
}

- (void) showProcess
{
    DealProcessessViewController *viewController = [[DealProcessessViewController alloc]init];
    viewController.orderId = orderId;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) showSites:(id)sender
{
    AlertAndAffectedSitesViewController *viewController = [[AlertAndAffectedSitesViewController alloc] init];
    viewController.orderId = orderId;
    viewController.orderCode = [orderDetail objectForKey:@"orderCode"];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - Take photo
- (void) setPhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"选择一张照片", nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is a camera on this device, so add the camera button.
        [actionSheet addButtonWithTitle:@"拍照"];
        
    }
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons -1;
    [actionSheet showFromRect:CGRectMake(0, 0, 50, 50) inView:self.view animated:YES];
}
- (void) takePhoto:(id)sender
{
    [imagePickerController takePicture];
}
- (void) cancelPhoto:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    
    if(imagePickerController == nil)
    {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        //imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        //imagePickerController.navigationController.navigationBar.barTintColor = [AppDelegate sharedApplicationDelegate].tintColor;
    }
    imagePickerController.sourceType = sourceType;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self uploadPhoto:image];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void) uploadPhoto:(UIImage *)image
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:orderId forKey:@"id"];
    [requestDictionary setObject:username forKey:@"username"];
    [requestDictionary setObject:@"gz" forKey:@"module"];
    [[UploadImageWithPath sharedInstance] uploadPhotoWithImage:image andWithPath:@"/public/api/file/uploadSingleFile" andRequestDictionary:requestDictionary];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 1:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        default:
            break;
    }
}
@end
