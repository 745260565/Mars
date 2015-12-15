//
//  ModuleChoose.h
//  Mars
//
//  Created by jiamai on 15/9/30.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleChoose : NSObject
@property (nonatomic ,retain) NSString *moduleChooseIcon;
@property (nonatomic ,retain) NSString *moduleChooseSelectIcon;
@property (nonatomic ,retain) NSString *moduleChoosedescription;
//+ (instancetype)sharedInstance;
+ (NSArray *)moduleChooses;
@end
