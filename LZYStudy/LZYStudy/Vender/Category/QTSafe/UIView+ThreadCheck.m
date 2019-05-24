//
//  UIView+ThreadCheck.m
//  QTCategory
//
//  Created by 张俊博 on 2017/5/3.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "UIView+ThreadCheck.h"
#import "NSObject+QTAdd.h"
#import <pthread.h>

#define QTCheckUIThread() NSAssert([NSThread isMainThread], \
@"You must change UI on main thread!")

@implementation UIView (ThreadCheck)

+ (void)load {
    [self swizzleInstanceMethod:@selector(safe_setNeedsLayout)
                       tarClass:[self class]
                         tarSel:@selector(setNeedsLayout)];
    [self swizzleInstanceMethod:@selector(safe_setNeedsDisplay)
                       tarClass:[self class]
                         tarSel:@selector(setNeedsDisplay)];
    [self swizzleInstanceMethod:@selector(safe_setNeedsDisplayInRect:)
                       tarClass:[self class]
                         tarSel:@selector(setNeedsDisplayInRect:)];
    [self swizzleInstanceMethod:@selector(safe_layoutIfNeeded)
                       tarClass:[self class]
                         tarSel:@selector(layoutIfNeeded)];
    if (@available(iOS 10.0, *)) {
        [self swizzleInstanceMethod:@selector(safe_layoutSubviews)
                           tarClass:[self class]
                             tarSel:@selector(layoutSubviews)];
    }
    
    [self swizzleInstanceMethod:@selector(safe_setNeedsUpdateConstraints)
                       tarClass:[self class]
                         tarSel:@selector(setNeedsUpdateConstraints)];
}

- (void)safe_setNeedsLayout
{
    //WKWebView 是在后台加载的
    if (![self.subviews.firstObject isKindOfClass:NSClassFromString(@"WKPDFPageNumberIndicator")]) {
        QTCheckUIThread();
    }

    if (pthread_main_np()) {
        [self safe_setNeedsLayout];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_setNeedsLayout];
        });
    }
    
//    [self safe_setNeedsLayout];
}

- (void)safe_setNeedsDisplay
{
    //WKWebView 是在后台加载的
    if (![self.subviews.firstObject isKindOfClass:NSClassFromString(@"WKPDFPageNumberIndicator")]) {
        QTCheckUIThread();
    }
    
    if (pthread_main_np()) {
        [self safe_setNeedsDisplay];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_setNeedsDisplay];
        });
    }
    
//    [self safe_setNeedsDisplay];
}

- (void)safe_setNeedsDisplayInRect:(CGRect)rect
{
    //WKWebView 是在后台加载的
    if (![self.subviews.firstObject isKindOfClass:NSClassFromString(@"WKPDFPageNumberIndicator")]) {
        QTCheckUIThread();
    }
    
    if (pthread_main_np()) {
        [self safe_setNeedsDisplayInRect:rect];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_setNeedsDisplayInRect:rect];
        });
    }
    
//    [self safe_setNeedsDisplayInRect:rect];
}

- (void)safe_layoutIfNeeded {
    if (![self.subviews.firstObject isKindOfClass:NSClassFromString(@"WKPDFPageNumberIndicator")]) {
        QTCheckUIThread();
    }
    
    if (pthread_main_np()) {
        [self safe_layoutIfNeeded];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_layoutIfNeeded];
        });
    }
    
//    [self safe_layoutIfNeeded];
}

- (void)safe_layoutSubviews {
    //WKWebView 是在后台加载的
    if (![self.subviews.firstObject isKindOfClass:NSClassFromString(@"WKPDFPageNumberIndicator")]) {
        QTCheckUIThread();
    }
    
    if (pthread_main_np()) {
        [self safe_layoutSubviews];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_layoutSubviews];
        });
    }
    
//    [self safe_layoutSubviews];
}

- (void)safe_setNeedsUpdateConstraints {
    //WKWebView 是在后台加载的
    if (![self.subviews.firstObject isKindOfClass:NSClassFromString(@"WKPDFPageNumberIndicator")]) {
        QTCheckUIThread();
    }
    
    if (pthread_main_np()) {
        [self safe_setNeedsUpdateConstraints];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self safe_setNeedsUpdateConstraints];
        });
    }
    
//    [self safe_setNeedsUpdateConstraints];
}

@end
