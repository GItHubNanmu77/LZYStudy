//
//  SDQZAccessTokenAPI.h
//  QingZhu
//
//  Created by xian yang on 2019/1/29.
//  Copyright © 2019年 xian yang. All rights reserved.
//

#import "SDQZBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Token相关接口
 */
@interface SDQZAccessTokenAPI : SDQZBaseRequest

/**
 获取凭证

 @param userName 用户名
 @param password 密码（MD5加密）
 @return <#return value description#>
 */
- (id)initGetAccessTokenAPI:(NSString *)userName password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
