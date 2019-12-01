//
//  NSString+Convert.m
//  LZYStudy
//
//  Created by cisdi on 2019/8/9.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "NSString+Convert.h"

@implementation NSString (Convert)
// datab转16进制
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

//十六进制转换为普通字符串的。
+ (NSString *)ConvertHexStringToString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    //    BabyLog(@"===字符串===%@",unicodeString);
    return unicodeString;
}

/**
 无符号长整型转C字符串
 
 @param num 无符号长整型
 @param base 进制 2~36
 @return C字符串
 */
char *ultostr(unsigned long num, unsigned base) {
    static char string[64] = {'\0'};
    size_t max_chars = 64;
    char remainder;
    int sign = 0;
    if (base < 2 || base > 36) {
        return NULL;
    }
    for (max_chars --; max_chars > sign && num != 0; max_chars --) {
        remainder = (char)(num % base);
        if ( remainder <= 9 ) {
            string[max_chars] = remainder + '0';
        } else {
            string[max_chars] = remainder - 10 + 'A';
        }
        num /= base;
    }
    if (max_chars > 0) {
        memset(string, '\0', max_chars + 1);
    }
    return string + max_chars + 1;
}

/// 十进制转二进制
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    char *hexChar = ultostr(decimal, 2);
    NSString *binary = [NSString stringWithUTF8String:hexChar];
    return binary;
}

/// 二进制转换为十进制
+ (NSInteger)getDecimalByBinary:(NSString *)binary {
    char *endptr = "";
    NSInteger decimal = strtoul([binary UTF8String], &endptr, 2);
    if (strlen(endptr)) {
        return 0;
    }
    return decimal;
}
/// 十六进制转换十进制
+ (NSInteger)getDecimalByHex:(NSString *)hex {
    char *endptr = "";
    NSInteger decimal = strtoul([hex UTF8String], &endptr, 16);
    if (strlen(endptr)) {
        return 0;
    }
    return decimal;
}

/// 十进制转换十六进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    char *hexChar = ultostr(decimal, 16);
    NSString *hex = [NSString stringWithUTF8String:hexChar];
    return hex;
}

/// 十六进制转换为二进制
+ (NSString *)getBinaryByHex:(NSString *)hex {
    // 十进制
    NSInteger decimal = [self getDecimalByHex:hex];
    // 二进制字符串
    NSString *binary = [self getBinaryByDecimal:decimal];
    return binary;
}

@end
