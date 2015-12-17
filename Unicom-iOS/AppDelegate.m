//
//  AppDelegate.m
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/11/30.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "Constant.h"
#import "RSLeftMenuViewController.h"
#import "REFrostedViewController.h"
#import "UMCheckUpdate.h"
#import "MobClick.h"
#import "RSSideViewController.h"
#import "MMDrawerVisualState.h"
#import "EstimateEquipmentType.h"

@interface AppDelegate ()
{
    REFrostedViewController *frostedViewController;
    RSSideViewController * drawerController;
    RSLeftMenuViewController *menuViewController;//左边侧边栏

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.tintColor = [UIColor colorWithRed:16.0/255 green:164.0/255 blue:231.0/255 alpha:1.0f];
    self.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav"]];
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    self.backgroundGrayColor = [UIColor colorWithRed:203.0/255 green:207.0/255 blue:207.0/255 alpha:0.8f];
    self.window.tintColor = self.tintColor;
    // [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.8]];
    
    [UINavigationBar appearance].barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav"]];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    
    //Check the latest version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [UMCheckUpdate setVersion:[version integerValue]];
    [UMCheckUpdate checkUpdateWithAppkey:@"565ff2b6e0f55adf07004045" channel:@"App Store"];
    //Enable Umeng Analytics
    [MobClick setVersion:[version integerValue]];
    [MobClick startWithAppkey:@"565ff2b6e0f55adf07004045" reportPolicy:SEND_INTERVAL channelId:@"App Store"];
    
    Configuration *configuration = [Configuration sharedInstance];
    configuration.httpBasUrl = [NSString stringWithFormat:@"%@",HTTP_DOMAIN];
    configuration.resultCodeKey = @"resultCode";
    configuration.resultDataKey = @"data";
    configuration.resultMessageKey = @"message";
    configuration.totalElementsKey = @"totalElements";
    configuration.pageContentKey = @"content";
    
    configuration.requestPageNumberKey = @"page";
    configuration.requestPageSizeKey = @"size";
    configuration.requestPageStartIndexValue = 0;    
    
    self.token = [defaults objectForKey:kToken];
    if (self.token ==nil) {
        [self toSignin];
    }
    else{
        NSLog(@"token:%@",self.token);
//        [self toSignin];
        if([HttpNetworkManager isExistNetwork]){
        [self vaildToken];
        }else{
            [self toSignin];
            [SVProgressHUD showInfoWithStatus:@"没有网络" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"进入后台");
    //当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"从后台启动程序");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"username"]];
    if (![username isEqualToString:@"(null)"]) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
        [requestDictionary setObject:username forKey:@"username"];
        [requestDictionary setObject:@"iOS" forKey:@"clientType"];
        [requestDictionary setObject:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"clientVersion"];
        [requestDictionary setObject:[UIDevice currentDevice].identifierForVendor.UUIDString  forKey:@"deviceId"];
        [requestDictionary setObject:[[EstimateEquipmentType sharedInstance] estimateEquipmentType] forKey:@"deviceDescription"];
        [HttpNetworkManager request:requestDictionary withPath:@"/public/api/system/sysBpsUsers/launchClient" targetClass:[NSString class] completion:^(NSString *resultString, NSError *error) {
            if (error) {
            }else{
                NSLog(@"resultString:%@",resultString);
            }
        } withMethod:HttpMethodPost];
    }
    //当程序从后台将要重新回到前台时候调用
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


+ (AppDelegate *)sharedApplicationDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (UIViewController *) rootViewController{
    return self.window.rootViewController;
}
- (void) showMenuTo:(UINavigationController *)viewController
{
    RSLeftMenuViewController *menuViewController = (RSLeftMenuViewController*) frostedViewController.menuViewController;
    menuViewController.targetNavigationController = viewController;
        
    
    [frostedViewController presentMenuViewController];
}
- (void) hideMenu:(void(^)(void))completionHandler
{
    [frostedViewController hideMenuViewControllerWithCompletionHandler:completionHandler];
}
- (void) toSignin{
    UIViewController *viewController = [[LoginViewController alloc]init];
    self.window.rootViewController = viewController;
}
- (void) signout{
    [MobClick profileSignOff];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kToken];
    self.currentUserEntity = nil;
    UIViewController *viewController = [[LoginViewController alloc]init];
    self.window.rootViewController = viewController;
}

//- (void)vaildToken{
//    NSError *serializationError = nil;
//    BaseHttpClient *httpClient = [[HttpNetworkManager instanceManager] httpClient];
//    NSMutableURLRequest *request = [httpClient.requestSerializer requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@/api/system/sysBpsUsers/verifyToken",HTTP_DOMAIN] parameters:nil error:&serializationError];
//    [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[AppDelegate sharedApplicationDelegate].token forHTTPHeaderField:@"Authorization"];
//    [httpClient dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSLog(@"responseObject:%@",responseObject);
//        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"resultDictionary:%@",resultDictionary);
//    }];
//}

//- (void)vaildToken{
//
//    [HttpNetworkManager request:nil withPath:@"/api/system/sysBpsUsers/verifyToken" targetClass:[NSDictionary class] completion:^(NSDictionary *resultDictionary, NSError *error) {
//        if (error) {
//            NSLog(@"error:%@",error);
//            
//        }else{
////            NSDictionary *dataDictionary = [resultDictionary objectForKey:@"data"];
//                    UserEntity *user = [[UserEntity alloc] init];
//                    user.userName = [resultDictionary objectForKey:@"userDspname"];
//                    user.mobile = [resultDictionary objectForKey:@"userMb"];
//                    user.userId = [NSString stringWithFormat:@"%ld",[[resultDictionary objectForKey:@"userId"] longValue]];
//                    [AppDelegate sharedApplicationDelegate].currentUserEntity = user;
//            
//                    [MobClick profileSignInWithPUID:user.userId];//当用户用帐号登录时统计
//                   // [self completeSignin];
//                    [self signToMain];
//            
//        }
//    } withMethod:HttpMethodPost];
//}

- (void)vaildToken{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTP_DOMAIN, @"/api/system/sysBpsUsers/verifyToken"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/plain; charset=UTF-8;application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:self.token forHTTPHeaderField:@"Authorization"];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [SVProgressHUD dismiss];
    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"resultDictionary:%@",resultDictionary);
    NSString *resultMessage = [resultDictionary objectForKey:@"message"];
    NSString *resultValue = [NSString  stringWithFormat:@"%@",[resultDictionary objectForKey:@"resultCode"]];
    if (![resultValue isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证失败" message:resultMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
        self.currentUserEntity = nil;
        [self toSignin];
    }else{
        NSDictionary *dataDictionary = [resultDictionary objectForKey:@"data"];
        UserEntity *user = [[UserEntity alloc] init];
        user.userName = [dataDictionary objectForKey:@"userDspname"];
        user.mobile = [dataDictionary objectForKey:@"userMb"];
        user.userId = [NSString stringWithFormat:@"%ld",[[dataDictionary objectForKey:@"userId"] longValue]];
        [AppDelegate sharedApplicationDelegate].currentUserEntity = user;
        
        [MobClick profileSignInWithPUID:user.userId];//当用户用帐号登录时统计
       // [self completeSignin];
        [self signToMain];
    }
}



