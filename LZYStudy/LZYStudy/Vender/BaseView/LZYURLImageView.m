//
//  LZYURLImageView.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/15.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYURLImageView.h"


@interface LZYURLImageView ()

/// 是否设置了网络图片
@property (nonatomic, assign) BOOL setUrlImageSucceed;
/// 默认图
@property (nonatomic, strong) UIImage *placeHolderImage;

@end

@implementation LZYURLImageView

- (instancetype)initWithFrame:(CGRect)frame placeHolderName:(NSString *)placeHolderName resizeable:(BOOL)resizeable imageUrl:(NSString *)imageUrl {
    return [self initWithFrame:frame placeHolderName:placeHolderName resizeable:resizeable cornerRadius:0.0 imageUrl:imageUrl];
}

- (instancetype)initWithFrame:(CGRect)frame placeHolderName:(NSString *)placeHolderName resizeable:(BOOL)resizeable cornerRadius:(CGFloat)cornerRadius imageUrl:(NSString *)imageUrl {
    self = [super initWithFrame:frame];
    if (self) {
        _resizeable = resizeable;
        _placeHolderName = [placeHolderName copy];
        _cornerRadius = cornerRadius;
        _imageUrl = [imageUrl copy];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame placeHolderName:(NSString *)placeHolderName resizeable:(BOOL)resizeable cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners imageUrl:(NSString *)imageUrl {
    self = [super initWithFrame:frame];
    if (self) {
        _resizeable = resizeable;
        _placeHolderName = [placeHolderName copy];
        _cornerRadius = cornerRadius;
        _corners = corners;
        _imageUrl = [imageUrl copy];
    }
    return self;
}

- (void)getPlaceHolderImage {
//    UIImage *image = LZY_IMAGE_FROM_PATH(_placeHolderName);
    UIImage *image = [UIImage imageNamed:_placeHolderName];
    if (image) {
        if (_resizeable) {
            _placeHolderImage = [image stretchableImageWithLeftCapWidth:image.size.width / 2.0 topCapHeight:image.size.height / 2.0];
        } else {
            _placeHolderImage = image;
        }
    } else {
        _placeHolderImage = nil;
    }
}

/**
 根据地址设置图片
 
 @param imageUrl 图片地址
 */
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    @LZY_weakify(self)
    [self getPlaceHolderImage];
    self.setUrlImageSucceed = NO;
    self.alpha = 1.0; // cell的复用 导致透明度也会被复用出问题
    
//    UIImage *cacheImage = [[[SDWebImageManager sharedManager] imageCache] imageFromMemoryCacheForKey:imageUrl];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageUrl];
    if (cacheImage) {
        self.image = cacheImage;
        return;
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:_placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @LZY_strongify(self)
            
            __block UIImage *tempImage = image;
            
            @synchronized(self) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    if (self.cornerRadius > 0) {
                        tempImage = [tempImage addRoundCornerWithBezierPath:self.cornerRadius];
                    } else if (self.cornerRadius > 0 && self.corners) {
                        tempImage = [tempImage addRoundCornerWithBezierPath:self.corners cornerRadius:self.cornerRadius];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (tempImage) {
                            self.setUrlImageSucceed = YES;
                            if (self.loadSuccessedBlock) {
                                self.loadSuccessedBlock(tempImage);
                            } else {
                                self.image = tempImage;
                            }
                        }
                        
                        // 重新绘制后的图片更新缓存
                        if (self.cornerRadius > 0 || (self.cornerRadius > 0 && self.corners)) {
                            NSString *keyUrl = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
//                            [[[SDWebImageManager sharedManager] imageCache] storeImage:self.image forKey:keyUrl toDisk:NO completion:nil];
                            [[SDImageCache sharedImageCache] storeImage:self.image forKey:keyUrl toDisk:NO completion:nil];
                        }
                    });
                });
            }
        }];
    }
}

@end
