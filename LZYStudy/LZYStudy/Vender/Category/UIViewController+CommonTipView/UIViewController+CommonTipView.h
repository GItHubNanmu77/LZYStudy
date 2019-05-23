//
//  UIViewController+CommonTipView.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZYCommonTipView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 数据提示类别扩展
 */

@interface UIViewController (CommonTipView)

/// 提示视图
@property (nonatomic, strong, readonly) LZYCommonTipView *commonTipsView;
/// 每页记录数
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页码
@property (nonatomic, assign) NSInteger pageIndex;

- (void)showNoDataTipsView:(UIView *)superview noDataString:(NSString *)noDataString;
- (void)showNoDataTipsView:(UIView *)superview frame:(CGRect)frame noDataString:(NSString *)noDataString;
- (void)showErrorTipsView:(UIView *)superview errorString:(NSString *)errorString;
- (void)showErrorTipsView:(UIView *)superview frame:(CGRect)frame errorString:(NSString *)errorString;
- (void)showLoginTipsView:(UIView *)superview buttonAction:(ButtonActionBlock)buttonAction;
- (void)showLoginTipsView:(UIView *)superview frame:(CGRect)frame buttonAction:(ButtonActionBlock)buttonAction;

@end

NS_ASSUME_NONNULL_END
