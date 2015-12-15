//
//  DatabaseHelper.h
//  Mars
//
//  Created by jiamai on 15/11/7.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseHelper : NSObject
@property (nonatomic ,retain)NSString *databaseFile;
+ (DatabaseHelper *)sharedInstance;
- (BOOL)crateTables;
@end
