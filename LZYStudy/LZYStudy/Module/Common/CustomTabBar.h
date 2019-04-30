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

- (void)tabBarDidClickPlusButton:(CustomTabBar *)tabBar;

@end


@interface CustomTabBar : UITabBar

@property (nonatomic, weak) id<CustomTabBarDelegate> tabBarDelegate;



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
