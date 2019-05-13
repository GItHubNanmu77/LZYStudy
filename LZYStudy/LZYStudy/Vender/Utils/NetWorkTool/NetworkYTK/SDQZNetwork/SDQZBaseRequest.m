//
//  SDQZBaseRequest.m
//  QingZhu
//
//  Created by xian yang on 2019/1/14.
//  Copyright © 2019年 xian yang. All rights reserved.
//

#import "SDQZBaseRequest.h"
//#import "SDQZAccessTokenUtils.h"

@implementation SDQZBaseRequest

#pragma mark - Public Methods
- (void)startWithCompletionHandlerWithSuccess:(nullable SDQZRequestSuccessBlock)success failure:(nullable SDQZRequestFailureBlock)failure {
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
#if defined(DEBUG)
        NSLog(@"✅✅✅✅✅请求数据：✅✅✅✅✅%@", request);
        NSLog(@"✅✅✅✅✅响应数据：✅✅✅✅✅%@", request.responseObject);
#endif
        
        NSInteger statsCode = [request.responseObject[@"code"] integerValue];
        if (statsCode == SDQZ_OK_STATSCODE) {
            if (success) {
                success(request,request.responseObject);
            }
        } else {
            if (1) {
//            if ((QZ_SHARE_DELEGATE).requestAccessTokenFailureCount > 5) {
//                (QZ_SHARE_DELEGATE).requestAccessTokenFailureCount = 0;
//                failure(request,statsCode,request.responseObject[@"msg"]);
            } else {
                if (statsCode == SDQZ_TOKEN_NOT_EXIST || statsCode == SDQZ_TOKEN_EXPIRE || statsCode == SDQZ_TOKEN_VALIDATION_FAILED) {
                    //[SVProgressHUD showWithStatus:@"测试使用：token失效"];
                    // token不存在、过期、验证失败时，重新获取token
//                    [[SDQZAccessTokenUtils shareInstance] updateAccessToken:^{
//                        // 刷新token后，继续上一次请求
//                        //[SVProgressHUD showSuccessWithStatus:@"测试使用：token更新成功，继续发起上一次请求"];
//                        (QZ_SHARE_DELEGATE).requestAccessTokenFailureCount = 0;
//                        [self startWithCompletionHandlerWithSuccess:success failure:failure];
//                    } failureHandler:^{
//                        //[SVProgressHUD showErrorWithStatus:@"测试使用：token更新失败"];
//                        if (failure) {
//                            (QZ_SHARE_DELEGATE).requestAccessTokenFailureCount++;
//                            failure(request,statsCode,request.responseObject[@"msg"]);
//                        }
//                    }];
                } else {
                    if (failure) {
                        failure(request,statsCode,request.responseObject[@"msg"]);
                    }
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
#if defined(DEBUG)
        NSLog(@"❌❌❌❌❌请求数据：❌❌❌❌❌%@", request);
        NSLog(@"❌❌❌❌❌响应数据：❌❌❌❌❌%@", request.responseObject);
#endif
        
        if (failure) {
            // 失败
            NSString *description = request.error.localizedDescription;
            description = [description stringByReplacingOccurrencesOfString:@"." withString:@""];
            description = [description stringByReplacingOccurrencesOfString:@"。" withString:@""];
            if ([description containsString:@"The Internet connection appears to be offline"]) {
//                description = SDQZ_NetworkConnectionLost;
            }
            if (request.error.localizedRecoverySuggestion) {
                NSData *errorData = [[NSData alloc] initWithData:[request.error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding]];
                NSDictionary *recoverySuggestion = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                if (recoverySuggestion) {
                    description = recoverySuggestion[@"msg"];
                }
            }
            failure(request,request.error.code,description);
        }
    }];
}

#pragma mark - Override Methods
- (NSString *)baseUrl {
    return @"";
//#if DISTRIBUTION
//    // 正式环境
//    return @"http://api-mobile.qingzhuyun.com/";
//#elif PRE
//    // 预生产环境
//    return @"http://api-mobile-pre.qingzhuyun.com/";
//#elif TEST
//    // 测试环境
//    return @"http://api-mobile-test.qingzhuyun.com/";
//#elif DEV
//    // 开发环境
//    return @"http://10.73.1.205:882/";
//#endif
}

- (NSTimeInterval)requestTimeoutInterval {
    return 20;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
//    NSString *acctessToken = [SDQZUserDefaultsUtils getUserDefaults:SDQZ_UserInfo_AccessToken defaultValue:nil];
    return @{@"Content-Type":@"application/json;charset=UTF-8",
//             @"access-token":acctessToken,
//             @"version":[SDQZDeviceUtils CFBundleShortVersionString],
             @"module-type":@"qz"
             };
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

- (NSString *)requestUrl {
    return self.requestAPIUrl;
}

- (id)requestArgument {
    return self.requestParamDict ?: nil;
}

@end
