//
//  AliOSSFileUploadUtil.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/8.
//  Copyright © 2019 lzy. All rights reserved.
//


#import "AliOSSFileUploadUtil.h"
/**
#import "AliyunOSSiOS.h"

static NSString *const AliYunHost = @"http://oss-cn-shenzhen.aliyuncs.com/";

*/
@implementation AliOSSFileUploadUtil

/**
+ (void)asyncUploadData:(NSData *)data Type:(UploadDataType )type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names,UploadDataState state,NSArray<NSString *> *urls))complete{
    [self uploadDatas:@[data] isAsync:YES Type:type withVC:vc complete:complete];
}

+ (void)syncUploadData:(NSData *)data Type:(UploadDataType )type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names,UploadDataState state,NSArray<NSString *> *urls))complete{
    [self uploadDatas:@[data] isAsync:NO Type:type withVC:vc complete:complete];
}

+ (void)asyncUploadDatas:(NSArray<NSData *> *)datas Type:(UploadDataType )type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names, UploadDataState state,NSArray<NSString *> *urls))complete{
    [self uploadDatas:datas isAsync:YES Type:type withVC:vc complete:complete];
}


+ (void)syncUploadDatas:(NSArray<NSData *> *)datas Type:(UploadDataType )type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names, UploadDataState state ,NSArray<NSString *> *urls))complete{
    [self uploadDatas:datas isAsync:NO Type:type withVC:vc complete:complete];
}


+ (void)uploadDatas:(NSArray<NSData *> *)datas isAsync:(BOOL)isAsync Type:(UploadDataType)type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names, UploadDataState state,NSArray<NSString *> *urls))complete
{
    MBProgressHUD *hud;
   
    if (vc) {
        hud = [MBProgressHUD showHUDAddedTo:vc.view animated:TRUE];
        hud.bezelView.backgroundColor = [UIColor blackColor];
    }
    
    
    NSString *accessKey = @"LTAIaG4xRSysuIAp";
    NSString *secretKey = @"p5VT8YDKFxHmFNbEq8K0Hr1x9AkXY2";
    NSString *dir = @"";
    NSString *bucket = @"okyuyin";
#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:accessKey                                                                                                           secretKey:secretKey];
#pragma clang diagnostic pop
    
            OSSClient *client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            queue.maxConcurrentOperationCount = datas.count;
            
            NSMutableArray *callBackNames = [NSMutableArray array];
            int i = 0;
            for (NSData *data in datas) {
                if (data) {
                    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                        //任务执行
                        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                        put.bucketName = bucket;
                        NSString *imageName =@"";
                        if (type == UploadDataTypeImage){
                            imageName = [dir stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
                        }else if (type == UploadDataTypeImageGIF){
                            imageName = [dir stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".gif"]];
                        }else if (type == UploadDataTypeVideo){
                            imageName = [dir stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".mp4"]];
                        }else{
                            imageName = [dir stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".acc"]];
                        }
                        put.objectKey = imageName;
                        [callBackNames addObject:imageName];
                        
                        put.uploadingData = data;
                        
                        OSSTask * putTask = [client putObject:put];
                        [putTask waitUntilFinished]; // 阻塞直到上传完成
                        if (!putTask.error) {
                            NSLog(@"upload object success!");
                        } else {
                            NSLog(@"upload object failed, error: %@" , putTask.error);
                        }
                        if (isAsync) {
                            if (data == datas.lastObject) {
                                NSLog(@"upload object finished!");
                                if (complete) {
                                    if (vc) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [hud hideAnimated:TRUE];
                                        });
                                    }
                                    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:callBackNames.count];
                                    for (NSString *url in callBackNames) {
                                        if ( ![url containsString:@"http://"]) { //添加图片地址前缀
                                            NSString *newUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url];
                                            [urls addObject:newUrl];
                                        }
                                    }
                                    complete([NSArray arrayWithArray:callBackNames] ,UploadDataSuccess,urls);
                                }
                            }
                        }
                    }];
                    if (queue.operations.count != 0) {
                        [operation addDependency:queue.operations.lastObject];
                    }
                    [queue addOperation:operation];
                }
                i++;
            }
            if (!isAsync) {
                [queue waitUntilAllOperationsAreFinished];
                NSLog(@"haha");
                if (complete) {
                    if (complete) {
                        NSMutableArray *urls = [NSMutableArray arrayWithCapacity:callBackNames.count];
                        for (NSString *url in callBackNames) {
                            if ( ![url containsString:@"http://"]) { //添加图片地址前缀
                                NSString *newUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url];
                                [urls addObject:newUrl];
                            }
                        }
                        complete([NSArray arrayWithArray:callBackNames], UploadDataSuccess,urls);
                    }
                }
            }
}

*/
@end
