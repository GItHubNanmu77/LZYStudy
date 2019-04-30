//
//  CustomTabBarController.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/30.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "CustomTabBarController.h"
#import "LZYMacro.h"


@interface CustomTabBarController () <CustomTabBarDelegate>

@end

@implementation CustomTabBarController

/**
 *  加载视图
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //分割线
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.3 alpha:1].CGColor);
    CGContextFillRect(context, rect);
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 自定义的tabBar替换掉系统自带的tabBar
    self.cusTabBar = [[CustomTabBar alloc] init];
    self.cusTabBar.tabBarDelegate = self;
    self.cusTabBar.backgroundImage = [[UIImage alloc] init];
    self.cusTabBar.shadowImage = shadowImage;
    [self setValue:self.cusTabBar forKey:@"tabBar"];
    
    // 默认字体
    self.normalFont = [UIFont systemFontOfSize:11.0];
    // 默认颜色
    self.normalColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    // 选中字体
    self.selectedFont = [UIFont systemFontOfSize:11.0];
    // 默认选中颜色
    self.selectedColor = [UIColor colorWithRed:0.00 green:0.40 blue:1.00 alpha:1.00];
}

/**
 *  设置 TabBarItem
 *
 *  @param items       数组
 *  @param translucent 图标 tintColor 是否透明
 */
- (void)setupTabBarItem:(NSArray *)items translucent:(BOOL)translucent {
    if (translucent) {
        // 图片选中颜色透明
        self.cusTabBar.tintColor = [UIColor clearColor];
    } else {
        // 图片选中颜色不透明
        self.cusTabBar.tintColor = [UIColor colorWithRed:0.00 green:0.40 blue:1.00 alpha:1.00];
    }
    
    NSInteger index = 0;
    for (UITabBarItem *item in self.cusTabBar.items) {
        if (index >= items.count) {
            break;
        }
        
        NSDictionary *dict = items[index];
        NSString *title = dict[@"Title"];
        UIImage *image = dict[@"Image"];
        UIImage *selectedImage = dict[@"SelectedImage"];
        
        [item setTitle:title];
        [item setImage:translucent ? [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : image];
        [item setSelectedImage:translucent ? [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : selectedImage];
        item.titlePositionAdjustment = UIOffsetMake(0.0, LZY_IS_IPHONEX ? 3.0 : -3.0);
        
        index++;
    }
}

/**
 *  设置 小红点
 *
 *  @param index 第几个 TabBarItem
 */
- (void)setupBadgeValue:(NSInteger)index {
    [self setupBadgeValue:index badgeValue:nil];
}

/**
 *  设置 badgeValue
 *
 *  @param index      第几个 TabBarItem
 *  @param badgeValue 值
 */
- (void)setupBadgeValue:(NSInteger)index badgeValue:(NSString *)badgeValue {
    if (index >= self.cusTabBar.items.count) {
        return;
    }
    
    if (badgeValue != nil) {
        // 隐藏 小红点
        [self.cusTabBar hideBadgeOnItemIndex:index];
        
        // 添加 badgeValue
        UITabBarItem *item = self.cusTabBar.items[index];
        item.badgeValue = badgeValue;
    } else {
        // 显示 小红点
        [self.cusTabBar showBadgeOnItemIndex:index];
    }
}

/**
 *  移除 badgeValue | 小红点
 *
 *  @param index 第几个 TabBarItem
 */
- (void)removeBadgeValue:(NSInteger)index {
    if (index >= self.cusTabBar.items.count) {
        return;
    }
    
    UITabBarItem *item = self.cusTabBar.items[index];
    item.badgeValue = nil;
    
    [self.cusTabBar hideBadgeOnItemIndex:index]; 
}

/**
 *  TabBarItem 文字默认字体
 *
 *  @param normalFont normalFont description
 */
- (void)setNormalFont:(UIFont *)normalFont {
    _normalFont = normalFont;
    
    [self setTabBarItemAttributes];
}

/**
 *  TabBarItem 文字选中字体
 *
 *  @param selectedFont <#selectedFont description#>
 */
- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    
    [self setTabBarItemAttributes];
}

/**
 *  TabBarItem 文字默认颜色
 *
 *  @param normalColor normalColor description
 */
- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    
    [self setTabBarItemAttributes];
}

/**
 *  TabBarItem 文字选中颜色
 *
 *  @param selectedColor <#selectedColor description#>
 */
- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    
    [self setTabBarItemAttributes];
}

/**
 *  设置 TabBarItem 字体与颜色
 */
- (void)setTabBarItemAttributes {
    for (UITabBarItem *item in self.cusTabBar.items) {
        [item setTitleTextAttributes:@{ NSFontAttributeName: self.normalFont, NSForegroundColorAttributeName: self.normalColor } forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{ NSFontAttributeName: self.selectedFont, NSForegroundColorAttributeName: self.selectedColor } forState:UIControlStateSelected];
    }
}

#pragma mark - SDcusTabBarDelegate
/**
 自定义按钮点击事件回调
 
 @param tabBar <#tabBar description#>
 */
- (void)tabBarDidClickPlusButton:(CustomTabBar *)tabBar {
    !self.clickPlusButtonBlock ?: self.clickPlusButtonBlock();
}

#pragma mark - UITabBarDelegate
/**
 底部tabBar item点击
 
 @param tabBar <#tabBar description#>
 @param item <#item description#>
 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}

@end

