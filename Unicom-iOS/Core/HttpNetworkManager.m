//
//  HttpNetworkManager.m
//  MacrameFramework
//
//  Created by Franklin Zhang on 15/10/24.
//  Copyright © 2015年 macrame. All rights reserved.
//

#import "HttpNetworkManager.h"
#import "Constant.h"
#import "AppDelegate.h"

@implementation HttpNetworkManager
+ (instancetype)instanceManager
{
    
    static HttpNetworkManager *_instanceManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instanceManager = [[HttpNetworkManager alloc] init];
        _instanceManager.httpClient = [BaseHttpClient sharedClient];
        _instanceManager.reachability = [Reachability reachabilityWithHostname:@"http://www.163.com"];
    });
    
    return _instanceManager;
}

/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param successBlock  成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,但只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
+ (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion
{
    [HttpNetworkManager request:parameter withPath:path targetClass:classType completion:completion withMethod:HttpMethodGet];
}
+ (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod
{
    if([NSJSONSerialization isValidJSONObject:parameter])
    {
        NSError *jsonError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:&jsonError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        Configuration *configuration = [Configuration sharedInstance];
        NSString *baseUrl = configuration.httpBasUrl;
        NSLog(@"正在请求URL:%@%@, 请求参数:\n%@", baseUrl, path, jsonString);
        void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
            //NSLog(@"Task:%@", task);
            //NSLog(@"responseObject:%@", responseObject);
            NSString *resultValue = [NSString  stringWithFormat:@"%@",[responseObject objectForKey:configuration.resultCodeKey]];
            //NSLog(@"Response for %@ ------:%@", [HTTP_DOMAIN  stringByAppendingString:[HTTP_RELATIVE_URL stringByAppendingString:path]], responseObject);
            //for(NSString *key in resultDictionary){
            //    NSLog(@"%@: %@",key,[resultDictionary objectForKey:key]);
            //}
            NSString *result = [responseObject objectForKey:configuration.resultDataKey];
            NSLog(@"请求URL:%@%@已完成, 结果:\n%@", baseUrl, path, result);
            
            //NSString *description = [resultDictionary objectForKey:@"descript"];
            //NSLog(@"Description:%@",description);
            if(/*resultValue && ![resultValue isEqualToString:@"<null>"]&& */ [resultValue isEqualToString:@"0"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    id jsonValue = [responseObject objectForKey:configuration.resultDataKey];
                    
                    if(jsonValue == nil || [NSNull null] == jsonValue)//[jsonValue isKindOfClass:[NSNull class]] && ![jsonValue isEqualToString:@"<null>"]
                    {
                        completion(nil, nil);
                        return;
                    }
                    if(classType == [NSDictionary class])
                    {
                        if([jsonValue isKindOfClass:[NSDictionary class]])
                        {
                            completion(jsonValue,nil);
                        }
                        else
                        {
                            NSData *jsonData = [jsonValue dataUsingEncoding:NSUTF8StringEncoding];
                            NSError *jsonError = nil;
                            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
                            completion(resultDictionary,jsonError);
                        }
                        
                    }
                    else if(classType == [NSArray class])
                    {
                        if([jsonValue isKindOfClass:[NSArray class]])
                        {
                            completion(jsonValue,nil);
                        }
                        else
                        {
                            NSData *jsonData = [jsonValue dataUsingEncoding:NSUTF8StringEncoding];
                            NSArray *jsonArray = [NSKeyedUnarchiver unarchiveObjectWithData:jsonData];
                            
                            completion(jsonArray,nil);
                        }
                        
                    }
                    else if(classType == [NSString class])
                    {
                        
                        NSString *jsonString = [responseObject objectForKey:configuration.resultDataKey];
                        completion(jsonString,nil);
                    }
                    else
                    {
                        completion([responseObject objectForKey:configuration.resultDataKey], nil);
                    }
                });
            }
            else
            {
                //NSDictionary *responseContent = [responseObject objectForKey:configuration.resultDataKey];
                NSString *errorDescription = [responseObject objectForKey:configuration.resultMessageKey];
                
                if(errorDescription == nil || [errorDescription isEqualToString:@"<null>"])
                {
                    errorDescription = @"未知错误";
                }
                NSError *error = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
                completion(nil,error);
            }
        
        };
        
        void (^failureBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"connection Error:%@", error.description);
            for(NSString *key in error.userInfo){
                NSLog(@"connectionError-%@: %@",key,[error.userInfo objectForKey:key]);
            }
            //NSLog(@"Error response for %@ ------:%@", [HTTP_DOMAIN  stringByAppendingString:[HTTP_RELATIVE_URL stringByAppendingString:path]], task.response);
            //[self performSelectorOnMainThread:@selector(onError:) withObject:[connectionError.userInfo objectForKey:@"NSLocalizedDescription"] waitUntilDone:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *wrappedError = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:[error.userInfo objectForKey:@"NSLocalizedDescription"]}];
                completion(nil,wrappedError);
            });
        };
        
        if(httpMethod == HttpMethodPost)
        {
            [HttpNetworkManager postBody:[baseUrl stringByAppendingString:path] parameters:jsonString success:successBlock failure:failureBlock];
            
        }
        else
        {
            BaseHttpClient *httpClient = [[self instanceManager] httpClient];
            // do not set this::self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            httpClient.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",nil];
            
            [httpClient GET:[baseUrl stringByAppendingString:path]  parameters:jsonString success:successBlock failure:failureBlock];
        }
    }else{//请求体为空时
        Configuration *configuration = [Configuration sharedInstance];
        NSString *baseUrl = configuration.httpBasUrl;
        NSLog(@"正在请求URL:%@%@", baseUrl, path);
        void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
            NSString *resultValue = [NSString  stringWithFormat:@"%@",[responseObject objectForKey:configuration.resultCodeKey]];
            NSDictionary *result = [responseObject objectForKey:configuration.resultDataKey];
            NSLog(@"请求URL:%@%@已完成, 结果:\n%@", baseUrl, path, result);
            if([resultValue isEqualToString:@"0"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    id jsonValue = [responseObject objectForKey:configuration.resultDataKey];
                    if(jsonValue == nil || [NSNull null] == jsonValue)//[jsonValue isKindOfClass:[NSNull class]] && ![jsonValue isEqualToString:@"<null>"]
                    {
                        completion(nil, nil);
                        return;
                    }
                    if(classType == [NSDictionary class])
                    {
                        if([jsonValue isKindOfClass:[NSDictionary class]])
                        {
                            completion(jsonValue,nil);
                        }
                        else
                        {
                            NSData *jsonData = [jsonValue dataUsingEncoding:NSUTF8StringEncoding];
                            NSError *jsonError = nil;
                            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
                            completion(resultDictionary,jsonError);
                        }
                        
                    }
                    else if(classType == [NSArray class])
                    {
                        if([jsonValue isKindOfClass:[NSArray class]])
                        {
                            completion(jsonValue,nil);
                        }
                        else
                        {
                            NSData *jsonData = [jsonValue dataUsingEncoding:NSUTF8StringEncoding];
                            NSArray *jsonArray = [NSKeyedUnarchiver unarchiveObjectWithData:jsonData];
                            
                            completion(jsonArray,nil);
                        }
                        
                    }
                    else if(classType == [NSString class])
                    {
                        
                        NSString *jsonString = [responseObject objectForKey:configuration.resultDataKey];
                        completion(jsonString,nil);
                    }
                    else
                    {
                        completion([responseObject objectForKey:configuration.resultDataKey], nil);
                    }
                });
            }
            else
            {
                NSString *errorDescription = [responseObject objectForKey:configuration.resultMessageKey];
                
                if(errorDescription == nil || [errorDescription isEqualToString:@"<null>"])
                {
                    errorDescription = @"未知错误";
                }
                NSError *error = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
                completion(nil,error);
            }
            
        };
        
        void (^failureBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"connection Error:%@", error.description);
            for(NSString *key in error.userInfo){
                NSLog(@"connectionError-%@: %@",key,[error.userInfo objectForKey:key]);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *wrappedError = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:[error.userInfo objectForKey:@"NSLocalizedDescription"]}];
                completion(nil,wrappedError);
            });
        };
        if(httpMethod == HttpMethodPost)
        {
            [HttpNetworkManager postBody:[baseUrl stringByAppendingString:path] parameters:nil success:successBlock failure:failureBlock];
            
        }
        else
        {
            BaseHttpClient *httpClient = [[self instanceManager] httpClient];
            // do not set this::self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            httpClient.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",nil];
            
            [httpClient GET:[baseUrl stringByAppendingString:path]  parameters:nil success:successBlock failure:failureBlock];
        }
    }
}
+ (NSURLSessionDataTask *)postBody:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    BaseHttpClient *httpClient = [[self instanceManager] httpClient];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [httpClient.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&serializationError];
    [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    if ([AppDelegate sharedApplicationDelegate].token !=nil) {
        [request setValue:[AppDelegate sharedApplicationDelegate].token forHTTPHeaderField:@"Authorization"];
    }
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    __block NSURLSessionDataTask *task = [httpClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    
    
    [task resume];
    
    return task;
}

+ (void)uploadAttachment:(NSDictionary *)attachments withParameter:(NSMutableDictionary*)parameters withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion
{
    
    BaseHttpClient *httpClient = [[self instanceManager] httpClient];
    Configuration *configuration = [Configuration sharedInstance];
    NSString *baseUrl = configuration.httpBasUrl;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",nil];//接受包含结果类型
    [manager.requestSerializer setValue:@"text/plain; charset=UTF-8;application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:[baseUrl stringByAppendingString:path] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(NSString *key in attachments)
        {
            NSData *data = [attachments objectForKey:key];
            NSLog(@"add file request parameter -- %@: %lu KB",key,(unsigned long)data.length/1024);
            if([parameters objectForKey:@"contentType"]!=nil && [[parameters objectForKey:@"contentType"] isEqualToString:@"voice"])
            {
                [formData appendPartWithFileData:[attachments objectForKey:key] name:@"files" fileName:[key stringByAppendingString:@".caf"] mimeType:@"application/octet-stream"];
            }
            else
            {
                
                [formData appendPartWithFileData:[attachments objectForKey:key] name:@"files" fileName:[key stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
            }
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"Task:%@", task);
        //NSLog(@"responseObject:%@", responseObject);
        NSString *resultValue = [NSString  stringWithFormat:@"%@",[responseObject objectForKey:configuration.resultCodeKey]];
        //NSLog(@"Response for %@ ------:%@", [HTTP_DOMAIN  stringByAppendingString:[HTTP_RELATIVE_URL stringByAppendingString:path]], responseObject);
        //for(NSString *key in resultDictionary){
        //    NSLog(@"%@: %@",key,[resultDictionary objectForKey:key]);
        //}
        NSString *result = [responseObject objectForKey:configuration.resultDataKey];
        NSLog(@"请求URL:%@%@已完成, 结果:\n%@", baseUrl, path, result);
        
        //NSString *description = [resultDictionary objectForKey:@"descript"];
        //NSLog(@"Description:%@",description);
        if(resultValue && ![resultValue isEqualToString:@"<null>"] && [resultValue isEqualToString:@"0"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                id jsonValue = [responseObject objectForKey:configuration.resultDataKey];
                
                if(jsonValue == nil || [NSNull null] == jsonValue)//[jsonValue isKindOfClass:[NSNull class]] && ![jsonValue isEqualToString:@"<null>"]
                {
                    completion(nil, nil);
                    return;
                }
                if(classType == [NSDictionary class])
                {
                    if([jsonValue isKindOfClass:[NSDictionary class]])
                    {
                        completion(jsonValue,nil);
                    }
                    else
                    {
                        NSData *jsonData = [jsonValue dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *jsonError = nil;
                        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
                        completion(resultDictionary,jsonError);
                    }
                    
                }
                else if(classType == [NSArray class])
                {
                    if([jsonValue isKindOfClass:[NSArray class]])
                    {
                        completion(jsonValue,nil);
                    }
                    else
                    {
                        NSData *jsonData = [jsonValue dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray *jsonArray = [NSKeyedUnarchiver unarchiveObjectWithData:jsonData];
                        
                        completion(jsonArray,nil);
                    }
                    
                }
                else if(classType == [NSString class])
                {
                    
                    NSString *jsonString = [responseObject objectForKey:configuration.resultDataKey];
                    completion(jsonString,nil);
                }
                else
                {
                    completion([responseObject objectForKey:configuration.resultDataKey], nil);
                }
            });
        }
        else
        {
            NSDictionary *responseContent = [responseObject objectForKey:configuration.resultDataKey];
            NSString *errorDescription = [responseContent objectForKey:configuration.resultMessageKey];
            
            if(errorDescription == nil || [errorDescription isEqualToString:@"<null>"])
            {
                errorDescription = @"未知错误";
            }
            NSError *error = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
            completion(nil,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *wrappedError = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:[error.userInfo objectForKey:@"NSLocalizedDescription"]}];
            completion(nil,wrappedError);
        });
    }];
    
}
+ (void) downloadFromPath:(NSString *)path progress:(NSProgress *)progress toDirecotry:(NSString *) destinationDirecotry completion:(void(^) (NSURL *filePath, NSError *error)) completion
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",@"HTTP",@"DOMAIN",path]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    BaseHttpClient *httpClient = [[self instanceManager] httpClient];
    
    NSURLSessionDownloadTask *downloadTask = [httpClient downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        return [[NSURL fileURLWithPath:destinationDirecotry isDirectory:YES] URLByAppendingPathComponent:[response suggestedFilename]];
        //NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //return [documentsDirectoryURL URLByAppendingPathComponent:@"aaa.acf"];//[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"status code :%ld",(long)httpResponse.statusCode);
        NSLog(@"File downloaded to: %@", filePath.absoluteString);
        completion(filePath, error);
    }];
    [downloadTask resume];
}
+ (BOOL)isExistNetwork
{
    BOOL isExistenceNetwork;
    //    Reachability *reachAblitity = [Reachability reachabilityForInternetConnection];
    Reachability *reachAblitity = [Reachability reachabilityWithHostname:@"http://www.baidu.com"];
    switch ([reachAblitity currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    
    return isExistenceNetwork;
}


- (id) init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    //    Reachability *reachAblitity = [Reachability reachabilityForInternetConnection];
    Reachability *reachAblitity = [Reachability reachabilityWithHostname:@"http://www.baidu.com"];
    switch ([reachAblitity currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    
    return isExistenceNetwork;
}

- (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

- (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param completeBlock 成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
//- (void)requestServerWithURL:(NSString*)URLString parameter:(NSDictionary *)parameter finish:(HttpResponseSucBlock)completeBlock error:(HttpResponseErrorBlock)errorBlock
//{
//    NSLog(@"URL:%@, 请求参数:\n%@", URLString, parameter);
//    //[self.httpClient.requestSerializer setValue:[MyTools getTheSeesionId] forHTTPHeaderField:@"user_session"];
//    [self.httpClient POST:URLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSLog(@"URL:%@\n, 返回值:%@",operation.request.URL, responseObject);
//
//        NSError *parserError = nil;
//        NSDictionary *resultDictionry = nil;
//        @try {
//            resultDictionry = (NSDictionary *)responseObject;
//        }
//        @catch (NSException *exception) {
//            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
//            //发出消息错误的通知
//        }
//        @finally {
//            //业务产生的状态码
//            NSNumber *logicCode = resultDictionry[@"status"];
//
//            //成功获得数据
//            if (logicCode.intValue == StateOk) {
//                completeBlock(resultDictionry);
//            }
//            else{
//                //业务逻辑错误
//                NSString *message = [resultDictionry objectForKey:@"message"];
//                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
//
//                //未登录或者登录过期
//                if (logicCode.intValue == StateUserErrorUnLogin || logicCode.intValue == StateSessionInValid) {
//                    //移除sessionId
//
//                }
//
//                errorBlock(nil,error,message);
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //请求失败
//        if (![self isExistenceNetwork]) {
//
//            errorBlock(operation,error,@"网络有问题，请稍后再试");
//        }
//        else{
//            errorBlock(operation,error,@"数据请求失败");
//        }
//
//
//    }];
//}

//获取所有的需要的参数
//- (void)getAllParamList
//{
//    [self requestServerWithURL:@"area!getFishConfig.action" parameter:nil finish:^(NSDictionary *resultDictionary) {
//        self.paramdic = resultDictionary;
//    } error:^(AFHTTPRequestOperation *operation, NSError *error,NSString *description) {
//        if (error.code == 404) {
//            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"网络不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//            [alert show];
//        }
//    }];
//}


@end

@implementation BaseHttpClient

+ (instancetype)sharedClient
{
    static BaseHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BaseHttpClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        [_sharedClient.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
        //[_sharedClient.requestSerializer setValue:APP_KEY forHTTPHeaderField:@"sign_appkey"];
        
        
    });
    
    return _sharedClient;
}

@end

@implementation Configuration
@synthesize httpBasUrl = httpBasUrl;
+ (Configuration *)sharedInstance
{
    static Configuration *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Configuration alloc] init];
        
    });
    
    return _sharedInstance;

}


@end
