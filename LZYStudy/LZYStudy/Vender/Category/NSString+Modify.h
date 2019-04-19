//
//  NSString+Modify.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/19.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Modify)

/**
 去除空格
 
 @return <#return value description#>
 */
- (NSString *)stringByTrim;

/**
 * 判断对象是否为空
 
 @param object 输入判断对象
 @return 返回对象是否为空
 */
BOOL is_null(id object);

/**
 * 判断字符是否为空
 
 @param string 输入字符
 @return 返回字符是否为空
 */
+(BOOL)is_nullString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
