//
//  NSString+Convert.h
//  LZYStudy
//
//  Created by cisdi on 2019/8/9.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Convert)
/// data转16进制
+ (NSString *)convertDataToHexStr:(NSData *)data;

//十六进制转换为普通字符串的。
+ (NSString *)ConvertHexStringToString:(NSString *)hexString;
/// 十进制转二进制
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;

/// 十六进制转换十进制
+ (NSInteger)getDecimalByHex:(NSString *)hex;

/// 十六进制转换为二进制
+ (NSString *)getBinaryByHex:(NSString *)hex;

/// 二进制转换为十进制
+ (NSInteger)getDecimalByBinary:(NSString *)binary;
@end

NS_ASSUME_NONNULL_END
