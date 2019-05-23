//
//  LZYCommonTipView.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDQZTipsViewStyle) {
    SDQZTipsViewNoDataStyle = 0, // 无数据
    SDQZTipsViewErrorStyle = 1, // 错误
    SDQZTipsViewLoginStyle = 2 // 登录失效
};

typedef void (^ButtonActionBlock)(NSInteger btnTag);

@interface LZYCommonTipView : UIView

- (instancetype)initWithFrame:(CGRect)frame viewStyle:(SDQZTipsViewStyle)viewStyle;
- (instancetype)initWithFrame:(CGRect)frame viewStyle:(SDQZTipsViewStyle)viewStyle buttonAction:(ButtonActionBlock)buttonAction;
- (void)show;
- (void)show:(NSString *)tipsText;
- (void)show:(NSString *)tipsText btnTitle:(NSString *)btnTitle;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
