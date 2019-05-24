//
//  NSURL+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/11/29.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSURL+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSURL (QTSafe)

+ (void)load {
        [self swizzleInstanceMethod:@selector(initWithScheme:host:path:)
                               with:@selector(initWithScheme_safe:host:path:)];
        [self swizzleInstanceMethod:@selector(initFileURLWithPath:isDirectory:relativeToURL:)
                               with:@selector(initFileURLWithPath_safe:isDirectory:relativeToURL:)];
        [self swizzleInstanceMethod:@selector(initFileURLWithPath:relativeToURL:)
                               with:@selector(initFileURLWithPath_safe:relativeToURL:)];
        [self swizzleInstanceMethod:@selector(initFileURLWithPath:isDirectory:)
                               with:@selector(initFileURLWithPath_safe:isDirectory:)];
        [self swizzleInstanceMethod:@selector(initFileURLWithPath:)
                               with:@selector(initFileURLWithPath_safe:)];
}

- (instancetype)initWithScheme_safe:(NSString *)scheme host:(NSString *)host path:(NSString *)path {
    @try {
        self = [self initWithScheme_safe:scheme host:host path:path];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return self;
    }
}

- (instancetype)initFileURLWithPath_safe:(NSString *)path isDirectory:(BOOL)isDir relativeToURL:(NSURL *)baseURL {
    @try {
        self = [self initFileURLWithPath_safe:path isDirectory:isDir relativeToURL:baseURL];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return self;
    }
}

- (instancetype)initFileURLWithPath_safe:(NSString *)path relativeToURL:(NSURL *)baseURL {
    @try {
        self = [self initFileURLWithPath_safe:path relativeToURL:baseURL];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return self;
    }
}

- (instancetype)initFileURLWithPath_safe:(NSString *)path isDirectory:(BOOL)isDir {
    @try {
        self = [self initFileURLWithPath_safe:path isDirectory:isDir];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return self;
    }
}

- (instancetype)initFileURLWithPath_safe:(NSString *)path {
    @try {
        self = [self initFileURLWithPath_safe:path];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return self;
    }
}

#pragma mark - Debug

//+ (void)test {
//    id value = nil;
//
//    NSURL *t = [[NSURL alloc] initWithScheme:value host:value path:value];
//    t = [[NSURL alloc] initFileURLWithPath:value isDirectory:YES relativeToURL:value];
//    t = [[NSURL alloc] initFileURLWithPath:value relativeToURL:value];
//    t = [[NSURL alloc] initFileURLWithPath:value isDirectory:YES];
//    t = [[NSURL alloc] initFileURLWithPath:value];
//    t = [NSURL fileURLWithPath:value isDirectory:YES relativeToURL:value];
//    t = [NSURL fileURLWithPath:value relativeToURL:value];
//    t = [NSURL fileURLWithPath:value isDirectory:YES];
//    t = [NSURL fileURLWithPath:value];
//
//}

@end
