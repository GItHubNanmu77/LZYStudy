//
//  SDQZAccessTokenAPI.m
//  QingZhu
//
//  Created by xian yang on 2019/1/29.
//  Copyright © 2019年 xian yang. All rights reserved.
//

#import "SDQZAccessTokenAPI.h"

@implementation SDQZAccessTokenAPI

#pragma mark - 重写请求接口地址、请求参数方法
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

/**
 自定义请求头
 
 @return <#return value description#>
 */
- (NSDictionary *)requestHeaderFieldValueDictionary {
    return @{@"Content-Type":@"application/json;charset=UTF-8",
//             @"version":[SDQZDeviceUtils CFBundleShortVersionString],
             @"module-type":@"qz"
             };
}

#pragma mark - 接口
- (id)initGetAccessTokenAPI:(NSString *)userName password:(NSString *)password {
    self = [super init];
    if (self) {
        self.requestAPIUrl = @"api/client/token/getAccessToken";
        self.requestParamDict = @{@"userName": userName, @"password": password};
    }
    return self;
}

@end
