//
//  UIButton+FitStyle.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/15.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "UIButton+FitStyle.h"
#import "UIImage+Zip.h"

#import <objc/runtime.h>

static CGFloat const DEFAULT_SPACING = 6.0f;

@implementation UIButton (FitStyle)


#pragma mark - public method

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor size:CGSizeMake(1, 1)] forState:state];
}

#pragma mark - Bootstrap
-(void)bootstrapStyle{
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)loginStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:114.0/255.0 blue:86.0/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:252.0/255.0 green:114.0/255.0 blue:86.0/255.0 alpha:0] CGColor];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:200/255.0 green:100/255.0 blue:100/255.0 alpha:1] size:self.bounds.size] forState:UIControlStateHighlighted];
}

#pragma mark - Customer Layout

- (void)verticalCenterImageAndTitle:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

- (void)verticalCenterImageAndTitle
{
    [self verticalCenterImageAndTitle:DEFAULT_SPACING];
}

- (void)horizontalCenterTitleAndImage:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, imageSize.width + spacing/2);
    
    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + spacing/2, 0.0, - titleSize.width);
}

- (void)horizontalCenterTitleAndImage
{
    [self horizontalCenterTitleAndImage:DEFAULT_SPACING];
}

- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
{
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,  0.0, 0.0,  - spacing/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing/2, 0.0, 0.0);
}

- (void)horizontalCenterImageAndTitle;
{
    [self horizontalCenterImageAndTitle:DEFAULT_SPACING];
}


- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;

    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, 0.0);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing, 0.0,  imageSize.width);
}

- (void)horizontalCenterTitleAndImageLeft
{
    [self horizontalCenterTitleAndImageLeft:DEFAULT_SPACING];
}

- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, 0.0);
    
    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + imageSize.width + spacing, 0.0, - titleSize.width);
}

- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing centerOffset:(CGFloat)offset
{
    CGSize imageSize = self.imageView.frame.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width + offset, 0.0, 0.0);
    
    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + imageSize.width + spacing + offset, 0.0, - titleSize.width);
}

- (void)horizontalCenterTitleAndImageRight
{
    [self horizontalCenterTitleAndImageRight:DEFAULT_SPACING];
}



@end
