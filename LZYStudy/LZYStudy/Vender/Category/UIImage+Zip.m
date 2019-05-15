//
//  UIImage+Zip.m
//  AcneTreatment
//
//  Created by Facebook on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "UIImage+Zip.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation UIImage (Zip)

#pragma mark - 获取图片
/**
 获取指定路径的图片
 
 @param name 图片名称
 @param bundleName bundleName
 @param resizable 是否拉伸
 @return 图片
 */
- (UIImage *)getImageWithPath:(NSString *)name bundleName:(NSString *)bundleName resizable:(BOOL)resizable {
    if (name.length == 0) {
        return nil;
    }
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [mainBundle URLForResource:bundleName withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    UIImage *image = [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
    
    if (resizable) {
        image = [self resizableImage:image];
    }
    
    return image;
}


/**
 根据颜色和大小生成图片
 
 @param color 图片颜色
 @param size 图片大小
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) {
        return nil;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 填充
/**
 *  同比填充
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)aspectFill:(CGSize)size {
    return [self aspectFill:size offset:0];
}

/**
 *  同比填充
 *
 *  @param size   <#size description#>
 *  @param offset <#offset description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)aspectFill:(CGSize)size offset:(CGFloat)offset {
    int W = size.width;
    int H = size.height;
    int W0 = self.size.width;
    int H0 = self.size.height;
    
    CGImageRef imageRef = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4 * W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight) {
        W = size.height;
        H = size.width;
        W0 = self.size.height;
        H0 = self.size.width;
    }
    
    double ratio = MAX(W / (double)W0, H / (double)H0);
    W0 = ratio * W0;
    H0 = ratio * H0;
    
    int dW = abs((W0 - W) / 2);
    int dH = abs((H0 - H) / 2);
    
    if (dW == 0) {
        dH += offset;
    }
    
    if (dH == 0) {
        dW += offset;
    }
    
    if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored) {
        CGContextRotateCTM(bitmap, M_PI / 2);
        CGContextTranslateCTM(bitmap, 0, -H);
    } else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored) {
        CGContextRotateCTM(bitmap, -M_PI / 2);
        CGContextTranslateCTM(bitmap, -W, 0);
    } else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored) {
        // Nothing
    } else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored) {
        CGContextTranslateCTM(bitmap, W, H);
        CGContextRotateCTM(bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(-dW, -dH, W0, H0), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}


#pragma mark - 缩放
/**
 *  等比例缩放
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)zoom:(CGSize)size {
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= size.width && height <= size.height) {
        // no need to compress.
        return self;
    }
    
    if (width == 0 || height == 0) {
        // void zero exception
        return self;
    }
    
    UIImage *newImage = nil;
    CGFloat widthFactor = size.width / width;
    CGFloat heightFactor = size.height / height;
    CGFloat scaleFactor = 0.0;
    
    if (widthFactor > heightFactor) {
        scaleFactor = heightFactor; // scale to fit height
    } else {
        scaleFactor = widthFactor; // scale to fit width
    }
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize newtargetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(newtargetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - 压缩
/**
 *  压缩
 *
 *  @param compressionQuality 0.0 ≤ t ≤ 1.0
 *
 *  @return <#return value description#>
 */
- (NSData *)compressedData:(CGFloat)compressionQuality {
    assert(compressionQuality <= 1.0 && compressionQuality >= 0.0);
    return UIImageJPEGRepresentation(self, compressionQuality);
}

/**
 *  将图片压缩到指定宽度
 */
- (UIImage *)jkr_compressWithWidth:(CGFloat)width {
    if (width <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) return nil;
    CGSize newSize = CGSizeMake(width, width * (self.size.height / self.size.width));
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  将图片在子线程中压缩，block在主线层回调，保证压缩到指定文件大小，尽量减少失真
 */
- (void)jkr_compressToDataLength:(NSInteger)length withBlock :(void (^)(NSData *))block {
    if (length <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) block(nil);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *newImage = [self copy];
        {
            CGFloat scale = 0.9;
            NSData *pngData = UIImagePNGRepresentation(self);
            NSLog(@"Original pnglength %zd", pngData.length);
            NSData *jpgData = UIImageJPEGRepresentation(self, scale);
            NSLog(@"Original jpglength %zd", pngData.length);
            
            while (jpgData.length > length) {
                newImage = [newImage jkr_compressWithWidth:newImage.size.width * scale];
                NSData *newImageData = UIImageJPEGRepresentation(newImage, 0.0);
                if (newImageData.length < length) {
                    CGFloat scale = 1.0;
                    newImageData = UIImageJPEGRepresentation(newImage, scale);
                    while (newImageData.length > length) {
                        scale -= 0.1;
                        newImageData = UIImageJPEGRepresentation(newImage, scale);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Result jpglength %zd", newImageData.length);
                        block(newImageData);
                    });
                    return;
                }
            }
            
            block(jpgData);
        }
    });
}

