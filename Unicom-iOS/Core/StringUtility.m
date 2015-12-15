//
//  StringUtility.m
//  orange-member
//
//  Created by Franklin Zhang on 5/6/15.
//  Copyright (c) 2015 eFamily. All rights reserved.
//

#import "StringUtility.h"
#import "Constant.h"
extern NSString *generateRandomString(NSInteger length)
{
    NSString *outputString = @"1234567890!@#$%^&*()";
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSLog(@"%d", (int)outputString.length);
    
    for(int j=0;j<outputString.length;j++)
    {
        NSLog(@"Index = %d  Char = %@",j, [outputString substringWithRange:NSMakeRange(j, 1)]);
    }
    
    
    
    for(int i=0;i<length;i++)
    {
        int type = arc4random() % 3;
        int index  = arc4random();
        switch (type) {
            case 0:
                index = 'A' + index %26;
                break;
            case 1:
                index = 'a' + index %26;
                break;
            case 2:
                index = '0' + index %10;
                break;
            default:
                break;
        }
        
        [resultString appendFormat:@"%c", index];
    }
    
    if (resultString) {
        NSLog(@"%@", resultString);
    }
    
    return resultString;
}
@implementation StringUtility
+ (NSString *) generateURL:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@",HTTP_DOMAIN,path];
}
+ (NSString *) generateURLForDomain:(NSString *)domain withPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@",domain, path];
}
@end