- (void) completeSignin
{
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //[UINavigationBar appearance].translucent = NO;
    RSLeftMenuViewController *menuViewController = [[RSLeftMenuViewController alloc] init];
    frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuViewController];
    frostedViewController.menuViewSize = menuViewController.menuViewSize;
    frostedViewController.liveBlur = YES;
    self.window.rootViewController = frostedViewController;
}


- (void)signToMain
{
    static const CGFloat kPublicLeftMenuWidth = 224.0f;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //[UINavigationBar appearance].translucent = NO;
    
    menuViewController = [[RSLeftMenuViewController alloc] init];
    
    drawerController = [[RSSideViewController alloc]
                        initWithCenterViewController:navigationController                                            leftDrawerViewController:menuViewController
                        rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *mmdrawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(mmdrawerController, drawerSide, percentVisible);
    }];
    [drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            return false;
        }else{
            return true;
        }
    }];
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
    
}


- (void)setLeftMenuTargetNac:(UINavigationController *)nav
{
    menuViewController.targetNavigationController  = nav;
}

- (void)showLeftMenu:(UINavigationController *)nav
{
    menuViewController.targetNavigationController  = nav;
    [drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:^(BOOL finished) {
    }];
}

- (void)hiddenLeftMenu:(void (^)(BOOL finished) )completion
{
    [drawerController toggleDrawerSide:MMDrawerSideLeft animated:true completion:completion];
}

- (void)setMMDrawerControllerRecognizeTouch
{
    [drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        NSLog(@"setMMDrawerController RecognizeTouch touch");
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            return false;
        }else{
            return true;
        }
    }];
    
}

- (void)setMMDrawerControllerUnRecognizeTouch
{
    [drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        NSLog(@"setMMDrawerController UnRecognizeTouch touch");
        return false;
    }];
    
}

/*- (void)switchToMainVC
{
    static const CGFloat kPublicLeftMenuWidth = 180.0f;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    RSLeftMenuViewController *leftVC =  [story instantiateViewControllerWithIdentifier:@"RSLeftMenuViewController"];
    
    MainViewController * drawerController = [[MainViewController alloc]
                                             initWithCenterViewController:leftVC.navSlideSwitchVC
                                             leftDrawerViewController:leftVC
                                             rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
    
}*/

@end
