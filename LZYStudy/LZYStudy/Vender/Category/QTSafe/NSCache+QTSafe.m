//
//  NSCache+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2018/8/20.
//

#import "NSCache+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSCache (QTSafe)

+ (void) load {
    //#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleInstanceMethod:@selector(safe_setObject:forKey:)
                           tarClass:self.class
                             tarSel:@selector(setObject:forKey:)];
        [self swizzleInstanceMethod:@selector(safe_setObject:forKey:cost:)
                           tarClass:self.class
                             tarSel:@selector(setObject:forKey:cost:)];
        [self swizzleInstanceMethod:@selector(safe_removeObjectForKey:)
                           tarClass:self.class
                             tarSel:@selector(removeObjectForKey:)];
        
//        [self test];
    });
    //#endif
}

- (void)safe_setObject:(id)obj forKey:(id)key {
    if (!obj || !key) {
        return;
    }
    
    @try {
        [self safe_setObject:obj forKey:key];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)safe_setObject:(id)obj forKey:(id)key cost:(NSUInteger)g {
    if (!obj || !key) {
        return;
    }
    
    @try {
        [self safe_setObject:obj forKey:key cost:g];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)safe_removeObjectForKey:(id)key {
    if (!key) {
        return;
    }
    
    @try {
        [self safe_removeObjectForKey:key];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

#pragma mark - Debug

+ (void)test {
    id value = nil;
    id key = @"1";
    NSCache *cache = [[NSCache alloc] init];
    
    [cache setObject:value forKey:key];
    [cache setObject:value forKey:key cost:1];
    [cache removeObjectForKey:key];
}

@end
