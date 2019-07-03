//
//  LZYCustomBaseNavigationViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYCustomBaseNavigationViewController.h"
#import "LZYMacro.h"
#import "FPSLabel.h"

@interface LZYCustomBaseNavigationViewController ()

#if DEBUG
@property (nonatomic, strong) FPSLabel *lb_fps;
#endif

/// 自定义返回按钮
@property (nonatomic, strong) UIBarButtonItem *customBack;

@end

@implementation LZYCustomBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义返回按钮
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:nil];
    UIImage *navBackImage = [UIImage imageNamed:@"Nav_Back_Icon"];
    navBackImage = [navBackImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationBar.backIndicatorImage = navBackImage;
    self.navigationBar.backIndicatorTransitionMaskImage = navBackImage;
    
    // 背景
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.navigationBar.frame.size.width, LZY_IOS_VERSION >= 7.0 ? 64.0 : 44.0)];
    [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // 修改标题色
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    // 自定义返回按钮文字
    self.customBack = [[UIBarButtonItem alloc] initWithImage:[[UIImage alloc] init] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 刷新返回按钮
    for (UIViewController *viewController in self.viewControllers) {
        viewController.navigationItem.backBarButtonItem = nil;
        viewController.navigationItem.backBarButtonItem = self.customBack;
        viewController.navigationController.navigationBar.backIndicatorTransitionMaskImage = navBackImage;
        viewController.navigationController.navigationBar.backIndicatorImage = navBackImage;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    viewController.navigationItem.backBarButtonItem = self.customBack;
    
    // 修改tabBar的frame（解决iPhone X push的时候tabBar上移）
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}


#if DEBUG

- (void)showFPSLable
{
    self.lb_fps.hidden = NO;
}

- (void)hiddenFPSLable
{
    self.lb_fps.hidden = YES;
}

#pragma mark - Getter

- (FPSLabel *)lb_fps {
    if (!_lb_fps) {
        _lb_fps = [[FPSLabel alloc] initWithFrame:CGRectMake(60, 0, 80, 40)];
        [self.view addSubview:_lb_fps];
    }
    return _lb_fps;
}

#endif
@end
