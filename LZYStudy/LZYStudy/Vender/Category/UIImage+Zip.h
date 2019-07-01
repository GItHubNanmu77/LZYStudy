//
//  UIImage+Zip.h
//  AcneTreatment
//
//  Created by Facebook on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Zip)


#pragma mark - 获取图片
/**
 获取指定路径的图片
 
 @param name 图片名称
 @param bundleName bundleName
 @param resizable 是否拉伸
 @return 图片
 */
- (UIImage *)getImageWithPath:(NSString *)name bundleName:(NSString *)bundleName resizable:(BOOL)resizable;

/**
 根据颜色和大小生成图片
 
 @param color 图片颜色
 @param size 图片大小
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;



#pragma mark - 填充
/**
 *  同比填充
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)aspectFill:(CGSize)size;

/**
 *  同比填充
 *
 *  @param size   <#size description#>
 *  @param offset <#offset description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)aspectFill:(CGSize)size offset:(CGFloat)offset;


#pragma mark - 缩放
/**
 *  等比例缩放
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)zoom:(CGSize)size;


#pragma mark - 压缩
/**
 *  压缩
 *
 *  @param compressionQuality 0.0 ≤ t ≤ 1.0
 *
 *  @return <#return value description#>
 */
- (NSData *)compressedData:(CGFloat)compressionQuality;

/**
 *  将图片压缩到指定宽度
 */
- (UIImage *)jkr_compressWithWidth:(CGFloat)width;
/**
 *  将图片在子线程中压缩，block在主线层回调，保证压缩到指定文件大小，尽量减少失真
 */
- (void)jkr_compressToDataLength:(NSInteger)length withBlock:(void(^)(NSData *data))block;
/**
 *  尽量将图片压缩到指定大小，不一定满足条件
 */
- (void)jkr_tryCompressToDataLength:(NSInteger)length withBlock:(void(^)(NSData *data))block;
/**
 *  快速将图片压缩到指定大小，失真严重
 */
- (void)jkr_fastCompressToDataLength:(NSInteger)length withBlock:(void (^)(NSData *))block;

/**
 * 拉伸图片：边角不拉伸
 */
- (UIImage *)resizableImage:(UIImage *)image;


#pragma mark - 图片转正
/**
 *  图片转正
 *
 *  @return <#return value description#>
 */
- (UIImage *)fixOrientation;

#pragma mark - 重新绘制图片
/**
 重新绘制图片
 
 @param newSize 需要重新绘制的尺寸
 @return <#return value description#>
 */
- (UIImage *)imageWithNewSize:(CGSize)newSize;

#pragma mark - 获取圆角图片
/**
 根据图片生成圆形图：适合正方形图(Core Graphics)
 
 @return <#return value description#>
 */
- (UIImage *)addRoundCorner;

/**
 根据图片生成圆形图(UIBezierPath+Core Graphics)
 
 @return <#return value description#>
 */
- (UIImage *)addRoundCornerWithBezierPath;

/**
 根据图片生成圆形图：可设置圆角半径
 
 @param cornerRadius 圆角半径
 @return <#return value description#>
 */
- (UIImage *)addRoundCornerWithBezierPath:(CGFloat)cornerRadius;

/**
 根据图片生成圆形图：可设置圆角半径、圆角位置
 
 @param corners 圆角位置
 @param cornerRadius 圆角半径
 @return <#return value description#>
 */
- (UIImage *)addRoundCornerWithBezierPath:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

/**
 根据图片生成圆形图：可设置圆角半径、圆角位置
 
 @param corners 圆角位置
 @param cornerRadii 圆角半径的CGSize
 @return <#return value description#>
 */
- (UIImage *)addRoundCornerWithBezierPath:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end


