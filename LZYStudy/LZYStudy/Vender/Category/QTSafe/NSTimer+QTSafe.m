//
//  NSTimer+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/11/2.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSTimer+QTSafe.h"
#import "NSObject+QTAdd.h"

@interface QTWeakProxy : NSProxy

@property (nullable, nonatomic, weak, readonly) id target;

+ (instancetype _Nullable )proxyWithTarget:(id _Nullable )target;

- (instancetype _Nullable )initWithTarget:(id _Nullable )target;

@end

@implementation QTWeakProxy

+ (instancetype)proxyWithTarget:(id)target {
    return [[QTWeakProxy alloc] initWithTarget:target];
}

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

@end

@implementation NSTimer (QTSafe)

+ (void)load {
        [self swizzleInstanceMethod:@selector(safe_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)
                           tarClass:[NSTimer class]
                             tarSel:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
        
        [self swizzleInstanceMethod:@selector(safe_timerWithTimeInterval:target:selector:userInfo:repeats:)
                           tarClass:[NSTimer class]
                             tarSel:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:)];
}

+ (NSTimer *)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    return [self safe_scheduledTimerWithTimeInterval:ti target:[QTWeakProxy proxyWithTarget:aTarget] selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

+ (NSTimer *)safe_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    return [self safe_timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

@end
