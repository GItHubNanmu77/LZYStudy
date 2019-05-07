//
//  LZYDateTimePickerView.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/29.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LZYDateTimePickerStyle) {
    LZYDateTimePickerStyleYearMonthDayHourMinute = 1 << 0, //年月日时分
    LZYDateTimePickerStyleMonthDayHourMinute = 1 << 1, //月日时分
    LZYDateTimePickerStyleYearMonthDay = 1 << 2, //年月日
    LZYDateTimePickerStyleMonthDay = 1 << 3, //月日
    LZYDateTimePickerStyleHourMinute = 1 << 4, //时分
};

@interface LZYDateTimePickerView : UIView 

/**
 *  初始化
 *
 *  @param style                  选择器类型
 *  @param defaultDateStr         默认选中时间
 *
 *  @return return value description
 */
- (instancetype)initWithDatePickerStyle:(LZYDateTimePickerStyle )style defaultDateStr:(nullable NSString *)defaultDateStr isDoubleSelected:(BOOL)isDouble;
- (void)show;

/// 限制最大时间（没有设置默认2199）
@property (nonatomic, retain) NSDate *maxLimitDate;
/// 限制最小时间（没有设置默认1900）
@property (nonatomic, retain) NSDate *minLimitDate;

/// 背景颜色
@property (nonatomic, strong) UIColor *viewBackgroundColor;

/// 选择器背景颜色
@property (nonatomic, strong) UIColor *pickerItemBackgroundColor;
/// 选择器分隔线颜色
@property (nonatomic, strong) UIColor *pickerItemSeparatorColor;
/// 选择器文字颜色
@property (nonatomic, strong) UIColor *pickerItemTitleColor;

/// 按钮背景颜色
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
/// 按钮文字正常颜色
@property (nonatomic, strong) UIColor *buttonTitleNormalColor;
/// 按钮文字高亮颜色
@property (nonatomic, strong) UIColor *buttonTitleHighlightedColor;
/// 标题内容
@property (nonatomic, copy) NSString *titleName;
/// 单选确定按钮点击返回数据
@property (nonatomic, copy) void(^confirmButtonPressedCallback) (NSString *dateString);
/// 双选确定按钮点击返回数据
@property (nonatomic, copy) void(^doubleConfirmButtonPressedCallback) (NSString *startTime,NSString *endTime);
/// picker消失前的回调
@property (nonatomic, copy) void(^pickerBeforeDismissCallback) (void);

@end

NS_ASSUME_NONNULL_END
