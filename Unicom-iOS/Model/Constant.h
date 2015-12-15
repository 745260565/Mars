//
//  Constant.h
//  Mars
//
//  Created by jiamai on 15/11/5.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
#define HTTP_DOMAIN @"http://221.7.195.46:8008"
//#define HTTP_DOMAIN @"http://172.16.5.99:8080"

#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height          //包含状态bar的高度(e.g. 480)
#define kIOSVerison [[[UIDevice currentDevice] systemVersion] floatValue]

#define KEYBOARD_HEIGHT 216
#endif /* Constant_h */
