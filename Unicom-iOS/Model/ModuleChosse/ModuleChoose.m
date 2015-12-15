//
//  ModuleChoose.m
//  Mars
//
//  Created by jiamai on 15/9/30.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "ModuleChoose.h"

static NSArray *_moduleChooses = nil;
//static ModuleChoose *sharedInstance;
@implementation ModuleChoose

//+ (instancetype)sharedInstance{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[[self class] alloc] init];
//    });
//    return sharedInstance;
//}

+ (NSArray *)moduleChooses{
    if (!_moduleChooses) {
        
        ModuleChoose *moduleChoose0 = [[ModuleChoose alloc]init];
        moduleChoose0.moduleChooseIcon = @"breakdown_btn";
        moduleChoose0.moduleChooseSelectIcon = @"breakdown_btn_active";
        moduleChoose0.moduleChoosedescription = @"故障管理";
        
        ModuleChoose *moduleChoose1 = [[ModuleChoose alloc]init];
        moduleChoose1.moduleChooseIcon = @"form_btn";
        moduleChoose1.moduleChooseSelectIcon = @"form_btn_active";
        moduleChoose1.moduleChoosedescription = @"基站巡检";
        
        ModuleChoose *moduleChoose2 = [[ModuleChoose alloc]init];
        moduleChoose2.moduleChooseIcon = @"hidden_danger_btn";
        moduleChoose2.moduleChooseSelectIcon = @"hidden_danger_btn_active";
        moduleChoose2.moduleChoosedescription = @"隐患管理";
        
        ModuleChoose *moduleChoose3 = [[ModuleChoose alloc]init];
        moduleChoose3.moduleChooseIcon = @"patrol_btn";
        moduleChoose3.moduleChooseSelectIcon = @"patrol_btn_active";
        moduleChoose3.moduleChoosedescription = @"资产核查";
        
        ModuleChoose *moduleChoose4 = [[ModuleChoose alloc]init];
        moduleChoose4.moduleChooseIcon = @"property_btn";
        moduleChoose4.moduleChooseSelectIcon = @"property_btn_active";
        moduleChoose4.moduleChoosedescription = @"线路管理";
        
        ModuleChoose *moduleChoose5 = [[ModuleChoose alloc]init];
        moduleChoose5.moduleChooseIcon = @"work_btn";
        moduleChoose5.moduleChooseSelectIcon = @"work_btn_active";
        moduleChoose5.moduleChoosedescription = @"报表";
        
        ModuleChoose *moduleChoose6 = [[ModuleChoose alloc]init];
        moduleChoose6.moduleChooseIcon = @"breakdown_btn";
        moduleChoose6.moduleChooseSelectIcon = @"breakdown_btn_active";
        moduleChoose6.moduleChoosedescription = @"线路段数据";
        
        ModuleChoose *moduleChoose7 = [[ModuleChoose alloc]init];
        moduleChoose7.moduleChooseIcon = @"form_btn";
        moduleChoose7.moduleChooseSelectIcon = @"form_btn_active";
        moduleChoose7.moduleChoosedescription = @"转维验收报表";
        
        ModuleChoose *moduleChoose8 = [[ModuleChoose alloc]init];
        moduleChoose8.moduleChooseIcon = @"hidden_danger_btn";
        moduleChoose8.moduleChooseSelectIcon = @"hidden_danger_btn_active";
        moduleChoose8.moduleChoosedescription = @"传输动力隐患报表";
        
        ModuleChoose *moduleChoose9 = [[ModuleChoose alloc]init];
        moduleChoose9.moduleChooseIcon = @"patrol_btn";
        moduleChoose9.moduleChooseSelectIcon = @"patrol_btn_active";
        moduleChoose9.moduleChoosedescription = @"线路巡检报表";
        
        _moduleChooses = @[moduleChoose0,moduleChoose1,moduleChoose2,moduleChoose3,moduleChoose4,moduleChoose5,moduleChoose6,moduleChoose7,moduleChoose8,moduleChoose9];
    }
    return _moduleChooses;
}


@end
