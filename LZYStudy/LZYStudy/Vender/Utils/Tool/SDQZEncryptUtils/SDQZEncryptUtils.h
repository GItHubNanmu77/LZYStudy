//
//  SDQZEncryptUtils.h
//  QingZhu
//
//  Created by xian yang on 2019/1/23.
//  Copyright © 2019年 xian yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDQZEncryptUtils : NSObject

/**
 *  MD5 加密
 *
 *  @param plainText <#plainText description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)MD5:(NSString *)plainText;

/**
 *  DES 加密
 *
 *  @param plainText <#plainText description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)DESEncode:(NSString *)plainText;

/**
 *  DES 解密
 *
 *  @param plainText <#plainText description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)DESDecode:(NSString *)plainText;

@end

NS_ASSUME_NONNULL_END
