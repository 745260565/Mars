//
//  MalfunctionEntity.h
//  Mars
//
//  Created by jiamai on 15/11/9.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MalfunctionEntity : NSObject
+(NSDictionary*)allOrders;
+(NSArray*)allOrdersArray;
+(NSDictionary *)detailOrder:(NSString *)orderId;
@end