/**
 *  尽量将图片压缩到指定大小，不一定满足条件
 */
- (void)jkr_tryCompressToDataLength:(NSInteger)length withBlock:(void (^)(NSData *))block {
    if (length <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) block(nil);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGFloat scale = 0.9;
        NSData *scaleData = UIImageJPEGRepresentation(self, scale);
        while (scaleData.length > length) {
            scale -= 0.1;
            if (scale < 0) {
                break;
            }
            NSLog(@"%f", scale);
            scaleData = UIImageJPEGRepresentation(self, scale);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(scaleData);
        });
    });
}

/**
 *  快速将图片压缩到指定大小，失真严重
 */
- (void)jkr_fastCompressToDataLength:(NSInteger)length withBlock:(void (^)(NSData *))block {
    if (length <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) block(nil);
    CGFloat scale = 1.0;
    UIImage *newImage = [self copy];
    NSInteger newImageLength = UIImageJPEGRepresentation(newImage, 1.0).length;
    while (newImageLength > length) {
        NSLog(@"Do compress");
        // 如果限定的大小比当前的尺寸大0.9的平方倍，就用开方求缩放倍数,减少缩放次数
        if ((double)length / (double)newImageLength < 0.81) {
            scale = sqrtf((double)length / (double)newImageLength);
        } else {
            scale = 0.9;
        }
        CGFloat width = newImage.size.width * scale;
        newImage = [newImage jkr_compressWithWidth:width];
        newImageLength = UIImageJPEGRepresentation(newImage, 1.0).length;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        block(UIImageJPEGRepresentation(newImage, 1.0));
    });
}


/**
 * 拉伸图片：边角不拉伸
 */
- (UIImage *)resizableImage:(UIImage *)image {
    return image ? [image stretchableImageWithLeftCapWidth:image.size.width / 2.0 topCapHeight:image.size.height / 2.0] : nil;
}


#pragma mark - 图片转正
/**
 *  图片转正
 *
 *  @return <#return value description#>
 */
- (UIImage *)fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 重新绘制图片
/**
 重新绘制图片
 
 @param newSize 需要重新绘制的尺寸
 @return <#return value description#>
 */
- (UIImage *)imageWithNewSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - 获取圆角图片
- (UIImage *)addRoundCorner {
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将图片画上
    [self drawInRect:rect];
    UIImage *roundCornerImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return roundCornerImage;
}

- (UIImage *)addRoundCornerWithBezierPath {
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 设置裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
    [path addClip];
    // 绘制图片
    [self drawAtPoint:CGPointZero];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)addRoundCornerWithBezierPath:(CGFloat)cornerRadius {
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 设置裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height) cornerRadius:(CGFloat)cornerRadius];
    [path addClip];
    // 绘制图片
    [self drawAtPoint:CGPointZero];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)addRoundCornerWithBezierPath:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius {
    CGSize size = CGSizeMake(cornerRadius, cornerRadius);
    return [self addRoundCornerWithBezierPath:corners cornerRadii:size];
}

- (UIImage *)addRoundCornerWithBezierPath:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 设置裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height) byRoundingCorners:corners cornerRadii:cornerRadii];
    [path addClip];
    // 绘制图片
    [self drawAtPoint:CGPointZero];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
