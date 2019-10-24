//
//  LLRuntimeViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/10/21.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLRuntimeViewController.h"
#import <objc/runtime.h>
#import <objc/NSObject.h>

@interface LLRuntimeViewController ()

@end

@implementation LLRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self singSong:@"123"];
    [LLRuntimeViewController haveMeal:@"213"];
}

/**
 * 1. 动态方法解析。所谓动态解析，我们可以理解为通过cache和方法列表没有找到方法时，Runtime为我们提供一次动态添加方法实现的机会，主要用到的方法如下：
 * 2.消息接收者重定向。我们注意到动态方法解析过程中的两个resolve方法都返回了布尔值，当它们返回YES时方法即可正常执行，但是若它们返回NO，消息发送机制就进入了消息转发(Forwarding)的阶段了，我们可以使用Runtime通过下面的方法替换消息接收者的为其他对象，从而保证程序的继续执行。
 * 
 * 3. 消息重定向。当以上两种方法无法生效，那么这个对象会因为找不到相应的方法实现而无法响应消息，此时Runtime系统会通过forwardInvocation：消息通知该对象，给予此次消息发送最后一次寻找IMP的机会：
 */
//--------第一步
//OC方法：
//类方法未找到时调起，可于此添加类方法实现
//+ (BOOL)resolveClassMethod:(SEL)sel{
//    return YES;
//}

//实例方法未找到时调起，可于此添加实例方法实现
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    return YES;
//}
 
//Runtime方法：
/**
 运行时方法：向指定类中添加特定方法实现的操作
 @param cls 被添加方法的类
 @param name selector方法名
 @param imp 指向实现方法的函数指针
 @param types imp函数实现的返回值与参数类型
 @return 添加方法是否成功
 */
//BOOL class_addMethod(Class _Nullable cls,
//                     SEL _Nonnull name,
//                     IMP _Nonnull imp,
//                     const char * _Nullable types);
 
//-------第二步
//重定向类方法的消息接收者，返回一个类
//- (id)forwardingTargetForSelector:(SEL)aSelector;

//重定向实例方法的消息接受者，返回一个实例对象
//- (id)forwardingTargetForSelector:(SEL)aSelector;

//-------第三步
//- (void)forwardInvocation:(NSInvocation *)anInvocation;
#pragma mark - example
 
//重写父类方法：处理类方法
+ (BOOL)resolveClassMethod:(SEL)sel{
    if(sel == @selector(haveMeal:)){
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(zs_haveMeal:)), "v@");
        return YES;   //添加函数实现，返回YES
    }
    return [class_getSuperclass(self) resolveClassMethod:sel];
}
//重写父类方法：处理实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if(sel == @selector(singSong:)){
        class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(zs_singSong:)), "v@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (void)zs_haveMeal:(NSString *)food{
    NSLog(@"%s",__func__);
}

- (void)zs_singSong:(NSString *)name{
    NSLog(@"%s",__func__);
}

//重定向类方法：返回一个类对象
+ (id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector == @selector(haveMeal:)) {
         
        return [self class];
    }
    return [super forwardingTargetForSelector:aSelector];
}
//重定向实例方法：返回类的实例
- (id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector == @selector(singSong:)) {
        return self;
    }
    return [super forwardingTargetForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
    //1.从anInvocation中获取消息
    SEL sel = anInvocation.selector;
    //2.判断Student方法是否可以响应应sel
    if ([self respondsToSelector:sel]) {
        //2.1若可以响应，则将消息转发给其他对象处理
        [anInvocation invokeWithTarget:self];
    }else{
        //2.2若仍然无法响应，则报错：找不到响应方法
        [self doesNotRecognizeSelector:sel];
    }
}

//需要从这个方法中获取的信息来创建NSInvocation对象，因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。
- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
    if (!methodSignature) {
        methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
    }
    return methodSignature;
}
@end
