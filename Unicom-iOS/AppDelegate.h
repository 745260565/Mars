//
//  AppDelegate.h
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/11/30.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Constant.h"
#import "SVProgressHUD.h"
#import "UserEntity.h"
#import "HttpNetworkManager.h"
#define kToken @"token"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,retain) UIColor *tintColor;
@property (nonatomic, retain) UIColor *backgroundGrayColor;
@property (nonatomic ,retain) NSString *token;
@property (nonatomic, retain) UserEntity *currentUserEntity;
@property (nonatomic ,retain ,readonly) UIViewController *rootViewController;


+(AppDelegate *)sharedApplicationDelegate;
- (void) showMenuTo:(UINavigationController *)viewController;
- (void) hideMenu:(void(^)(void))completionHandler;
- (void) completeSignin;
- (void) signout;
- (void)signToMain;

- (void)vaildToken;
- (void)setLeftMenuTargetNac:(UINavigationController *)nav;
- (void)showLeftMenu:(UINavigationController *)nav;
- (void)hiddenLeftMenu:(void (^)(BOOL finished) )completion;

- (void)setMMDrawerControllerRecognizeTouch;
- (void)setMMDrawerControllerUnRecognizeTouch;

@end

