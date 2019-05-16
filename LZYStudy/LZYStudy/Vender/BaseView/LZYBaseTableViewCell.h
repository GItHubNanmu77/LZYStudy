//
//  LZYBaseTableViewCell.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/16.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZYBaseTableViewCell : UITableViewCell

/// 显示 Top 分隔线
@property (nonatomic, assign) BOOL showTopSeparator;
/// 显示 Bottom 分割线
@property (nonatomic, assign) BOOL showBottomSeparator;
/// 左缩进分隔线
@property (nonatomic, assign) BOOL leftIntendSeparator;

/// cell背景颜色
@property (nonatomic, strong) UIColor *sNormalBackGroudViewColor;
/// cell选中背景颜色
@property (nonatomic, strong) UIColor *sSelectedBackGroudViewColor;

/**
 *  透明背景
 */
- (void)transparencyBackground;

/**
 *  设置自定义分隔线
 */
- (void)setCustomSeparator;

/**
 *  设置自定义分隔线，左右缩进
 *
 *  @param leftRightIntend 左右缩进值，大于零则 leftIntendSeparator 无效
 */
- (void)setCustomSeparator:(CGFloat)leftRightIntend;

/**
 *  设置自定义分隔线，左缩进
 *
 *  @param leftIntend 左缩进值，大于零则 leftIntendSeparator 无效
 */
- (void)setCustomLeftSeparator:(CGFloat)leftIntend;

/**
 *  cell复用唯一标识符
 *
 *  @return return value description
 */
+ (NSString *)cellIdentifier;

/**
 计算动态文本高度
 
 @param string 文本内容
 @param width 文本跨度
 @param fontSize 字体大小
 @return 高度
 */
+ (CGFloat)getContentStrHeight:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize;

@end


NS_ASSUME_NONNULL_END
