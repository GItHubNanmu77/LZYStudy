//
//  NSMutableOrderedSet+QTSafe_MRC.m
//  QTCategory
//
//  Created by 张俊博 on 2017/11/10.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSMutableOrderedSet+QTSafe_MRC.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSMutableOrderedSet (QTSafe_MRC)

+ (void)load {
        [self swizzleInstanceMethod:@selector(__NSOrderedSetM_objectAtIndex:)
                           tarClass:NSClassFromString(@"__NSOrderedSetM")
                             tarSel:@selector(objectAtIndex:)];
}

- (instancetype)__NSOrderedSetM_objectAtIndex:(NSUInteger)idx {
    if (idx > self.count) {
        return nil;
    }
    id objc = nil;
    
    @try {
        objc = [self __NSOrderedSetM_objectAtIndex:idx];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return objc;
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
