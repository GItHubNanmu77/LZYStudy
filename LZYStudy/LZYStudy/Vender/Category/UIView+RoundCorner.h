//
//  UIView+RoundCorner.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/19.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RoundCorner)

/**
 设置视图角度(默认四个角)
 
 @param cornerRadius 圆角半径
 */
- (void)addRoundCorner:(CGFloat)cornerRadius;

/**
 *  设置视图角度
 *
 *  @param corners 需要设置圆角的角
 *  @param cornerRadius  圆角半径
 */
- (void)addRoundCorner:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

/**
 设置视图角度及边框
 
 @param corners 需要设置圆角的角
 @param cornerRadius 圆角半径
 @param borderWidth 视图边框宽度 (假如需要设置边框宽度为1.0，则此处需要穿2.0（2倍），因为使用这种方式设置边框，有一半的宽度在mask里面，另一半在mask外面，即我们需要的宽度)
 @param borderColor 视图边框颜色
 */
- (void)addRoundCorner:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  根据背景图设置view的形状
 *
 *  @param bgImage 背景图(形状)
 *  @param fillImage 填充图
 */
- (void)addRoundCornerWithImage:(UIImage *)bgImage fillImage:(UIImage *)fillImage;

@end

NS_ASSUME_NONNULL_END
