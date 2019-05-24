//
//  NSNumber+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/9.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSNumber+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSNumber (QTSafe)

+ (void)load {
//#if !DEBUG
        [self swizzleInstanceMethod:@selector(safe_isEqualToNumber:)
                           tarClass:NSClassFromString(@"__NSCFNumber")
                             tarSel:@selector(isEqualToNumber:)];
        [self swizzleInstanceMethod:@selector(safe_compare:)
                           tarClass:NSClassFromString(@"__NSCFNumber")
                             tarSel:@selector(compare:)];
//#endif
}

- (BOOL)safe_isEqualToNumber:(NSNumber *)number {
    if (nil==number) {
        return NO;
    }
    
    BOOL result = NO;
    @try {
        result = [self safe_isEqualToNumber:number];
        
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
    } @finally {
        return result;
    }
}

- (NSComparisonResult)safe_compare:(NSNumber *)number {
    if (nil==number) {
        return NSOrderedAscending;
    }
    
    NSComparisonResult result = NSOrderedAscending;
    @try {
        result = [self safe_compare:number];
        
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
    } @finally {
        return result;
    }
}



@end
