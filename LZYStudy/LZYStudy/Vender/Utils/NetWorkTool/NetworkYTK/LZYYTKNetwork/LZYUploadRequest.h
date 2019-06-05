//
//  LZYUploadRequest.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/5.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "YTKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZYUploadRequest : YTKBaseRequest

/**
 上传图片

 @param url 上传接口
 @param dataArray 图片data 数组
 */
- (id)initUploadFileWithAPIURL:(NSString *)url fileData:(NSArray <NSData*>*)dataArray;

- (void)startWithCompletionHandlerWithProgress:(void(^)(NSProgress * progress))progressBlock success:(void(^)(NSString *filePath))success failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
