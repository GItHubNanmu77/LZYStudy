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
@end
