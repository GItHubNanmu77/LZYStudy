//
//  DoubleSliderView.h
//  DoubleSliderView-OC
//
//  Created by 杜奎 on 2019/1/13.
//  Copyright © 2019 DU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleSliderView : UIView

@property (nonatomic, assign) NSInteger minValue;//最大值
@property (nonatomic, assign) NSInteger maxValue;//最小值

@property (nonatomic, assign) NSInteger curMinValue;//当前最大值
@property (nonatomic, assign) NSInteger curMaxValue;//当前最小值

@property (nonatomic, assign) CGFloat curMinValuePercent;//当前最小的值百分比
@property (nonatomic, assign) CGFloat curMaxValuePercent;//当前最大的值百分比
@property (nonatomic, assign) BOOL needAnimation;//是否需要动画
@property (nonatomic, assign) CGFloat minInterval;//间隔大小
@property (nonatomic, copy)   void (^sliderBtnLocationChangeBlock)(BOOL isLeft, BOOL finish);//滑块位置改变后的回调 isLeft 是否是左边 finish手势是否结束

@property (nonatomic, strong) UIColor *minTintColor;
@property (nonatomic, strong) UIColor *midTintColor;
@property (nonatomic, strong) UIColor *maxTintColor;

- (void)changeLocationFromValue;

@end

