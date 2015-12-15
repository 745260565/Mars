//
//  HttpService.m
//  rainbow-core
//
//  Created by Franklin Zhang on 9/13/14.
//  Copyright (c) 2014 Macrame. All rights reserved.
//



#import "HttpService.h"
#import "StringUtility.h"
#import "AppDelegate.h"
@implementation HttpService
+ (instancetype) sharedService//单例,只能实例化一个对象
{
    static HttpService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //service = [[HttpService alloc] initWithBaseURL:[NSURL URLWithString:HTTP_RELATIVE_URL relativeToURL:[NSURL URLWithString:HTTP_DOMAIN]]];
        service = [[HttpService alloc] init];
    });
    return service;
}

- (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion//URL+path 没有appendAttachment同时是GET请求
{
    [self request:parameter withPath:path targetClass:classType completion:completion withMethod:HttpMethodGet];
}
- (void) request:(NSMutableDictionary *)parameter withFullPath:(NSString *)fullpath targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion//没有appendAttachment同时是GET请求
{
    [self request:parameter withFullPath:fullpath targetClass:classType completion:completion withMethod:HttpMethodGet];
}
- (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod//URL+path 没有appendAttachment
{
    [self request:parameter withPath:path targetClass:classType completion:completion withMethod:httpMethod appendAttachment:nil];
}
- (void) request:(NSMutableDictionary *)parameter withFullPath:(NSString *)fullpath targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod//没有appendAttachmetnt
{
    [self request:parameter withFullPath:fullpath targetClass:classType completion:completion withMethod:httpMethod appendAttachment:nil];
}
- (void) request:(NSMutableDictionary *)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod appendAttachment:(NSDictionary *)attachments//URL+path
{
    [self request:parameter withFullPath:[StringUtility generateURL:path] targetClass:classType completion:completion withMethod:httpMethod appendAttachment:attachments];
}
- (void) request:(NSMutableDictionary *)parameter withFullPath:(NSString *)fullpath targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod appendAttachment:(NSDictionary *)attachments
{
    if(fullpath == nil)
    {
        NSError *error = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:@"url is null"}];
        completion(nil,error);
        return;
    }
    if(parameter != nil)
        NSLog(@"%@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameter options:0 error:NULL] encoding:NSUTF8StringEncoding]);
    //if([NSJSONSerialization isValidJSONObject:parameter])
    {
        
        NSLog(@"Request to %@ ------", fullpath);
        NSLog(@"%@",parameter);
        for(NSString *key in parameter){
            NSLog(@"request parameter -- %@: %@",key,[parameter objectForKey:key]);
        }
//        void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"Response for %@ ------:%@", fullpath, responseObject);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completion(responseObject,nil);
//                });
//        };
        void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
            NSString *resultValue = [NSString  stringWithFormat:@"%@",[responseObject objectForKey:@"resultCode"]];
            if(resultValue && ![resultValue isEqualToString:@"<null>"] && [resultValue isEqualToString:@"0"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    id jsonValue = [responseObject objectForKey:@"data"];
                    
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
                        
                        NSString *jsonString = [responseObject objectForKey:@"data"];
                        completion(jsonString,nil);
                    }
                    else
                    {
                        completion([responseObject objectForKey:@"data"], nil);
                    }
                });
            }
            else
            {
                
                NSDictionary *responseContent = responseObject;
                NSString *errorDescription = [NSString stringWithFormat:@"%@",[responseContent objectForKey:@"message"]];
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
            NSLog(@"Error response for %@ ------:%@",fullpath, task.response);
            //[self performSelectorOnMainThread:@selector(onError:) withObject:[connectionError.userInfo objectForKey:@"NSLocalizedDescription"] waitUntilDone:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *wrappedError = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:[error.userInfo objectForKey:@"NSLocalizedDescription"]}];
                completion(nil,wrappedError);
            });
        };
        self.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回结果是json类型
        // do not set this::self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        self.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",nil];//接受包含结果类型
        self.requestSerializer  = [AFJSONRequestSerializer serializer];//申明请求为JSON类型
