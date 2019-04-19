//
//  UIView+RoundCorner.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/19.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "UIView+RoundCorner.h"

@implementation UIView (RoundCorner)

/**
 设置视图角度(默认四个角)
 
 @param radius 圆角半径
 */
- (void)addRoundCorner:(CGFloat)cornerRadius {
    CGSize radiiSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:radiiSize];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

/**
 *  设置视图角度
 *
 *  @param corners 需要设置圆角的角
 *  @param cornerRadius  圆角半径
 */
- (void)addRoundCorner:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius {
    CGSize radiiSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radiiSize];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

/**
 设置视图角度及边框
 
 @param corners 需要设置圆角的角
 @param cornerRadius 圆角半径
 @param borderWidth 视图边框宽度 (假如需要设置边框宽度为1.0，则此处需要穿2.0（2倍），因为使用这种方式设置边框，有一半的宽度在mask里面，另一半在mask外面，即我们需要的宽度)
 @param borderColor 视图边框颜色
 */
- (void)addRoundCorner:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    CGSize radiiSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radiiSize];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
    
    // 视图边框
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    lineLayer.lineWidth = borderWidth;
    lineLayer.strokeColor = borderColor.CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:lineLayer];
}

/**
 *  根据背景图设置view的形状
 *
 *  @param bgImage 背景图(形状)
 *  @param fillImage 填充图
 */
- (void)addRoundCornerWithImage:(UIImage *)bgImage fillImage:(UIImage *)fillImage {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.strokeColor = [UIColor clearColor].CGColor;
    maskLayer.frame = self.bounds;
    // 背景图拉伸
    // maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    maskLayer.contentsScale = [UIScreen mainScreen].scale; // 非常关键 设置自动拉伸的效果且不变形
    maskLayer.contents = (id)bgImage.CGImage;
    
    CALayer *contentLayer = [CALayer layer];
    contentLayer.mask = maskLayer;
    contentLayer.frame = self.bounds;
    contentLayer.contents = (id)fillImage.CGImage;
    [self.layer addSublayer:contentLayer];
}

@end


