//
//  NSMutableDictionary+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/9.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSMutableDictionary+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSMutableDictionary (QTSafe)

+ (void) load {
//#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(safe_removeObjectForKey:)
                           tarClass:NSClassFromString(@"__NSDictionaryM")
                             tarSel:@selector(removeObjectForKey:)];
        [self swizzleInstanceMethod:@selector(safe_setObject:forKey:)
                           tarClass:NSClassFromString(@"__NSDictionaryM")
                             tarSel:@selector(setObject:forKey:)];
        [self swizzleInstanceMethod:@selector(safe_setObject:forKeyedSubscript:)
                           tarClass:NSClassFromString(@"__NSDictionaryM")
                             tarSel:@selector(setObject:forKeyedSubscript:)];
        
//        [NSMutableDictionary test];
    });
//#endif
}

- (void)safe_removeObjectForKey:(id)aKey {
    if (!aKey) {
        return;
    }
    @try {
        [self safe_removeObjectForKey:aKey];
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (void)safe_setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    
    if (!anObject || !aKey) {
        return;
    }
    
    @try {
        
        [self safe_setObject:anObject forKey:aKey];
        
    } @catch (NSException *exception) {
        //打印出异常数据
        
        [NSObject printExceptionReason:exception];
        
    } @finally {
        
    }
}

- (void)safe_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!obj || !key) {
        return;
    }
    
    @try {
        
        [self safe_setObject:obj forKeyedSubscript:key];
        
    } @catch (NSException *exception) {
        //打印出异常数据
        
        [NSObject printExceptionReason:exception];
        
    } @finally {
        
    }
}

#pragma mark - Debug

//+ (void)test {
//   NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"valu0", @"key0", @"valu1", @"key1", nil];
//    id key = nil;
//    [dictionary removeObjectForKey:key];
//    id value = nil;
//    [dictionary setObject:value forKey:key];
//    dictionary[key] = value;
//}

@end
