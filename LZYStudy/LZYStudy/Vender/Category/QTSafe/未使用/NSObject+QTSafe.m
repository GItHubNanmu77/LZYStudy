//
//  NSObject+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/15.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSObject+QTSafe.h"
#import "NSObject+QTAdd.h"
#import <objc/runtime.h>
//#import "QTCategory.h"
#import "NSObject+Exceptioin.h"
#import "NSObject+QTKVOSafe.h"
#import "NSObject+Zombie.h"

#pragma mark - NSObject

@implementation NSObject (QTSafe)

+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleKVO];
//#if !DEBUG
        [self swizzleInstanceMethod:@selector(safe_setValue:forKey:)
                           tarClass:[NSObject class]
                             tarSel:@selector(setValue:forKey:)];
        [self swizzleInstanceMethod:@selector(safe_setValue:forKeyPath:)
                           tarClass:[NSObject class]
                             tarSel:@selector(setValue:forKeyPath:)];
        [self swizzleInstanceMethod:@selector(safe_setValue:forKeyUndefineKey:)
                           tarClass:[NSObject class]
                             tarSel:@selector(setValue:forUndefinedKey:)];
        [self swizzleInstanceMethod:@selector(safe_setValuesForKeysWithDictionary:)
                           tarClass:[NSObject class]
                             tarSel:@selector(setValuesForKeysWithDictionary:)];
        
        [self swizzleInstanceMethod:@selector(safe_valueForKey:)
                           tarClass:[NSObject class]
                             tarSel:@selector(valueForKey:)];
        [self swizzleInstanceMethod:@selector(safe_valueForKeyPath:)
                           tarClass:[NSObject class]
                             tarSel:@selector(valueForKeyPath:)];
        [self swizzleInstanceMethod:@selector(safe_valueForUndefinedKey:)
                           tarClass:[NSObject class]
                             tarSel:@selector(valueForUndefinedKey:)];
        
        [self swizzleInstanceMethod:@selector(safe_addObserver:selector:name:object:)
                           tarClass:[NSNotificationCenter class]
                             tarSel:@selector(addObserver:selector:name:object:)];
        
        [self swizzleInstanceMethod:NSSelectorFromString(@"safe_dealloc")
                           tarClass:[NSObject class]
                             tarSel:NSSelectorFromString(@"dealloc")];
    
        [self enableZombie];
//#endif
    });
}


