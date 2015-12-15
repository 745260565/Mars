//
//  DatabaseHelper.m
//  Mars
//
//  Created by jiamai on 15/11/7.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "DatabaseHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@implementation DatabaseHelper
@synthesize databaseFile;
+ (DatabaseHelper *)sharedInstance{
    static DatabaseHelper *sharedInstance;
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[DatabaseHelper alloc]init];
        }
        return sharedInstance;
    }
}

- (BOOL) crateTables{
    return YES;
}

@end
