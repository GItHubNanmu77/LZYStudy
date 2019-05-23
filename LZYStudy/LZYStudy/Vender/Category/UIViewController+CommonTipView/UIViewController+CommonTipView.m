//
//  UIViewController+CommonTipView.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "UIViewController+CommonTipView.h"
#import <objc/runtime.h>


@interface UIViewController ()

@property (nonatomic, strong) LZYCommonTipView *commonTipsView;

@end

@implementation UIViewController (CommonTipView)

#pragma mark - Getters & Setters
- (LZYCommonTipView *)commonTipsView {
    return objc_getAssociatedObject(self, @selector(commonTipsView));
}

- (void)setCommonTipsView:(LZYCommonTipView *)commonTipsView {
    objc_setAssociatedObject(self, @selector(commonTipsView), commonTipsView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageSize {
    NSNumber *pageSize = objc_getAssociatedObject(self, _cmd);
    return [pageSize integerValue];
}

- (void)setPageSize:(NSInteger)pageSize {
    objc_setAssociatedObject(self, @selector(pageSize), @(pageSize), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)pageIndex {
    NSNumber *pageIndex = objc_getAssociatedObject(self, _cmd);
    return [pageIndex integerValue];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    objc_setAssociatedObject(self, @selector(pageIndex), @(pageIndex), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Public Methods
- (void)showNoDataTipsView:(UIView *)superview noDataString:(NSString *)noDataString {
    [self showNoDataTipsView:superview frame:superview.bounds noDataString:noDataString];
}

- (void)showNoDataTipsView:(UIView *)superview frame:(CGRect)frame noDataString:(NSString *)noDataString {
    self.commonTipsView = [[LZYCommonTipView alloc] initWithFrame:frame viewStyle:SDQZTipsViewNoDataStyle];
    [superview addSubview:self.commonTipsView];
    [self.commonTipsView show:noDataString];
}

- (void)showErrorTipsView:(UIView *)superview errorString:(NSString *)errorString {
    [self showErrorTipsView:superview frame:superview.bounds errorString:errorString];
}

- (void)showErrorTipsView:(UIView *)superview frame:(CGRect)frame errorString:(NSString *)errorString {
    self.commonTipsView = [[LZYCommonTipView alloc] initWithFrame:frame viewStyle:SDQZTipsViewErrorStyle];
    [superview addSubview:self.commonTipsView];
    [self.commonTipsView show:errorString];
}

- (void)showLoginTipsView:(UIView *)superview buttonAction:(ButtonActionBlock)buttonAction {
    [self showLoginTipsView:superview frame:superview.bounds buttonAction:buttonAction];
}

- (void)showLoginTipsView:(UIView *)superview frame:(CGRect)frame buttonAction:(ButtonActionBlock)buttonAction {
    self.commonTipsView = [[LZYCommonTipView alloc] initWithFrame:frame viewStyle:SDQZTipsViewLoginStyle buttonAction:buttonAction];
    [superview addSubview:self.commonTipsView];
    [self.commonTipsView show:@"请重新登录"];
}



@end
