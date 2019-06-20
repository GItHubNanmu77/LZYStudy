//
//  LLCustomTabBarController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLCustomTabBarController.h"
#import "LZYMacro.h"
#import "LLHomeViewController.h"
#import "LLMessageViewController.h"
#import "LLMineViewController.h"
#import "LLDynamicViewController.h"
#import "LLPublishViewController.h"
#import "LZYCustomBaseNavigationViewController.h"

#import "LLShopListViewController.h"
#import "LLLayoutListViewController.h"
#import "LLAnimationListViewController.h"

@interface LLCustomTabBarController ()

@property (nonatomic, assign) BOOL isManager;

@end

@implementation LLCustomTabBarController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    // 导航栏样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // 安装 ViewControllers
    [self setupViewControllers];
    // 设置自定义tabbar
    [self setupCustomizeTabBar];
    
    
    // 收到IM消息是否显示红点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageRedDotNotification:) name:@"MESSAGE_REDDOT" object:nil];
}

#pragma mark - Private Method
/**
 *  设置 控制器数组
 */
- (void)setupViewControllers {
    // 首页
//    LLHomeViewController *homeVC = [[LLHomeViewController alloc] init];
    LLShopListViewController *homeVC = [[LLShopListViewController alloc] init];
    LZYCustomBaseNavigationViewController *homeNav = [[LZYCustomBaseNavigationViewController alloc] initWithRootViewController:homeVC];
    [homeNav showFPSLable];
    
    // 消息
//    LLMessageViewController *messageVC = [[LLMessageViewController alloc] init];
    LLLayoutListViewController *messageVC = [[LLLayoutListViewController alloc] init];
    LZYCustomBaseNavigationViewController *messageNav = [[LZYCustomBaseNavigationViewController alloc] initWithRootViewController:messageVC];
    [messageNav showFPSLable];
    
    // 动态
//    LLDynamicViewController *dynanmicVC = [[LLDynamicViewController alloc] init];
    LLAnimationListViewController *dynanmicVC = [[LLAnimationListViewController alloc] init];
    LZYCustomBaseNavigationViewController *dynanmicNav = [[LZYCustomBaseNavigationViewController alloc] initWithRootViewController:dynanmicVC];
    [dynanmicNav showFPSLable];
    
    // 我的
    LLMineViewController *mineVC = [[LLMineViewController alloc] init];
    LZYCustomBaseNavigationViewController *mineNav = [[LZYCustomBaseNavigationViewController alloc] initWithRootViewController:mineVC];
    [mineNav showFPSLable];
    
    self.viewControllers = @[homeNav, messageNav, dynanmicNav, mineNav];
}


/**
 *  自定义 TabBar
 */
- (void)setupCustomizeTabBar {
    // 背景图片
    //self.qzTabBar.barTintColor = [UIColor colorWithPatternImage:[[YTSkinUtils shareInstance] getImageWithNameByTheme:@"Root/TabBar_Background"]];
    self.cusTabBar.backgroundColor = [UIColor whiteColor];
    
    // 文字、图标
    NSArray *itemTitleArray = @[@"首页", @"消息", @"动态", @"我的"];
    NSArray *itemImageNameArray = @[@"Home", @"Message", @"Dynamic", @"My"];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger index = 0; index < itemTitleArray.count; index++) {
        NSString *title = itemTitleArray[index];
        NSString *normalImagePath = [NSString stringWithFormat:@"%@_Normal", itemImageNameArray[index]];
        UIImage *normalImage = [UIImage imageNamed:normalImagePath];
        NSString *highlightedImagePath = [NSString stringWithFormat:@"%@_Highlighted", itemImageNameArray[index]];
        UIImage *highlightedImage = [UIImage imageNamed:highlightedImagePath];
        [items addObject:@{ @"Title": title, @"Image": normalImage, @"SelectedImage": highlightedImage }];
    }
    
    [self setupTabBarItem:items translucent:YES];
    
    // 字体
    UIFont *font = LZY_FONT_FROM_NAME_SIZE(11.0);
    [self setNormalFont:font];
    [self setSelectedFont:font];
    
    // 默认颜色
    UIColor *normanlColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    [self setNormalColor:normanlColor];
    
    // 选中颜色
    UIColor *selectedColor = RGBA(24, 129, 247, 1);
    [self setSelectedColor:selectedColor];
    
    [self.cusTabBar addCenterButton];
    // 调整凸出按钮和小红点的位置
    [self.cusTabBar refreshCenterButton];
}

#pragma mark - NSNotification
- (void)refreshMessageRedDotNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isShowRedNot = [notification.object boolValue];
        if (isShowRedNot) {
            [self setupBadgeValue:1];
        } else {
            [self removeBadgeValue:1];
        }
    });
}

- (void)tabBarDidClickCenterButton:(CustomTabBar *)tabBar {
    LLPublishViewController *vc = [[LLPublishViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [[self currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
    
}

- (UINavigationController *)currentTabbarSelectedNavigationController
{
    NSArray *arr =[UIApplication sharedApplication].windows;
    NSLog(@"windows -- %@",arr);
    UIViewController *tabbarController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)tabbarController;
        UINavigationController *selectedNV = (UINavigationController *)tabVC.selectedViewController;
        if ([selectedNV isKindOfClass:[UINavigationController class]]) {
            return selectedNV;
        }
    }
    return nil;
}
/**
 *  获取最上层的控制器
 *
 *  @return <#return value description#>
 */
- (UIViewController *)mostTopViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
