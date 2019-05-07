//
//  SDQZBaseRequest.h
//  QingZhu
//
//  Created by xian yang on 2019/1/14.
//  Copyright © 2019年 xian yang. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class SDQZBaseRequest;

/// 返回状态成功
#define SDQZ_OK_STATSCODE 10000000
/// token不存在
#define SDQZ_TOKEN_NOT_EXIST 10200301
/// token过期
#define SDQZ_TOKEN_EXPIRE 10200302
/// token验证失败
#define SDQZ_TOKEN_VALIDATION_FAILED 10200303

typedef void (^SDQZRequestSuccessBlock)(__kindof SDQZBaseRequest *request,id response);
typedef void (^SDQZRequestFailureBlock)(__kindof SDQZBaseRequest *request,NSInteger code, NSString *errorMsg);

@interface SDQZBaseRequest : YTKRequest

/// 请求地址（不能为空）
@property (nonatomic, nonnull, strong) NSString *requestAPIUrl;
/// 请求参数
@property (nonatomic, nullable, strong) NSDictionary *requestParamDict;

- (void)startWithCompletionHandlerWithSuccess:(nullable SDQZRequestSuccessBlock)success failure:(nullable SDQZRequestFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
