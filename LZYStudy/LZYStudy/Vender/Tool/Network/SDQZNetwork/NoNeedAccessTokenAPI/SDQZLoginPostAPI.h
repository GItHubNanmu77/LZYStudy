//
//  SDQZLoginPostAPI.h
//  QingZhu
//
//  Created by xian yang on 2019/1/14.
//  Copyright © 2019年 xian yang. All rights reserved.
//

#import "SDQZBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 登录&注册相关接口
 */
@interface SDQZLoginPostAPI : SDQZBaseRequest

/**
 注册时发送验证码

 @param phone 手机号
 @return <#return value description#>
 */
- (id)initRegisterValidateCodeAPI:(NSString *)phone;

/**
 新用户注册

 @param nickName 昵称
 @param userName 用户名(手机号)
 @param password 密码(MD5加密)
 @param confirmPwd 确认密码(MD5加密)
 @param validateCode 短信验证码
 @param sex 性别（"0":男， "1"：女）
 @return <#return value description#>
 */
- (id)initRegisterAPI:(NSString *)nickName userName:(NSString *)userName password:(NSString *)password confirmPwd:(NSString *)confirmPwd validateCode:(NSString *) validateCode sex:(NSString *)sex;

/**
 登录

 @param userName 用户名(手机号)
 @param password 密码(MD5加密)
 @return <#return value description#>
 */
- (id)initLoginAPI:(NSString *)userName password:(NSString *)password;

/**
 修改密码时获取短信验证码

 @param phone 手机号
 @return <#return value description#>
 */
- (id)initChangePwdValidateCodeAPI:(NSString *)phone;

/**
 客户端注销登录

 @return <#return value description#>
 */
- (id)initLogoutAPI;

/**
 忘记密码后找回密码接口

 @param userName 用户名（手机号）
 @param validateCode 短信验证码
 @param newPwd 新密码（MD5加密）
 @param confirmPwd 确认新密码（MD5加密）
 @return <#return value description#>
 */
- (id)initFindPwdAPI:(NSString *)userName validateCode:(NSString *)validateCode newPwd:(NSString *)newPwd confirmPwd:(NSString *)confirmPwd;

/**
 忘记（找回）密码时发送验证码

 @param phone 手机号
 @return <#return value description#>
 */
- (id)initFindPwdValidateCodeAPI:(NSString *)phone;

@end

NS_ASSUME_NONNULL_END
