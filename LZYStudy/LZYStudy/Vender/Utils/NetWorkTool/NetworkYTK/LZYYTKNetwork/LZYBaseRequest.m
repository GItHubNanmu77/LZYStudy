//
//  LZYBaseRequest.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/8.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYBaseRequest.h"

@implementation LZYBaseRequest
- (void)startWithCompletionHandlerWithSuccess:(LZYRequestSuccessBlock)success failure:(LZYRequestFailureBlock)failure {
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
#if defined(DEBUG)
        NSLog(@"✅✅✅✅✅请求数据：✅✅✅✅✅%@", request);
        NSLog(@"✅✅✅✅✅响应数据：✅✅✅✅✅%@", request.responseObject);
#endif
        NSInteger statsCode = [request.responseObject[@"code"] integerValue];
        if (statsCode == LL_SUCCESS_STATSCODE) {
            if (success) {
                success(request,request.responseObject);
            }
        } else {
            if (failure) {
                failure(request,statsCode,request.responseObject[@"msg"]);
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
#if defined(DEBUG)
        NSLog(@"❌❌❌❌❌请求数据：❌❌❌❌❌%@", request);
        NSLog(@"❌❌❌❌❌响应数据：❌❌❌❌❌%@", request.responseObject);
#endif
        
        NSInteger statsCode = [request.responseObject[@"code"] integerValue];
        if (failure) {
            NSString *description = request.error.localizedDescription;
            description = [description stringByReplacingOccurrencesOfString:@"." withString:@""];
            description = [description stringByReplacingOccurrencesOfString:@"。" withString:@""];
            if ([description containsString:@"The Internet connection appears to be offline"]) {
                description = @"网络链接已断开";
            }
            if (request.error.localizedRecoverySuggestion) {
                NSData *errorData = [[NSData alloc] initWithData:[request.error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding]];
                NSDictionary *recoverySuggestion = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                if (recoverySuggestion) {
                    description = recoverySuggestion[@"msg"];
                }
            }

            failure(request,statsCode,request.responseObject[@"msg"]);
        }

    }];
}

#pragma mark - Override Methods

- (NSString *)baseUrl {
    return @"";
}
- (NSTimeInterval)requestTimeoutInterval {
    return 20;
}
- (NSDictionary *)requestHeaderFieldValueDictionary {
    //    NSString *acctessToken = [SDQZUserDefaultsUtils getUserDefaults:SDQZ_UserInfo_AccessToken defaultValue:nil];
    return @{@"Content-Type":@"application/json;charset=UTF-8",
             //             @"access-token":acctessToken,
             //             @"version":[SDQZDeviceUtils CFBundleShortVersionString],
             //@"module-type":@"qz"
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
