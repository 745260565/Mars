//
//  MalfunctionEntity.m
//  Mars
//
//  Created by jiamai on 15/11/9.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "MalfunctionEntity.h"
#import "AppDelegate.h"

@implementation MalfunctionEntity
+(NSDictionary*)allOrders{
    static NSDictionary *allOrder = nil;
    [HttpNetworkManager request:nil withPath:@"/api/fault/faultOrderInfo/list" targetClass:[NSDictionary class] completion:^(NSDictionary *result, NSError *error) {
        if (error) {
            allOrder = nil;
        }else{
            allOrder = result;
        }
        
        
    } withMethod:HttpMethodPost];
    return allOrder;
}
+(NSArray*)allOrdersArray{
    return [[self allOrders] objectForKey:@"content"];
}
+(NSDictionary*)detailOrder:(NSString *)orderId{
    static NSDictionary *detailOrder = nil;
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:orderId forKey:@"id"];
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/load" targetClass:[NSDictionary class] completion:^(NSDictionary *result, NSError *error) {
        if (error) {
            detailOrder = nil;
            NSLog(@"error:%@",error);
        }else{
            detailOrder = result;
        }
    } withMethod:HttpMethodPost];
    return detailOrder;

}

@end