//        self.requestSerializer = [AFHTTPRequestSerializer serializer];
//        [self.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [self.requestSerializer setValue:@"text/plain; charset=UTF-8;application/json" forHTTPHeaderField:@"Content-Type"];
        
        if ([AppDelegate sharedApplicationDelegate].token != nil) {
            [self.requestSerializer setValue:[AppDelegate sharedApplicationDelegate].token forHTTPHeaderField:@"Authorization"];
        }
        
        if(httpMethod == HttpMethodPost)//Post请求
        {
            if(attachments != nil)//上传参数不为空
            {
                [self POST:fullpath parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    for(NSString *key in attachments)
                    {
                        NSData *data = [attachments objectForKey:key];
                        NSLog(@"add file request parameter -- %@: %lu",key,(unsigned long)data.length);
                        if([parameter objectForKey:@"contentType"]!=nil && [[parameter objectForKey:@"contentType"] isEqualToString:@"voice"])
                        {
                            [formData appendPartWithFileData:[attachments objectForKey:key] name:key fileName:[key stringByAppendingString:@".caf"] mimeType:@"application/octet-stream"];
                        }
                        else
                        {
                            [formData appendPartWithFileData:[attachments objectForKey:key] name:key fileName:[key stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
                        }
                    }
                    } success:successBlock failure:failureBlock];
            }
            else
            {
                [self POST:fullpath parameters:parameter success:successBlock failure:failureBlock];
            }
        }
        else if (httpMethod == HttpMethodPut)//对应PUT请求
        {
            if(attachments != nil)
            {
                NSError *error = [NSError errorWithDomain:@"rainbow" code:202 userInfo:@{NSLocalizedDescriptionKey:@"此请求不支持上传文件"}];
                completion(nil,error);
            }
            else
            [self PUT:fullpath parameters:parameter success:successBlock failure:failureBlock];
            
        }
        else if (httpMethod == HttpMethodDelete)//对应Delete请求
        {
            if(attachments != nil)
            {
                NSError *error = [NSError errorWithDomain:@"rainbow" code:202 userInfo:@{NSLocalizedDescriptionKey:@"此请求不支持上传文件"}];
                completion(nil,error);
            }
            else
            [self DELETE:fullpath parameters:parameter success:successBlock failure:failureBlock];
        }
        else//对应Get请求
        {
            if(attachments != nil)
            {
                NSError *error = [NSError errorWithDomain:@"rainbow" code:202 userInfo:@{NSLocalizedDescriptionKey:@"此请求不支持上传文件"}];
                completion(nil,error);
            }
            else
                [self GET:fullpath parameters:parameter success:successBlock failure:failureBlock];
        }
    }
//    else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSError *error = [NSError errorWithDomain:@"rainbow" code:201 userInfo:@{NSLocalizedDescriptionKey:@"parameter is invalid."}];
//            completion(nil,error);
//        });
//        
//        
//    }
}
//- (void) downloadFromPath:(NSString *)path progress:(NSProgress *)progress toDirecotry:(NSString *) destinationDirecotry completion:(void(^) (NSURL *filePath, NSError *error)) completion
//{
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",HTTP_DOMAIN,HTTP_RELATIVE_URL,path]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//
//        return [[NSURL fileURLWithPath:destinationDirecotry isDirectory:YES] URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        NSLog(@"status code :%ld",(long)httpResponse.statusCode);
//         NSLog(@"File downloaded to: %@", filePath.absoluteString);
//        completion(filePath, error);
//    }];
//    [downloadTask resume];
//}
- (void) envelopContent:(NSDictionary *) data toString:(NSMutableString *) parameter;
{
    
    for(NSString *key in data)
    {
        
        [parameter appendFormat:@"%@=%@",key,[data objectForKey:key]];
        [parameter appendString:@"&"];
    }
    [parameter deleteCharactersInRange:NSMakeRange(parameter.length-1, 1)];
}
- (void) envelopJsonContent:(NSDictionary *) data toString:(NSMutableString *) parameter;
{
    [parameter appendString:@"["];
    for(NSString *key in data)
    {
        [parameter appendString:@"{"];
        [parameter appendFormat:@"\"%@\":\"%@\"",key,[data objectForKey:key]];
        [parameter appendString:@"},"];
    }
    [parameter deleteCharactersInRange:NSMakeRange(parameter.length-1, 1)];
    [parameter appendString:@"]"];
}
@end
