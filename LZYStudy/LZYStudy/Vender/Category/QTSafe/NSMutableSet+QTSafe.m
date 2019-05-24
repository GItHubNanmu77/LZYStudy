//
//  NSMutableSet+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/10/23.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSMutableSet+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSMutableSet (QTSafe)

+ (void)load {
        [self swizzleInstanceMethod:@selector(addObject:)
                               with:@selector(safe_addObject:)];
        [self swizzleInstanceMethod:@selector(removeObject:)
                               with:@selector(safe_removeObject:)];
        
        [self swizzleInstanceMethod:@selector(__NSSetM_addObject:)
                           tarClass:NSClassFromString(@"__NSSetM")
                             tarSel:@selector(addObject:)];
        [self swizzleInstanceMethod:@selector(__NSSetM_removeObject:)
                           tarClass:NSClassFromString(@"__NSSetM")
                             tarSel:@selector(removeObject:)];
        
        [self swizzleInstanceMethod:@selector(__NSCFSet_addObject:)
                           tarClass:NSClassFromString(@"__NSCFSet")
                             tarSel:@selector(addObject:)];
        [self swizzleInstanceMethod:@selector(__NSCFSet_removeObject:)
                           tarClass:NSClassFromString(@"__NSCFSet")
                             tarSel:@selector(removeObject:)];
        
        [self swizzleInstanceMethod:@selector(initWithObjects_safe:count:)
                           tarClass:NSClassFromString(@"__NSPlaceholderSet")
                             tarSel:@selector(initWithObjects:count:)];
}

- (void)safe_addObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self safe_addObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)safe_removeObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self safe_removeObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)__NSSetM_addObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self __NSSetM_addObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)__NSSetM_removeObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self __NSSetM_removeObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)__NSCFSet_addObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self __NSCFSet_addObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)__NSCFSet_removeObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self __NSCFSet_removeObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (instancetype)initWithObjects_safe:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    
    //    if (objects && !objects[0]) {
    //        id _Nonnull __unsafe_unretained newObjects[0];
    //        self = [self initWithObjects_safe:newObjects count:0];
    //        return self;
    //    }
    
    @try {
        self = [self initWithObjects_safe:objects count:cnt];
        
    } @catch (NSException *exception) {
        
        [NSObject printExceptionReason:exception];
        
        //去掉nil，然后初始化数组
        NSInteger newObjcIndex = 0;
        
        //创建一个C语言类型的数组
        id _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i=0; i<cnt; i++) {
            
            if (objects[i] != nil) {
                newObjects[newObjcIndex] = objects[i];
                newObjcIndex++;
            }
        }
        
        self = [self initWithObjects_safe:newObjects count:newObjcIndex];
    } @finally {
        return self;
    }
    
}

#pragma mark - Debug

//+ (void)test {
//    id value = nil;
//    NSMutableSet *test = [NSMutableSet set];
//    [test addObject:value];
//    [test removeObject:value];
//    
//    NSMutableSet *test1 = [NSMutableSet setWithObjects:@"1", nil];
//    [test1 addObject:value];
//    [test1 removeObject:value];
//    
//    NSMutableSet *test2 = [NSMutableSet setWithObjects:@"1",@"2", nil];
//    [test2 addObject:value];
//    [test2 removeObject:value];
//}

@end
