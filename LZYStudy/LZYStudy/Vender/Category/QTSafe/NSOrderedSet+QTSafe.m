//
//  NSOrderedSet+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/10/23.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSOrderedSet+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSOrderedSet (QTSafe)

+ (void)load {
        [self swizzleClassMethod:@selector(orderedSetWithObject:)
                            with:@selector(safe_orderedSetWithObject:)];
        [self swizzleInstanceMethod:@selector(initWithObject:)
                               with:@selector(initWithObject_safe:)];
}

+ (instancetype)safe_orderedSetWithObject:(id)object {
    id instance = nil;
    @try {
        instance = [self safe_orderedSetWithObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return instance;
    }
}

- (instancetype)initWithObject_safe:(id)object {
    @try {
        self = [self initWithObject_safe:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        self = [NSOrderedSet orderedSet];
    } @finally {
        return self;
    }
}

#pragma mark - Debug

//+ (void)test {
//    id value = nil;
//    [NSOrderedSet orderedSetWithObject:value];
////    [[NSOrderedSet alloc] initWithObject:value];
//    
//    NSOrderedSet *test = [NSOrderedSet orderedSet];
//    [test objectAtIndex:1];
//    
//    test = [NSOrderedSet orderedSetWithObject:@"1"];
//    [test objectAtIndex:10];
//    
//    test = [NSOrderedSet orderedSetWithObjects:@"1", @"2", nil];
//    [test objectAtIndex:10];
//    
//}

@end
