//
//  UIConfig.h
//  NewMars
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIConfig : NSObject

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)colorAlpha ;
@end
