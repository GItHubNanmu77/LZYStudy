//
//  UIView+Frame.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/19.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect temp = self.frame;
    temp.size.height = height;
    self.frame = temp;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect temp = self.frame;
    temp.size.width = width;
    self.frame = temp;
}


- (CGFloat)y {
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)y {
    CGRect temp = self.frame;
    temp.origin.y = y;
    self.frame = temp;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x {
    CGRect temp = self.frame;
    temp.origin.x = x;
    self.frame = temp;
}


#pragma mark - Left Position of the view
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}


- (CGFloat)left {
    return self.frame.origin.x;
}


#pragma mark - Right position of the view
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x += right;
    self.frame = frame;
}


- (CGFloat)right {
    return self.frame.size.width + self.frame.origin.x;
}


#pragma mark - Top Position of the view
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


- (CGFloat)top {
    return self.frame.origin.y;
}


#pragma mark - Bottom Posiition of the view
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y += bottom;
    self.frame = frame;
}


- (CGFloat)bottom {
    return self.frame.size.height + self.frame.origin.y;
}


#pragma mark-- center.x
- (void)setCenterX:(CGFloat)centerX {
    CGPoint tmpCenter = self.center;
    tmpCenter.x = centerX;
    self.center = tmpCenter;
}

- (CGFloat)centerX {
    return self.center.x;
}

#pragma mark-- center.y
- (void)setCenterY:(CGFloat)centerY {
    CGPoint tmpCenter = self.center;
    tmpCenter.y = centerY;
    self.center = tmpCenter;
}

- (CGFloat)centerY {
    return self.center.y;
}
@end
