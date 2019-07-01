//
//  UIViewController+Swizzling.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

typedef void (*_VIMP)(id, SEL, ...);


@implementation UIViewController (Swizzling)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 获取原始方法
//        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
//        // 获取方法实现
//        _VIMP viewDidLoad_IMP = (_VIMP)method_getImplementation(viewDidLoad);
//        // 重新设置方法实现
//        method_setImplementation(viewDidLoad, imp_implementationWithBlock(^(id target, SEL action) {
//            // 调用原有方法实现
//            viewDidLoad_IMP(target, @selector(viewDidLoad));
//
//            // 新增代码
//#if defined(DEBUG)
//            NSLog(@"\n\n\n");
//            NSLog(@"😃😃😃开始初始化%@😃😃😃", target);
//#endif
//        }));
//    });
//}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(viewWillAppear:);
        SEL swizzSel = @selector(swiz_viewWillAppear:);
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
        
        //viewWillDisappear
        SEL systemSel2 = @selector(viewWillDisappear:);
        SEL swizzSel2 = @selector(swiz_viewWillDisappear:);
        Method systemMethod2 = class_getInstanceMethod([self class], systemSel2);
        Method swizzMethod2 = class_getInstanceMethod([self class], swizzSel2);
        
        BOOL isAdd2 = class_addMethod(self, systemSel2, method_getImplementation(swizzMethod2), method_getTypeEncoding(swizzMethod2));
        if (isAdd2) {
            class_replaceMethod(self, swizzSel2, method_getImplementation(systemMethod2), method_getTypeEncoding(systemMethod2));
        }else{
            method_exchangeImplementations(systemMethod2, swizzMethod2);
        }
        
        
        //viewDidLoad
        SEL systemViewDidLoad = @selector(viewDidLoad);
        SEL swizzViewDidLoad = @selector(swiz_viewDidLoad);
        Method systemMethodSecond = class_getInstanceMethod([self class], systemViewDidLoad);
        Method swizzMethodSecond = class_getInstanceMethod([self class], swizzViewDidLoad);
        
        BOOL isAddSecond = class_addMethod(self, systemViewDidLoad, method_getImplementation(swizzMethodSecond), method_getTypeEncoding(swizzMethodSecond));
        if (isAddSecond) {
            class_replaceMethod(self, swizzViewDidLoad, method_getImplementation(systemMethodSecond), method_getTypeEncoding(systemMethodSecond));
        }else{
            method_exchangeImplementations(systemMethodSecond, swizzMethodSecond);
        }
        
        //delloc
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                       
                                       class_getInstanceMethod(self.class, @selector(swiz_dealloc)));
    });
}

- (void)swiz_viewWillAppear:(BOOL)animated{
    [self swiz_viewWillAppear:animated];
#if defined(DEBUG)
    NSLog(@"\n当前控制器：%@",NSStringFromClass([self class]));
#endif
    
}
- (void)swiz_viewWillDisappear:(BOOL)animated{
    [self swiz_viewWillDisappear:animated];
}

- (void)swiz_viewDidLoad{
    
}

-(void)swiz_dealloc{
    NSLog(@"\n上一个控制器：%@被销毁",NSStringFromClass([self class]));
    [self swiz_dealloc];
}
@end
