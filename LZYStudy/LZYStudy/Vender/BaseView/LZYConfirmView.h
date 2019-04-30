//
//  LZYConfirmView.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/30.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZYConfirmView : UIView
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content isDoubleButton:(BOOL )isDouble;
- (void)show;


/// 背景颜色
@property (nonatomic, strong) UIColor *viewBackgroundColor;
/// 取消按钮文字正常颜色
@property (nonatomic, strong) UIColor *cancelButtonTitleNormalColor;
/// 确定按钮文字正常颜色
@property (nonatomic, strong) UIColor *confirmButtonTitleNormalColor;

/// 确定按钮点击返回数据
@property (nonatomic, copy) void(^confirmButtonPressedCallback) (void);

@end

NS_ASSUME_NONNULL_END
