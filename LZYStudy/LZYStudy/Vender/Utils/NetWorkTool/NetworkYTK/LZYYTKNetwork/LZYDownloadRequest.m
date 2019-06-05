//
//  LZYDownloadRequest.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/5.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYDownloadRequest.h"

@interface LZYDownloadRequest ()
/// 请求地址（不能为空）
@property (nonatomic, nonnull, strong) NSString *requestAPIUrl;
/// 文件名称,(为空用当前时间做名称)
@property (nonatomic, nullable, strong) NSString *fileName;
/// 文件存储地址，默认为download
@property (nonatomic, nullable, strong) NSString *fileDir;

@end

@implementation LZYDownloadRequest

- (id)initDownloadFileWithAPIURL:(NSString *)url fileName:(NSString *)fileName fileDir:(NSString *)fileDir {
    self = [super init];
    if (self) {
        self.requestAPIUrl = url;
        if (self.fileName && self.fileName.length > 0) {
             self.fileName = fileName;
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss_SSS"];
            NSDate *currentDate = [NSDate date];
            NSString *defaultFileName = [dateFormatter stringFromDate:currentDate];
            self.fileName = defaultFileName;
        }
        if (self.fileDir && self.fileDir.length > 0) {
            self.fileDir = self.fileDir;
        } else {
            self.fileDir = @"Download";
        }
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

- (BOOL)useCDN {
    return YES;
}

- (NSString *)resumableDownloadPath {
    //拼接缓存目录
    NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self.fileDir];
    //打开文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建Download目录
    [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
    //拼接文件路径
    NSString *filePath = [downloadDir stringByAppendingPathComponent:self.fileName];
    //返回文件位置的URL路径
    return filePath;
}
@end
