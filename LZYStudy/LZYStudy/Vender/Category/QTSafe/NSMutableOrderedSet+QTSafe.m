//
//  NSMutableOrderedSet+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/10/23.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSMutableOrderedSet+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSMutableOrderedSet (QTSafe)

+ (void)load {
        [self swizzleInstanceMethod:@selector(__NSOrderedSetM_addObject:)
                           tarClass:NSClassFromString(@"__NSOrderedSetM")
                             tarSel:@selector(addObject:)];
        [self swizzleInstanceMethod:@selector(__NSOrderedSetM_removeObject:)
                           tarClass:NSClassFromString(@"__NSOrderedSetM")
                             tarSel:@selector(removeObject:)];
        [self swizzleInstanceMethod:@selector(__NSOrderedSetM_removeObjectAtIndex:)
                           tarClass:NSClassFromString(@"__NSOrderedSetM")
                             tarSel:@selector(removeObjectAtIndex:)];
        [self swizzleInstanceMethod:@selector(__NSOrderedSetM_insertObject:atIndex:)
                           tarClass:NSClassFromString(@"__NSOrderedSetM")
                             tarSel:@selector(insertObject:atIndex:)];
        [self swizzleInstanceMethod:@selector(__NSOrderedSetM_replaceObjectAtIndex:withObject:)
                           tarClass:NSClassFromString(@"__NSOrderedSetM")
                             tarSel:@selector(replaceObjectAtIndex:withObject:)];
        [self swizzleInstanceMethod:@selector(__NSOrderedSetM_exchangeObjectAtIndex:withObjectAtIndex:)
                           tarClass:NSClassFromString(@"__NSOrderedSetM")
                             tarSel:@selector(exchangeObjectAtIndex:withObjectAtIndex:)];
}

- (void)__NSOrderedSetM_addObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self __NSOrderedSetM_addObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (void)__NSOrderedSetM_removeObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self __NSOrderedSetM_removeObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (void)__NSOrderedSetM_removeObjectAtIndex:(NSUInteger)idx {
    if (idx > self.count) {
        return;
    }
    @try {
        [self __NSOrderedSetM_removeObjectAtIndex:idx];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (void)__NSOrderedSetM_insertObject:(id)object atIndex:(NSUInteger)idx {
    if (!object) {
        return;
    }
    @try {
        [self __NSOrderedSetM_insertObject:object atIndex:idx];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

-(void)__NSOrderedSetM_replaceObjectAtIndex:(NSUInteger)idx withObject:(id)object {
    if (!object) {
        return;
    }
    @try {
        [self __NSOrderedSetM_replaceObjectAtIndex:idx withObject:object];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (void)__NSOrderedSetM_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (idx1>self.count || idx2>self.count) {
        return;
    }
    @try {
        [self __NSOrderedSetM_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

#pragma mark - Debug

//+ (void)test {
//    
//    id value = nil;
//    
//    NSMutableOrderedSet *test = [NSMutableOrderedSet orderedSet];
//    [test objectAtIndex:10];
//    [test addObject:value];
//    [test removeObject:value];
//    [test removeObjectAtIndex:10];
//    [test insertObject:value atIndex:10];
//    [test replaceObjectAtIndex:10 withObject:value];
//    [test exchangeObjectAtIndex:10 withObjectAtIndex:11];
//    
//    test = [NSMutableOrderedSet orderedSetWithObjects:@"1", @"2", nil];
//    [test objectAtIndex:10];
//    [test addObject:value];
//    [test removeObject:value];
//    [test removeObjectAtIndex:10];
//    [test insertObject:value atIndex:10];
//    [test replaceObjectAtIndex:10 withObject:value];
//    [test exchangeObjectAtIndex:10 withObjectAtIndex:11];
//    
//    test = [NSMutableOrderedSet orderedSetWithObject:@"1"];
//    [test objectAtIndex:10];
//    [test addObject:value];
//    [test removeObject:value];
//    [test removeObjectAtIndex:10];
//    [test insertObject:value atIndex:10];
//    [test replaceObjectAtIndex:10 withObject:value];
//    [test exchangeObjectAtIndex:10 withObjectAtIndex:11];
//}

@end
