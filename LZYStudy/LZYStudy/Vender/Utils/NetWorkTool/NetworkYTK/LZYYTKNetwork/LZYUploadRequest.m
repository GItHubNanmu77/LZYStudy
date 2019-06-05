//
//  LZYUploadRequest.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/5.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYUploadRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface LZYUploadRequest ()
/// 请求地址（不能为空）
@property (nonatomic, nonnull, strong) NSString *requestAPIUrl;

@property (nonatomic, copy) NSMutableArray<NSData *> *dataArray;
@end

@implementation LZYUploadRequest 

- (id)initUploadFileWithAPIURL:(NSString *)url fileData:(NSArray <NSData*>*)dataArray {
    self = [super init];
    if (self) {
        self.requestAPIUrl = url;
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    return self;
}

- (void)startWithCompletionHandlerWithProgress:(void(^)(NSProgress * progress))progressBlock success:(void(^)(NSString *filePath))success failure:(void(^)(NSError *error))failure {
    self.resumableDownloadProgressBlock = ^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(progress);
            }
        });
    };
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
#if defined(DEBUG)
        NSLog(@"✅✅✅✅✅请求数据：✅✅✅✅✅%@", request);
        NSLog(@"✅✅✅✅✅响应数据：✅✅✅✅✅%@", request.responseObject);
#endif
        if (success) {
            success(request.responseObject);
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
#if defined(DEBUG)
        NSLog(@"❌❌❌❌❌请求数据：❌❌❌❌❌%@", request);
        NSLog(@"❌❌❌❌❌响应数据：❌❌❌❌❌%@", request.responseObject);
#endif
        if (failure) {
            failure(request.error);
        }
    }];
}

#pragma mark - Override Methods
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

- (NSString *)baseUrl {
    return @"";
}

- (NSString *)requestUrl {
    return self.requestAPIUrl;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 20;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return @{@"Content-Type":@"application/json;charset=UTF-8",
             //             @"access-token":acctessToken,
             //             @"version":[SDQZDeviceUtils CFBundleShortVersionString],
             //@"module-type":@"qz"
             };
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        if (self.dataArray && self.dataArray.count > 0) {
            for (NSData *data in self.dataArray) {
                NSString *name = @"files";
                NSString *type = @"image/jpeg";
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss_SSS"];
                NSDate *currentDate = [NSDate date];
                NSString *defaultFileName = [dateFormatter stringFromDate:currentDate];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", defaultFileName];
                
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
            }
        }
    };
}

 


@end
