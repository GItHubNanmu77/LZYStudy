//
//  UIView+Frame.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/19.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

// Position
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

/// 视图左边，相当于x
@property (nonatomic, assign) CGFloat left;
/// 视图右边位置
@property (nonatomic, assign) CGFloat right;
/// 视图顶部位置，相当于y
@property (nonatomic, assign) CGFloat top;
/// 视图底部位置
@property (nonatomic, assign) CGFloat bottom;

/// center.x
@property (nonatomic, assign) CGFloat centerX;
/// center.y
@property (nonatomic, assign) CGFloat centerY;

@end

NS_ASSUME_NONNULL_END
