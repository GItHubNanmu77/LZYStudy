//
//  UINavigationController+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/15.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "UINavigationController+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation UINavigationController (QTSafe)

+ (void)load {
//#if !DEBUG
        @autoreleasepool {
//            [self swizzleInstanceMethod:@selector(popViewControllerAnimated:)
//                                   with:@selector(safe_popViewControllerAnimated:)];
            [self swizzleInstanceMethod:@selector(popToRootViewControllerAnimated:)
                                   with:@selector(safe_popToRootViewControllerAnimated:)];
            [self swizzleInstanceMethod:@selector(popToViewController:animated:)
                                   with:@selector(safe_popToViewController:animated:)];
            [self swizzleInstanceMethod:@selector(pushViewController:animated:)
                                   with:@selector(safe_pushViewController:animated:)];
        }
//#endif
}

//- (UIViewController *)safe_popViewControllerAnimated:(BOOL)animated {
//    
//    UIViewController *controller;
//    @try {
//        controller = [self safe_popViewControllerAnimated:animated];
//    } @catch (NSException *exception) {
//        NSLog(@"exception: %@",exception.reason);
//        NSLog(@"exception: %@", [NSThread callStackSymbols]);
//    } @finally {
//        return controller;
//    }
//    
//}

- (NSArray *)safe_popToRootViewControllerAnimated:(BOOL)animated {
    
    NSArray *controllers;
    @try {
        controllers = [self safe_popToRootViewControllerAnimated:animated];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return controllers;
    }
    
}

- (NSArray *)safe_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSArray *controllers;
    @try {
        controllers = [self safe_popToViewController:viewController animated:animated];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return controllers;
    }
}

- (void)safe_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    @try {
        [self safe_pushViewController:viewController animated:animated];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}


@end
