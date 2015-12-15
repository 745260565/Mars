//
//  HttpNetworkManager.h
//  MacrameFramework
//
//  Created by Franklin Zhang on 15/10/24.
//  Copyright © 2015年 macrame. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"



typedef enum{
    HttpMethodGet = 1,
    HttpMethodPost = 2
} HttpMethod;
@class BaseHttpClient;

/**
 *  请求成功后的数据简单处理后的回调
 *
 *  @param resultDic 返回的字典对象
 */
typedef void (^HttpResponseSuccessBlock) (id response);

/**
 *  请求失败后的响应及错误实例
 *
 *  @param operation 响应
 *  @param erro      错误实例
 */
typedef void (^HttpResponseErrorBlock) (AFHTTPRequestOperation *operation,NSError *error,NSString *description);

typedef void (^ADBlock)(NSString *imageUrl);

@interface HttpNetworkManager : NSObject<UIAlertViewDelegate>

@property BaseHttpClient *httpClient;
/**
 *  诊断网络状态，并且适时提出网络异常报警
 */
@property Reachability *reachability;



@property BOOL isShowNetAlert;

@property (nonatomic, strong) NSDictionary *paramdic;
@property (nonatomic, assign) BOOL needSeesion;


+ (instancetype)instanceManager;

/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param parameter        请求所带的参数
 *  @param path             网络请求的接口地址
 *  @param classType        返回数据的类型
 *  @param completion       成功请求后得到的响应回调
 *  @param httpMethod       HttpPost或HttpGet
 *  @param appendAttachment 要上传的附件,上传附件只支持GET请求
 */
+ (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion;//get请求
+ (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod;
//+ (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod appendAttachment:(NSDictionary *)attachments;//上传
+ (void)uploadAttachment:(NSDictionary *)attachments withParameter:(NSMutableDictionary*)parameters withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion;
+ (void) downloadFromPath:(NSString *)path progress:(NSProgress *)progress toDirecotry:(NSString *) destinationDirecotry completion:(void(^) (NSURL *filePath, NSError *error)) completion;
+ (BOOL)isExistNetwork;

- (BOOL)isExistenceNetwork;

- (BOOL) IsEnableWIFI;

- (BOOL) IsEnable3G;

/**
 *  请求成功后的数据简单处理后的回调
 *
 *  @param resultDic 返回的字典对象
 */
typedef void (^HttpResponseSucBlock) (NSDictionary *resultDic);
/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param completeBlock 成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
//- (void)requestServerWithURL:(NSString*)URLString parameter:(NSDictionary *)parameter finish:(HttpResponseSucBlock)completeBlock error:(HttpResponseErrorBlock)errorBlock;

//获取所有的需要的参数
//- (void)getAllParamList;

@end

@interface BaseHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@interface Configuration : NSObject
+ (Configuration *)sharedInstance;
//请求基本url 如http://10.1.1.1:8080/api
@property NSString *httpBasUrl;
//返回数据格式中标识结果成功与否的属性名
@property NSString *resultCodeKey;
//成功请求后得到的响应回调
@property NSString *resultDataKey;
//返回数据格式中描述信息的属性名
@property NSString *resultMessageKey;

@property NSString *totalElementsKey;
@property NSString *pageContentKey;

@property NSInteger requestPageStartIndexValue;
@property NSString *requestPageNumberKey;
@property NSString *requestPageSizeKey;
@end
