//
//  UploadImageWithPath.h
//  Mars
//
//  Created by jiamai on 15/11/18.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UploadImageWithPath : NSObject
+ (instancetype) sharedInstance;

- (void)uploadPhotoWithImage:(UIImage *)image andWithPath:(NSString *)path andRequestDictionary:(NSMutableDictionary*)requestDictionary;

@end
