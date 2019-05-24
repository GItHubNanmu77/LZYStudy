//
//  NSDictionary+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/9.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSDictionary+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSDictionary (QTSafe)

+ (void) load {
//#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:)
                            with:@selector(safe_dictionaryWithObjects:forKeys:count:)];
        
        [self swizzleInstanceMethod:@selector(initWithObjects_safe:forKeys:count:)
                           tarClass:NSClassFromString(@"__NSPlaceholderDictionary")
                             tarSel:@selector(initWithObjects:forKeys:count:)];
        
//        [NSDictionary test];
    });
//#endif
}

+ (instancetype)safe_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        
        instance = [self safe_dictionaryWithObjects:objects forKeys:keys count:cnt];
        
    } @catch (NSException *exception) {
        //打印出异常数据
        
        [NSObject printExceptionReason:exception];
        
        //处理错误的数据，然后创建一个新的字典
        NSUInteger index = 0;
        
        //也可以使用NSMutableArray，来实现
        
        //定义一个指针，指向objects的初始位置
        id _Nonnull __unsafe_unretained clearObjects[cnt];
        //定义一个指针，指向keys的初始位置
        id <NSCopying> _Nonnull __unsafe_unretained clearKeys[cnt];
        
        
        
        for (int i=0; i<cnt; i++) {
            if (objects[i] && keys[i]) {
                clearObjects[index] = objects[i];
                clearKeys[index] = keys[i];
                index++;
            }
        }
        
        instance = [self safe_dictionaryWithObjects:clearObjects forKeys:clearKeys count:index];
        
    } @finally {
        
        return instance;
    }
    
    
}

#pragma mark __NSPlaceholderDictionary

- (instancetype)initWithObjects_safe:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    
//    if ((objects && !objects[0])
//        ||(keys && !keys[0])) {
//        id _Nonnull __unsafe_unretained clearObjects[0];
//        id <NSCopying> _Nonnull __unsafe_unretained clearKeys[0];
//        self = [self initWithObjects_safe:clearObjects forKeys:clearKeys count:0];
//        return self;
//    }
    
    @try {
        
        self = [self initWithObjects_safe:objects forKeys:keys count:cnt];
        
    } @catch (NSException *exception) {
        //打印出异常数据
        
        [NSObject printExceptionReason:exception];
        
        //处理错误的数据，然后创建一个新的字典
        NSUInteger index = 0;
        
        //也可以使用NSMutableArray，来实现
        
        //定义一个指针，指向objects的初始位置
        id _Nonnull __unsafe_unretained clearObjects[cnt];
        //定义一个指针，指向keys的初始位置
        id <NSCopying> _Nonnull __unsafe_unretained clearKeys[cnt];
        
        for (int i=0; i<cnt; i++) {
            if (objects[i] && keys[i]) {
                clearObjects[index] = objects[i];
                clearKeys[index] = keys[i];
                index++;
            }
        }
        
        self = [self initWithObjects_safe:clearObjects forKeys:clearKeys count:index];
        
    } @finally {
        
        return self;
    }
}

#pragma mark - Debug

//+ (void)test {
//    id value = nil;
//    NSDictionary *dictionary = @{@"key0":@"value0", @"key1":value, @"key2":@"value2"};
//    dictionary = @{@"key1":value};
//    id key = nil;
//    dictionary = @{@"key0":@"value0", key:value, @"key2":@"value2"};
//    dictionary = @{key:value};
//    value = dictionary[key];
//    
//    dictionary = @{};
//    value = dictionary[key];
//    dictionary = @{@"key0":@"value0"};
//    value = dictionary[key];
//}

@end
