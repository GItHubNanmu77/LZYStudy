//
//  UIImage+Zip.h
//  AcneTreatment
//
//  Created by Facebook on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Zip)
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
 根据颜色和大小生成图片
 
 @param color 图片颜色
 @param size 图片大小
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 拉伸图片：边角不拉伸
 
 @param image 图片
 @return 拉伸后的图片
 */
- (UIImage *)resizableImage:(UIImage *)image;


/**
 获取指定路径的图片
 
 @param name 图片名称
 @param bundleName bundleName
 @param resizable 是否拉伸
 @return 图片
 */
- (UIImage *)getImageWithPath:(NSString *)name bundleName:(NSString *)bundleName resizable:(BOOL)resizable;


@end
