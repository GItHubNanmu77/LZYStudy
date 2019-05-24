//
//  NSArray+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/9.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSArray+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSArray (QTSafe)

+ (void)load {
//#if !DEBUG
//        [NSArray alloc]; //--> __PlaceholderArray
//        [[NSArray alloc] init]; //--> __NSArray0 这里比较特殊，空的NSArray其实没有实际意义，因为没有数据也不能被骗修改
//        [[NSArray alloc] initWithObject:@0]; //--> __NSArrayI
//        [NSMutableArray alloc]; //--> __PlaceholderArray
//        [[NSMutableArray alloc] init];//--> __NSArrayM
        
        //NSArray
        [self swizzleClassMethod:@selector(arrayWithObjects:count:)
                            with:@selector(arrayWithObjects_safe:count:)];
        [self swizzleInstanceMethod:@selector(getObjects:range:)
                               with:@selector(safe_getObjects:range:)];
        [self swizzleInstanceMethod:@selector(objectsAtIndexes:)
                               with:@selector(safe_objectsAtIndexes:)];
        [self swizzleInstanceMethod:@selector(subarrayWithRange:)
                               with:@selector(safe_subarrayWithRange:)];
        
        [self swizzleInstanceMethod:@selector(initWithArray:range:copyItems:)
                               with:@selector(initWithArray_safe:range:copyItems:)];
        
        //__NSArrayI
        [self swizzleInstanceMethod:@selector(__NSArray_arrayByAddingObject:)
                           tarClass:NSClassFromString(@"__NSArrayI")
                             tarSel:@selector(arrayByAddingObject:)];
        [self swizzleInstanceMethod:@selector(__NSArray_getObjects:range:)
                           tarClass:NSClassFromString(@"__NSArrayI")
                             tarSel:@selector(getObjects:range:)];
        if (@available(iOS 11.0, *)) {
            [self swizzleInstanceMethod:@selector(__NSArray_objectAtIndexedSubscript:)
                               tarClass:NSClassFromString(@"__NSArrayI")
                                 tarSel:@selector(objectAtIndexedSubscript:)];
        }
        
//        [self swizzleInstanceMethod:@selector(__NSArray_dealloc)
//                           tarClass:NSClassFromString(@"__NSArrayI")
//                             tarSel:NSSelectorFromString(@"dealloc")];
        
        //__NSArray0
        if (@available(iOS 11.0, *)) {
            [self swizzleInstanceMethod:@selector(__NSArray0_objectAtIndexedSubscript:)
                               tarClass:NSClassFromString(@"__NSArray0")
                                 tarSel:@selector(objectAtIndexedSubscript:)];
        }
        
        
        //__NSSingleObjectArrayI
        [self swizzleInstanceMethod:@selector(__NSSingleObjectArrayI_getObjects:range:)
                           tarClass:NSClassFromString(@"__NSSingleObjectArrayI")
                             tarSel:@selector(getObjects:range:)];
        if (@available(iOS 11.0, *)) {
            [self swizzleInstanceMethod:@selector(__NSSingleObjectArrayI_objectAtIndexedSubscript:)
                               tarClass:NSClassFromString(@"__NSSingleObjectArrayI")
                                 tarSel:@selector(objectAtIndexedSubscript:)];
        }
        
        
        //__NSPlaceholderArray
        [self swizzleInstanceMethod:@selector(initWithObjects_safe:count:)
                           tarClass:NSClassFromString(@"__NSPlaceholderArray")
                             tarSel:@selector(initWithObjects:count:)];
        
//        [NSArray test];

//#endif
}

#pragma Mark  -- NSArray相关

- (instancetype)initWithArray_safe:(NSArray *)set range:(NSRange)range copyItems:(BOOL)flag
{
    @try {
        self = [self initWithArray_safe:set range:range copyItems:flag];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        self = [self initWithArray_safe:set range:NSMakeRange(0, set.count-1) copyItems:flag];
    } @finally {
        return self;
    }
}

+ (instancetype)arrayWithObjects_safe:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self arrayWithObjects_safe:objects count:cnt];
        
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
        
        instance = [self arrayWithObjects_safe:newObjects count:newObjcIndex];
    } @finally {
        return instance;
    }
}

- (void)safe_getObjects:(const id _Nonnull __unsafe_unretained *)objects range:(NSRange)range{
    
    @try {
        [self safe_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (NSArray *)safe_objectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *objects = nil;
    @try {
        objects = [self safe_objectsAtIndexes:indexes];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return objects;
    }
}

- (NSArray *)safe_subarrayWithRange:(NSRange)range {
    if (range.location + range.length > self.count) {
        return nil;
    }
    NSArray *objects = @[];
    @try {
        objects = [self safe_subarrayWithRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return objects;
    }
}

#pragma mark -- __NSArrayI

- (NSArray *)__NSArray_arrayByAddingObject:(id)anObject {
    
    if (!anObject) {
        return self;
    }
    
    id objc = self;
    
    @try {
        objc = [self __NSArray_arrayByAddingObject:anObject];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return objc;
    }
    
}

- (void)__NSArray_getObjects:(const id _Nonnull __unsafe_unretained *)objects range:(NSRange)range {
    
    @try {
        [self __NSArray_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (id)__NSArray_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= [self count]) {
        return nil;
    }
    
    id objc = nil;
    
    @try {
        objc = [self __NSArray_objectAtIndexedSubscript:idx];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return objc;
    }
}

//- (void)__NSArray_dealloc {
//    @try {
//        [self __NSArray_dealloc];
//    } @catch (NSException *exception) {
//        [NSObject printExceptionReason:exception];
//    } @finally {
//        
//    }
//}

#pragma mark -- __NSArray0

- (id)__NSArray0_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= [self count]) {
        return nil;
    }
    
    id objc = nil;
    
    @try {
        objc = [self __NSArray0_objectAtIndexedSubscript:idx];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return objc;
    }
}

#pragma mark __NSSingleObjectArrayI

- (void)__NSSingleObjectArrayI_getObjects:(const id _Nonnull __unsafe_unretained *)objects range:(NSRange)range {
    
    @try {
        [self __NSSingleObjectArrayI_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (id)__NSSingleObjectArrayI_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= [self count]) {
        return nil;
    }
    
    id objc = nil;
    
    @try {
        objc = [self __NSSingleObjectArrayI_objectAtIndexedSubscript:idx];
        
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return objc;
    }
}

#pragma mark __NSPlaceholderArray

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
//    NSArray *array = @[@"0", @"1", @"2"];
//    id value = [array objectAtIndex:10];
//    value = array[10];
//    value = nil;
//    [array arrayByAddingObject:value];
//    array = @[@"0", @"1", @"2", value ,@"4"];
//    [array objectsAtIndexes:[NSIndexSet indexSetWithIndex:10]];
//    NSRange range = NSMakeRange(2, 10);
//    [array subarrayWithRange:range];
//}

@end
