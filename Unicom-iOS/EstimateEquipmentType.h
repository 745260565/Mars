//
//  EstimateEquipmentType.h
//  Mars
//
//  Created by jiamai on 15/11/18.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstimateEquipmentType : NSObject

+ (instancetype) sharedInstance;

- (NSString *)estimateEquipmentType;

- (NSString *)phoneName;

- (NSString *)phoneModel;

- (NSString *)phoneSystemVersion;

@end
