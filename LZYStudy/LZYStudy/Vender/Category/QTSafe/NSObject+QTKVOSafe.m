//
//  NSObject+QTKVOSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/11/2.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSObject+QTKVOSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"
#import <objc/runtime.h>
#import <pthread.h>
#import <objc/message.h>

@interface TestKVO : NSObject
@property (nonatomic, copy) NSString *t;
@end
@implementation TestKVO
- (void)setT:(NSString *)t {
    _t = t;
}

@end

@interface TestObesrve : NSObject

@end

@implementation TestObesrve

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(nullable void *)context {

}

- (void)dealloc {
    
}

@end

@interface _QTNSObjectKVOWeakTarget : NSObject

@property (nullable, nonatomic, weak) id target;

@end

@implementation _QTNSObjectKVOWeakTarget

- (id)initWithTarget:(id)target {
    if (self = [super init]) {
        _target = target;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.target) return;
    
    if ([self.target respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
        @try {
            [self.target observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        } @catch (NSException *exception) {
//            [NSObject printExceptionReason:exception];
        } @finally {
            
        }
    }
}

- (NSString *)debugDescription
{
    NSMutableString *s = [NSMutableString stringWithFormat:@"<%@:%p", NSStringFromClass([self class]), self];
    [s appendFormat:@" observer:<%@:%p>", NSStringFromClass([_target class]), _target];
    [s appendString:@">"];
    return s;
}

- (void)dealloc {
    
}

@end

@implementation NSObject (QTKVOSafe)

+ (void)swizzleKVO {
    [self swizzleInstanceMethod:@selector(safe_addObserver:forKeyPath:options:context:)
                       tarClass:[NSObject class]
                         tarSel:@selector(addObserver:forKeyPath:options:context:)];
    [self swizzleInstanceMethod:@selector(safe_removeObserver:forKeyPath:)
                       tarClass:[NSObject class]
                         tarSel:@selector(removeObserver:forKeyPath:)];
    [self swizzleInstanceMethod:@selector(safe_removeObserver:forKeyPath:context:)
                       tarClass:[NSObject class]
                         tarSel:@selector(removeObserver:forKeyPath:context:)];

//    [self Obesrvetest];
}

#pragma KVO
- (void)safe_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {

    if (!keyPath || !observer) return;
    @try {
        if ([NSStringFromClass(self.class) isEqualToString:@"QTWebViewController"]
            && [NSStringFromClass(observer.class) isEqualToString:@"FoObjectSELObserverItem"]) {
            SEL sel = ((SEL (*)(id, SEL))(void *) objc_msgSend)((id)observer, @selector(sel));
            if ([NSStringFromSelector(sel) hasPrefix:@"view"]) {
                [self.growingIOKVODic setObject:observer forKey:keyPath];
            }
        }
        
        _QTNSObjectKVOWeakTarget *target = [[_QTNSObjectKVOWeakTarget alloc] initWithTarget:observer];
        NSMutableDictionary *dic = [self _qt_allNSObjectKVOTargets];
        NSMutableArray *arr = dic[keyPath];
        if (!arr) {
            arr = [NSMutableArray new];
            dic[keyPath] = arr;
        }
        [arr addObject:target];
        [self safe_addObserver:target forKeyPath:keyPath options:options context:context];
    } @catch (NSException *exception) {
//            [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    
    if (!keyPath || !observer) return;
    @try {
        if ([observer isKindOfClass:[_QTNSObjectKVOWeakTarget class]]) {
            [self safe_removeObserver:observer forKeyPath:keyPath];
            return;
        }
        NSMutableDictionary *dic = [self _qt_allNSObjectKVOTargets];
        NSMutableArray *arr = dic[keyPath];
        NSMutableArray *remove = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock: ^(_QTNSObjectKVOWeakTarget *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.target isEqual:observer]) {
                [self safe_removeObserver:obj forKeyPath:keyPath];
                [remove addObject:obj];
            }
        }];
        
        [arr removeObjectsInArray:remove];
        
        if (arr.count<=0) {
            [dic removeObjectForKey:keyPath];
        }
    } @catch (NSException *exception) {
//            [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    
    if (!keyPath || !observer) return;
    @try {
        if ([observer isKindOfClass:[_QTNSObjectKVOWeakTarget class]]) {
            [self safe_removeObserver:observer forKeyPath:keyPath context:context];
            return;
        }
        NSMutableDictionary *dic = [self _qt_allNSObjectKVOTargets];
        NSMutableArray *arr = dic[keyPath];
        NSMutableArray *remove = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock: ^(_QTNSObjectKVOWeakTarget *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.target isEqual:observer]) {
                [self safe_removeObserver:obj forKeyPath:keyPath];
                [remove addObject:obj];
            }
        }];
        
        [arr removeObjectsInArray:remove];
        
        if (arr.count<=0) {
            [dic removeObjectForKey:keyPath];
        }
    } @catch (NSException *exception) {
//            [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (NSMutableDictionary *)_qt_allNSObjectKVOTargets {
    @synchronized (self) {
        NSMutableDictionary *targets = objc_getAssociatedObject(self, _cmd);
        if (!targets) {
            targets = [NSMutableDictionary new];
            objc_setAssociatedObject(self, _cmd, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return targets;
    }
}

- (NSMutableDictionary *)growingIOKVODic {
    @synchronized (self) {
        NSMutableDictionary *growingIOKVODic = objc_getAssociatedObject(self, _cmd);
        if (!growingIOKVODic) {
            growingIOKVODic = [NSMutableDictionary new];
            objc_setAssociatedObject(self, _cmd, growingIOKVODic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return growingIOKVODic;
    }
}

- (void)_qt_removeAllNSObjectKVOTargets {
    @try {
        NSMutableDictionary *growingIOKVODic = objc_getAssociatedObject(self, @selector(growingIOKVODic));
        if (growingIOKVODic) {
            [growingIOKVODic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [self removeObserver:obj forKeyPath:key];
            }];
            [growingIOKVODic removeAllObjects];
        }
        
        NSMutableDictionary *targets = objc_getAssociatedObject(self, @selector(_qt_allNSObjectKVOTargets));
        if (targets) {
            [targets enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray *obj, BOOL * _Nonnull stop) {
                [obj enumerateObjectsUsingBlock: ^(id _obj, NSUInteger idx, BOOL *stop) {
                    [self removeObserver:_obj forKeyPath:key];
                }];
            }];
            [targets removeAllObjects];
        }
        objc_removeAssociatedObjects(self);
    } @catch (NSException *exception) {
//            [NSObject printExceptionReason:exception];
    } @finally {
        
    }
    
}

+ (void)Obesrvetest {
    TestKVO *t = [[TestKVO alloc] init];
    t.t = @"";
    TestObesrve *observe = [[TestObesrve alloc] init];
    TestObesrve *observe1 = [[TestObesrve alloc] init];
    [t addObserver:observe forKeyPath:@"t" options:NSKeyValueObservingOptionNew context:nil];
    [t addObserver:observe1 forKeyPath:@"t" options:NSKeyValueObservingOptionNew context:nil];
    t.t = @"1";
    [t removeObserver:observe forKeyPath:@"t"];
    observe = nil;
    t.t = @"2";
//     [t removeObserver:observe forKeyPath:@"t"];
    
    [t performSelector:@selector(setT:) withObject:@"3" afterDelay:5];
//    t = nil;
    
}

@end


