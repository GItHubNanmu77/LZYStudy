//
//  SDQZLoginPostAPI.m
//  QingZhu
//
//  Created by xian yang on 2019/1/14.
//  Copyright © 2019年 xian yang. All rights reserved.
//

#import "SDQZLoginPostAPI.h"
//#import "SDQZEncryptUtils.h"

@implementation SDQZLoginPostAPI

#pragma mark - 重写请求接口地址、请求参数方法
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
- (id)initRegisterValidateCodeAPI:(NSString *)phone {
    self = [super init];
    if (self) {
        self.requestAPIUrl = @"api/client/register/validateCode";
        self.requestParamDict = @{@"phone":phone};
    }
    return self;
}

- (id)initRegisterAPI:(NSString *)nickName userName:(NSString *)userName password:(NSString *)password confirmPwd:(NSString *)confirmPwd validateCode:(NSString *) validateCode sex:(NSString *)sex {
    self = [super init];
    if (self) {
//        NSString *passwordMD5 = [SDQZEncryptUtils MD5:password];
//        NSString *confirmPwdMD5 = [SDQZEncryptUtils MD5:confirmPwd];
//        self.requestAPIUrl = @"api/client/register";
//        self.requestParamDict = @{@"nickName": nickName, @"userName": userName, @"password": passwordMD5,
//                                  @"confirmPwd": confirmPwdMD5, @"validateCode": validateCode, @"sex": sex
//                                  };
    }
    return self;
}

- (id)initLoginAPI:(NSString *)userName password:(NSString *)password {
    self = [super init];
    if (self) {
//        NSString *passwordMD5 = [SDQZEncryptUtils MD5:password];
//        self.requestAPIUrl = @"api/client/login";
//        self.requestParamDict = @{@"userName": userName, @"password": passwordMD5, @"clientType": @"iOS"};
    }
    return self;
}

- (id)initChangePwdValidateCodeAPI:(NSString *)phone {
    self = [super init];
    if (self) {
        self.requestAPIUrl = @"api/client/user/setting/changePwd/validateCode";
        self.requestParamDict = @{@"phone": phone};
    }
    return self;
}

- (id)initLogoutAPI {
    self = [super init];
    if (self) {
//        NSString *accessToken = [SDQZUserDefaultsUtils getUserDefaults:SDQZ_UserInfo_AccessToken defaultValue:@""];
        //NSString *qtAccesssToken = [SDQZUserDefaultsUtils getUserDefaults:SDQZ_UserInfo_QTAccessToken defaultValue:@""];
        self.requestAPIUrl = @"api/client/user/setting/logout";
        //self.requestParamDict = @{@"access-token": accessToken, @"qtAccessToken": qtAccesssToken};
//        self.requestParamDict = @{@"access-token": accessToken};
    }
    return self;
}

- (id)initFindPwdAPI:(NSString *)userName validateCode:(NSString *)validateCode newPwd:(NSString *)newPwd confirmPwd:(NSString *)confirmPwd {
    self = [super init];
    if (self) {
//        NSString *passwordMD5 = [SDQZEncryptUtils MD5:newPwd];
//        NSString *confirmPwdMD5 = [SDQZEncryptUtils MD5:confirmPwd];
//        self.requestAPIUrl = @"api/client/findPwd";
//        self.requestParamDict = @{@"userName": userName, @"validateCode": validateCode, @"newPwd": passwordMD5, @"confirmPwd": confirmPwdMD5};
    }
    return self;
}

- (id)initFindPwdValidateCodeAPI:(NSString *)phone {
    self = [super init];
    if (self) {
        self.requestAPIUrl = @"api/client/findPwd/validateCode";
        self.requestParamDict = @{@"phone": phone};
    }
    return self;
}

@end
