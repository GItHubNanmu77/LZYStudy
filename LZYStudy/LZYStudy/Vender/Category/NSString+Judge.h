//
//  NSString+Judge.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Judge)
/**
 * 是否是邮箱组合
 */
- (BOOL)isEmail;
/**
 * 判断是否由字母、数字或汉字组合名称
 */
- (BOOL)validateUserName;
/**
 * 判断是否至少包含数字、普通字符、大小写字母4类中的2类且长度6-50长度
 */
- (BOOL)validatePassword;
/**
 * 判断是否包含Emoji
 */
- (BOOL)containEmoji;
/**
 * 判断是否是网址链接
 */
- (BOOL)isURL;
@end

NS_ASSUME_NONNULL_END
