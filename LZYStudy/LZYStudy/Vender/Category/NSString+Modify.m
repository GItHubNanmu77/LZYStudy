//
//  NSString+Modify.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/19.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "NSString+Modify.h"

@implementation NSString (Modify)
/**
 去除空格
 
 @return <#return value description#>
 */
- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

/**
 * 判断对象是否为空
 
 @param object 输入判断对象
 @return 返回对象是否为空
 */

BOOL is_null(id object) {
    return (nil == object || [@"" isEqual:object] || [object isKindOfClass:[NSNull class]]);
}

+ (BOOL)is_nullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/**
 *  根据文本内容计算size
 *
 *  @param font <#font description#>
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName: font } context:nil].size;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        
#endif
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

/**
 *  获取文件类型
 *
 *  @return return value description
 */
- (NSString *)getFileType {
    NSString *fileType;
    NSString *lowercaseFileName = [self lowercaseString];
    if ([lowercaseFileName hasSuffix:@"xls"] || [lowercaseFileName hasSuffix:@"xlsx"] || [lowercaseFileName hasSuffix:@"numbers"]) {
        fileType = @"Excel";
    } else if ([lowercaseFileName hasSuffix:@"doc"] || [lowercaseFileName hasSuffix:@"docx"] || [lowercaseFileName hasSuffix:@"key"]) {
        fileType = @"Word";
    } else if ([lowercaseFileName hasSuffix:@"ppt"] || [lowercaseFileName hasSuffix:@"pptx"] || [lowercaseFileName hasSuffix:@"pages"]) {
        fileType = @"Ppt";
    } else if ([lowercaseFileName hasSuffix:@"jpg"] || [lowercaseFileName hasSuffix:@"tiff"] || [lowercaseFileName hasSuffix:@"gif"]) {
        fileType = @"Jpg";
    } else if ([lowercaseFileName hasSuffix:@"m4v"] || [lowercaseFileName hasSuffix:@"mp4"] || [lowercaseFileName hasSuffix:@"mov"] || [lowercaseFileName hasSuffix:@"avi"]) {
        fileType = @"Mp4";
    } else if ([lowercaseFileName hasSuffix:@"pdf"]) {
        fileType = @"Pdf";
    } else {
        fileType = @"Else";
    }
    return fileType;
}

/**
 *  中英文混合字符串长度
 *
 *  @return 字符串长度
 */
- (NSInteger)getStringToInt {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *da = [self dataUsingEncoding:enc];
    return [da length];
}

/**
 *  中英文混合字符串截取
 *
 *  @param maxLength 最大长度
 *
 *  @return <#return value description#>
 */
- (NSString *)substringToMaxLength:(NSUInteger)maxLength {
    NSString *returnStr = self;
    NSUInteger lll = self.length;
    
    for (NSInteger i = 0; i < lll; i++) {
        NSString *fromString = [self substringToIndex:i];
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *da = [fromString dataUsingEncoding:enc];
        NSInteger fromDataLength = da.length;
        
        if (fromDataLength == maxLength) {
            returnStr = fromString;
            break;
        }
    }
    
    return returnStr;
}

@end
