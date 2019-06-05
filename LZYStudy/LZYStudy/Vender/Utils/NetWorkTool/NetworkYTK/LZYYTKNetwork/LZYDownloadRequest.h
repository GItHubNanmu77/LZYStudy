//
//  LZYDownloadRequest.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/5.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZYDownloadRequest : YTKRequest

/**
 下载文件

 @param url 下载文件路径
 @param fileName 文件名称，默认是当前时间
 @param fileDir 文件路径，默认是cash 下 Download 文件夹下
 */
- (id)initDownloadFileWithAPIURL:(NSString *)url fileName:(NSString *)fileName fileDir:(NSString *)fileDir;

- (void)startWithCompletionHandlerWithProgress:(void(^)(NSProgress * progress))progressBlock success:(void(^)(NSString *filePath))success failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
