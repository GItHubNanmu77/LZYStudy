//
//  CustomBaseTabBarController.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/30.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomBaseTabBarController : UITabBarController

/// TabBarItem 文字默认字体
@property (nonatomic, strong) UIFont *normalFont;
/// TabBarItem 文字选中字体
@property (nonatomic, strong) UIFont *selectedFont;
/// TabBarItem 文字默认颜色
@property (nonatomic, strong) UIColor *normalColor;
/// TabBarItem 文字选中颜色
@property (nonatomic, strong) UIColor *selectedColor;
/// tabBar
@property (nonatomic, strong) CustomTabBar *cusTabBar;

/**
 *  设置 TabBarItem
 *
 *  @param items       数组
 *  @param translucent 图标 tintColor 是否透明
 */
- (void)setupTabBarItem:(NSArray *)items translucent:(BOOL)translucent;

/**
 *  设置 小红点
 *
 *  @param index 第几个 TabBarItem
 */
- (void)setupBadgeValue:(NSInteger)index;

/**
 *  设置 badgeValue
 *
 *  @param index      第几个 TabBarItem
 *  @param badgeValue 值
 */
- (void)setupBadgeValue:(NSInteger)index badgeValue:(NSString *)badgeValue;

/**
 *  移除 badgeValue | 小红点
 *
 *  @param index 第几个 TabBarItem
 */
- (void)removeBadgeValue:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
