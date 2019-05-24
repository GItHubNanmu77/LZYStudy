//
//  NSOrderedSet+QTSafe_MRC.m
//  QTCategory
//
//  Created by 张俊博 on 2017/11/10.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSOrderedSet+QTSafe_MRC.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSOrderedSet (QTSafe_MRC)

+ (void)load {
        [self swizzleInstanceMethod:@selector(objectAtIndex:)
                               with:@selector(safe_objectAtIndex:)];
        [self swizzleInstanceMethod:@selector(__NSOrderedSetI_objectAtIndex:)
                           tarClass:NSClassFromString(@"__NSOrderedSetI")
                             tarSel:@selector(objectAtIndex:)];
}

- (instancetype)safe_objectAtIndex:(NSUInteger)idx {
    if (idx > self.count) {
        return nil;
    }
    id objc = nil;
    
    @try {
        objc = [self safe_objectAtIndex:idx];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return objc;
    }
}

- (instancetype)__NSOrderedSetI_objectAtIndex:(NSUInteger)idx {
    if (idx > self.count) {
        return nil;
    }
    id objc = nil;
    
    @try {
        objc = [self __NSOrderedSetI_objectAtIndex:idx];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return objc;
    }
}

@end
