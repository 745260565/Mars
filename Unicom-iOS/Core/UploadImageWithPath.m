//
//  UploadImageWithPath.m
//  Mars
//
//  Created by jiamai on 15/11/18.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "UploadImageWithPath.h"
#import "AppDelegate.h"

@implementation UploadImageWithPath
+ (instancetype) sharedInstance//单例,只能实例化一个对象
{
    static UploadImageWithPath *uiwp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uiwp = [[UploadImageWithPath alloc] init];
    });
    return uiwp;
}

- (void)uploadPhotoWithImage:(UIImage *)image andWithPath:(NSString *)path andRequestDictionary:(NSMutableDictionary*)requestDictionary{
    NSData *imageData;
//    image = [UIImage imageNamed:@"backgoundImage7-1.png"];
//    if (UIImagePNGRepresentation(image) == nil) {
//        imageData = UIImageJPEGRepresentation(image, 0.1);
//    }else{
//        imageData = UIImagePNGRepresentation(image);
//    }
    imageData = UIImageJPEGRepresentation(image, 0.1);
//    NSDictionary *dataDictionary = @{@"file":imageData};
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回结果是json类型
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",nil];//接受包含结果类型
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];//申明请求为JSON类型
    [manager.requestSerializer setValue:@"text/plain; charset=UTF-8;application/json" forHTTPHeaderField:@"Content-Type"];
    [SVProgressHUD showWithStatus:@"正在上传..." maskType:SVProgressHUDMaskTypeClear];
    [manager POST:[NSString stringWithFormat:@"%@%@", HTTP_DOMAIN, @"/public/api/file/uploadSingleFile"] parameters:requestDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"add file request parameter --  %lu",(unsigned long)imageData.length);
        [formData appendPartWithFileData:imageData name:@"file" fileName:[@"file" stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, NSDictionary *responseDictionary) {
        NSLog(@"responseObject:%@",responseDictionary);
        [SVProgressHUD showWithStatus:@"上传成功..." maskType:SVProgressHUDMaskTypeClear];
        [NSThread sleepForTimeInterval:5];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showWithStatus:@"上传失败..." maskType:SVProgressHUDMaskTypeClear];
        [NSThread sleepForTimeInterval:0.5f];
        [SVProgressHUD dismiss];
    }];
//    [[HttpService sharedService]request:requestDictionary withPath:path targetClass:[NSString class] completion:^(NSString *resultString, NSError *error) {
//        if (error) {
//            NSLog(@"error:%@",error);
//            NSLog(@"上传失败");
//        }else{
//            NSLog(@"resultString:%@",resultString);
//        }
//    } withMethod:HttpMethodPost appendAttachment:dataDictionary];
}


@end
