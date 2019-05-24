//
//  UIApplication+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2018/2/8.
//  Copyright © 2018年 CISDI. All rights reserved.
//

#import "UIApplication+QTSafe.h"
#import "NSObject+QTAdd.h"
#import <objc/runtime.h>
//#import "QTCategory.h"

@implementation UIApplication (QTSafe)

+ (void)load {
    //#if !DEBUG
        [self swizzleInstanceMethod:@selector(qt_setNetworkActivityIndicatorVisible:)
                           tarClass:[UIApplication class]
                             tarSel:@selector(setNetworkActivityIndicatorVisible:)];
    //#endif
}

- (void)qt_setNetworkActivityIndicatorVisible:(BOOL)networkActivityIndicatorVisible {
    [self qt_setNetworkActivityIndicatorVisible:NO];
}

@end
