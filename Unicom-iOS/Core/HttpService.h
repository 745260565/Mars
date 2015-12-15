//
//  HttpService.h
//  rainbow-core
//
//  Created by Franklin Zhang on 9/13/14.
//  Copyright (c) 2014 Macrame. All rights reserved.
//
#define PARAMETER_USER_ID @"userId"
//#define PARAMETER_TOKEN @"token"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "Constant.h"

typedef enum{
    HttpMethodGet = 1,
    HttpMethodPost = 2,
    HttpMethodPut = 3,
    HttpMethodDelete = 4
} HttpMethod;

@interface HttpService : AFHTTPSessionManager
+ (instancetype) sharedService;
- (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion;
- (void) request:(NSMutableDictionary *)parameter withFullPath:(NSString *)fullpath targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion;
- (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod;
- (void) request:(NSMutableDictionary *)parameter withFullPath:(NSString *)fullpath targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod;
- (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod appendAttachment:(NSDictionary *)attachments;
- (void) request:(NSMutableDictionary *)parameter withFullPath:(NSString *)fullpath targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod appendAttachment:(NSDictionary *)attachments;
//- (void) downloadFromPath:(NSString *)path progress:(NSProgress *)progress toDirecotry:(NSString *) destinationDirecotry completion:(void(^) (NSURL *filePath, NSError *error)) completion;
@end