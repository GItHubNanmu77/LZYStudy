//
//  NSMutableArray+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/9.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSMutableArray+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSMutableArray (QTSafe)

+ (void)load {
//#if !DEBUG
        [self swizzleInstanceMethod:@selector(safeM_addObject:)
                           tarClass:NSClassFromString(@"__NSArrayM")
                             tarSel:@selector(addObject:)];
        [self swizzleInstanceMethod:@selector(safeM_getObjects:range:)
                           tarClass:NSClassFromString(@"__NSArrayM")
                             tarSel:@selector(getObjects:range:)];
        [self swizzleInstanceMethod:@selector(safeM_setObject:atIndexedSubscript:)
                           tarClass:NSClassFromString(@"__NSArrayM")
                             tarSel:@selector(setObject:atIndexedSubscript:)];
        [self swizzleInstanceMethod:@selector(safeM_insertObject:atIndex:)
                           tarClass:NSClassFromString(@"__NSArrayM")
                             tarSel:@selector(insertObject:atIndex:)];
        [self swizzleInstanceMethod:@selector(safeM_removeObjectAtIndex:)
                           tarClass:NSClassFromString(@"__NSArrayM")
                             tarSel:@selector(removeObjectAtIndex:)];
        [self swizzleInstanceMethod:@selector(safeM_replaceObjectAtIndex:withObject:)
                           tarClass:NSClassFromString(@"__NSArrayM")
                             tarSel:@selector(replaceObjectAtIndex:withObject:)];
        if (@available(iOS 11.0, *)) {
            [self swizzleInstanceMethod:@selector(safeM_objectAtIndexedSubscript:)
                               tarClass:NSClassFromString(@"__NSArrayM")
                                 tarSel:@selector(objectAtIndexedSubscript:)];
        }
        
//        [NSMutableArray test];
//#endif
}

- (void)safeM_addObject:(id)anObject {
    if (!anObject) {
        return;
    }
    
    @try {
        [self safeM_addObject:anObject];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeM_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self safeM_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeM_setObject:(id)objc atIndexedSubscript:(NSUInteger)idx {
    
    @try {
        [self safeM_setObject:objc atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        
    }
    
}

- (void)safeM_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count] || !anObject) {
        return;
    }
    @try {
        [self safeM_insertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeM_removeObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return;
    }
    @try {
        [self safeM_removeObjectAtIndex:index];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeM_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count] || !anObject) {
        return;
    }
    @try {
        [self safeM_replaceObjectAtIndex:index withObject:anObject];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (id)safeM_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= [self count]) {
        return nil;
    }
    
    id objc = nil;
    
    @try {
        objc = [self safeM_objectAtIndexedSubscript:idx];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return objc;
    }
}

#pragma mark - Debug

//+ (void)test {
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"0", @"1", @"2", nil];
//    id value = [array objectAtIndex:10];
//    value = array[10];
//    value = nil;
//    [array addObject:value];
//    [array insertObject:value atIndex:10];
//    [array removeObjectAtIndex:10];
//    [array replaceObjectAtIndex:10 withObject:value];
//    [array arrayByAddingObject:value];
//    NSRange range = NSMakeRange(2, 10);
//    [array subarrayWithRange:range];
//    [array objectsAtIndexes:[NSIndexSet indexSetWithIndex:10]];
//    [array setObject:value atIndexedSubscript:10];
//}

@end
