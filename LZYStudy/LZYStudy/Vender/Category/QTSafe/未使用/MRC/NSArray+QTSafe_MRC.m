//
//  NSArray+QTSafe_MRC.m
//  QTCategory
//
//  Created by 张俊博 on 2017/11/10.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSArray+QTSafe_MRC.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSArray (QTSafe_MRC)

+ (void)load {
    //#if !DEBUG
        //__NSArrayI
        [self swizzleInstanceMethod:@selector(__NSArray_objectAtIndex:)
                           tarClass:NSClassFromString(@"__NSArrayI")
                             tarSel:@selector(objectAtIndex:)];
        
        //__NSArray0
        [self swizzleInstanceMethod:@selector(__NSArray0_objectAtIndex:)
                           tarClass:NSClassFromString(@"__NSArray0")
                             tarSel:@selector(objectAtIndex:)];
        
        
        //__NSSingleObjectArrayI
        [self swizzleInstanceMethod:@selector(__NSSingleObjectArrayI_objectAtIndex:)
                           tarClass:NSClassFromString(@"__NSSingleObjectArrayI")
                             tarSel:@selector(objectAtIndex:)];
    //#endif
}

#pragma mark -- __NSArrayI

- (id)__NSArray_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    
    id objc = nil;
    
    @try {
        objc = [self __NSArray_objectAtIndex:index];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return objc;
    }
}

#pragma mark -- __NSArray0
- (id)__NSArray0_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    
    id objc = nil;
    
    @try {
        objc = [self __NSArray0_objectAtIndex:index];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return objc;
    }
}

#pragma mark __NSSingleObjectArrayI
- (id)__NSSingleObjectArrayI_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    id objc = nil;
    
    @try {
        objc = [self __NSSingleObjectArrayI_objectAtIndex:index];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return objc;
    }
}

@end
