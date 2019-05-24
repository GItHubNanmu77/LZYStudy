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
 *
 * @param string 输入字符
 * @return 返回字符是否为空
 */
+(BOOL)is_nullString:(NSString *)string;

/**
 *  根据文本内容计算size
 *
 *  @param font <#font description#>
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  获取文件类型
 *
 *  @return return value description
 */
- (NSString *)getFileType;

/**
 *  中英文混合字符串长度
 *
 *  @return 字符串长度
 */
- (NSInteger)getStringToInt;

/**
 *  中英文混合字符串截取
 *
 *  @param maxLength 最大长度
 *
 *  @return <#return value description#>
 */
- (NSString *)substringToMaxLength:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