- (void)safe_setValue:(id)value forKey:(NSString *)key {
    
    @try {
        [self safe_setValue:value forKey:key];
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safe_setValue:(id)value forKeyPath:(NSString *)keyPath {
    
    @try {
        [self safe_setValue:value forKeyPath:keyPath];
        
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
        
    } @finally {
        
    }
}

//通常消息转发，解析失败之后，这个方法在runtime期间会被调用，并且会抛出异常
- (void)safe_setValue:(id)value forKeyUndefineKey:(NSString *)key {
    
    @try {
        [self safe_setValue:value forKeyUndefineKey:key];
    } @catch (NSException *exception) {
        
        //打印出异常数据
        [NSObject printExceptionReason:exception];
        
    } @finally {
        
    }
}

- (void)safe_setValuesForKeysWithDictionary:(NSDictionary *) keydValues{
    
    @try {
        [self safe_setValuesForKeysWithDictionary:keydValues];
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (id)safe_valueForKey:(NSString *)key
{
    id value = nil;
    @try {
        value = [self safe_valueForKey:key];
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
    } @finally {
        return value;
    }
}

- (id)safe_valueForKeyPath:(NSString *)keyPath
{
    id value = nil;
    @try {
        value = [self safe_valueForKeyPath:keyPath];
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
    } @finally {
        return value;
    }
}

- (id)safe_valueForUndefinedKey:(NSString *)key
{
    id value = nil;
    @try {
        value = [self safe_valueForUndefinedKey:key];
    } @catch (NSException *exception) {
        //打印出异常数据
        [NSObject printExceptionReason:exception];
    } @finally {
        return value;
    }
}

#pragma mark Unrecognized Selector Sent To Instance

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    if ([NSStringFromClass(self.class) isEqualToString:@"QTProtocolDispatcher"] || [NSStringFromClass(self.class) isEqualToString:@"QTGCDMulticastDelegate"]) {
        return nil;
    }
    
    if ([self isCurrentClassInWhiteList]) {
        [[self class] warningDeveloper:aSelector];
        
        Class protectorCls = NSClassFromString(@"ProtectorClassName");
        if (!protectorCls){
            protectorCls = objc_allocateClassPair([NSObject class], "ProtectorClassName", 0);
            objc_registerClassPair(protectorCls);
        }
        
        if (![self isExistSelector:aSelector inClass:protectorCls]){
            class_addMethod(protectorCls, aSelector, [self safeImplementation:aSelector],[NSStringFromSelector(aSelector) UTF8String]);
        }
        
        Class Protector = [protectorCls class];
        id instance = [[Protector alloc] init];
        return instance;
    } else {
        return nil;
    }
}

#pragma clang diagnostic pop

- (BOOL)isCurrentClassInWhiteList{
    if ([NSStringFromClass(self.class) isEqualToString:@"UIWebBrowserView"]
        ||[NSStringFromClass(self.class) isEqualToString:@"_UIKeyboardPredictionViewProxy"]) {
        return NO;
    }
    NSSet *classNameArray = [NSSet setWithArray:@[@"QTZombie",
                                @"NSNull",
                                @"NSString",
                                @"__NSCFConstantString",
                                @"NSTaggedPointerString",
                                @"NSMutableString",
                                @"__NSCFString",
                                @"__NSCFConstantString",
                                @"NSArray",
                                @"__NSArrayI",
                                @"__NSArray0",
                                @"__NSSingleObjectArrayI",
                                @"__NSPlaceholderArray",
                                @"NSMutableArray",
                                @"__NSArrayM",
                                @"NSDictionary",
                                @"__NSPlaceholderDictionary",
                                @"NSMutableDictionary",
                                @"__NSDictionaryM",
                                @"NSAttributedString",
                                @"NSConcreteAttributedString",
                                @"NSMutableAttributedString",
                                @"NSConcreteMutableAttributedString",
                                @"NSURL",
                                @"__NSGlobalBlock__",
                                @"__NSCFType",
                                @"__NSCFNumber",
                                @"__NSMallocBlock__",
                                @"__NSCFArray",
                                @"FMStatement",
                                @"NSConcreteValue",
                                @"OS_dispatch_mach_msg",
                                @"CUIRenditionKey",
                                ]];
    if ([classNameArray containsObject:NSStringFromClass([self class])]) {
        return YES;
    }
    if ([NSStringFromClass(self.class) hasPrefix:@"QT"]) {
        return YES;
    }
    if ([self.class isSubclassOfClass:[UIView class]] || [self.class isSubclassOfClass:[UIResponder class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isExistSelector: (SEL)aSelector inClass:(Class)currentClass{
    BOOL isExist = NO;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(currentClass, &methodCount);
    for (int i = 0; i < methodCount; i++){
        Method temp = methods[i];
        SEL sel = method_getName(temp);
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName isEqualToString: NSStringFromSelector(aSelector)]){
            isExist = YES;
            break;
        }
    }
    
    return isExist;
}
- (BOOL)isExistSelector: (SEL)aSelector inProtocol:(Protocol *)protocol{
    struct objc_method_description description = protocol_getMethodDescription(protocol, aSelector, YES, YES);
    if (description.types) {
        return YES;
    }
    description = protocol_getMethodDescription(protocol, aSelector, NO, YES);
    if (description.types) {
        return YES;
    }
    return NO;
}
- (IMP)safeImplementation:(SEL)aSelector{
    IMP imp = imp_implementationWithBlock(^(){
        NSLog(@"PROTECTOR: %@ Done", NSStringFromSelector(aSelector));
    });
    return imp;
}
+ (void)warningDeveloper:(SEL)aSelector{
#if DEBUG
    NSString *selectorStr = NSStringFromSelector(aSelector);
    NSLog(@"PROTECTOR: -[%@ %@]", [self class], selectorStr);
    NSLog(@"PROTECTOR: unrecognized selector \"%@\" sent to instance: %p", selectorStr, self);
    NSLog(@"PROTECTOR: call stack: %@", [NSThread callStackSymbols]);
    //    @throw @"方法找不到";
#endif
}

#pragma mark - NSNotification

-(void)safe_addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject {
    [observer tagNSNotification];
    [self safe_addObserver:observer selector:aSelector name:aName object:anObject];
}

-(void)safe_dealloc {
    if ([self hasTagNSNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    //不用手动释放，objc_destructInstance会自动释放关联对象(暂不关闭，扫描二维码有问题、张班手机扫描二维码进入成功页面删除扫描页面时，崩溃)
    [self _qt_removeAllNSObjectKVOTargets];
    
    if (![self zombie_dealloc]) {
        [self safe_dealloc];
    }
}

-(void)tagNSNotification {
    objc_setAssociatedObject(self, @selector(tagNSNotification), @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)hasTagNSNotification {
    return  objc_getAssociatedObject(self, @selector(tagNSNotification))!=nil;
}

@end



