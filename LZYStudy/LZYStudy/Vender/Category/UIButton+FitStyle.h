//
//  UIButton+FitStyle.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/15.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (FitStyle)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

-(void)loginStyle;

//上下居中，图片在上，文字在下
- (void)verticalCenterImageAndTitle:(CGFloat)spacing;
- (void)verticalCenterImageAndTitle; //默认6.0

//左右居中，文字在左，图片在右
- (void)horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImage; //默认6.0

//左右居中，图片在左，文字在右
- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
- (void)horizontalCenterImageAndTitle; //默认6.0

//文字居中，图片在左边
- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageLeft; //默认6.0

//文字居中，图片在右边
- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageRight; //默认6.0
- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing centerOffset:(CGFloat)offset;

@end

 

NS_ASSUME_NONNULL_END
