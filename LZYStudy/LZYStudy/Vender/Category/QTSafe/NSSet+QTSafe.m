//
//  NSSet+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/10/23.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSSet+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSSet (QTSafe)

+ (void)load {
        [self swizzleClassMethod:@selector(setWithObject:) with:@selector(safe_setWithObject:)];
}

+ (instancetype)safe_setWithObject:(id)object
{
    id instance = nil;
    @try {
        instance = [self safe_setWithObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return instance;
    }
}

#pragma mark - Debug

//+ (void)test {
//    id value = nil;
//    [NSSet set];
//    [NSSet setWithObject:@"1"];
//    [NSSet setWithArray:@[@"1"]];
//    [NSSet setWithObjects:@"1",@"2",  nil];
//    [NSSet setWithSet:value];
//    [NSSet setWithArray:value];
//
//    [NSSet setWithObject:value];
//}

@end
