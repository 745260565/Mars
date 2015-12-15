//
//  StringUtility.h
//  orange-member
//
//  Created by Franklin Zhang on 5/6/15.
//  Copyright (c) 2015 eFamily. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *generateRandomString(NSInteger length);
@interface StringUtility : NSObject
+ (NSString *) generateURL:(NSString *)path;
+ (NSString *) generateURLForDomain:(NSString *)domain withPath:(NSString *)path;
@end
