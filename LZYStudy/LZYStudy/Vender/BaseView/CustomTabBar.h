//
//  CustomTabBar.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/30.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTabBar;

NS_ASSUME_NONNULL_BEGIN

@protocol CustomTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickCenterButton:(CustomTabBar *)tabBar;

@end


@interface CustomTabBar : UITabBar

@property (nonatomic, weak) id<CustomTabBarDelegate> tabBarDelegate;

- (void)addCenterButton;
/**
 *  调整中间按钮位置
 */
- (void)refreshCenterButton;

/**
 *  显示小红点
 *
 *  @param index <#index description#>
 */
- (void)showBadgeOnItemIndex:(NSInteger)index;

/**
 *  隐藏小红点
 *
 *  @param index <#index description#>
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index;


@end


NS_ASSUME_NONNULL_END
