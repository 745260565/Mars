//
//  AlertShowWithString.m
//  Mars
//
//  Created by jiamai on 15/11/12.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "AlertShowWithString.h"

@implementation AlertShowWithString
+(void)alertShowWithString:(NSString *)string{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:string message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
}
@end
