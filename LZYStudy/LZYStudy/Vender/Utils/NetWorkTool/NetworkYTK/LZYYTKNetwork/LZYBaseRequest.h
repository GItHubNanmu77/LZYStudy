//
//  LZYBaseRequest.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/8.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class LZYBaseRequest;

/// 返回状态成功
#define LL_SUCCESS_STATSCODE 200
/// token不存在
#define LL_TOKEN_NOT_EXIST 202

typedef void (^LZYRequestSuccessBlock)(__kindof LZYBaseRequest *request, id response);
typedef void (^LZYRequestFailureBlock)(__kindof LZYBaseRequest *request, NSInteger code, NSString *errorMsg);


@interface LZYBaseRequest : YTKRequest

/// 请求地址（不能为空）
@property (nonatomic, nonnull, strong) NSString *requestAPIUrl;
/// 请求参数
@property (nonatomic, nullable, strong) NSDictionary *requestParamDict;

- (void)startWithCompletionHandlerWithSuccess:(nullable LZYRequestSuccessBlock)success failure:(nullable LZYRequestFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
