//
//  LLLoginViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLLoginViewController.h"
#import "LLCustomTabBarController.h"
#import "AppDelegate.h"

@interface LLLoginViewController ()
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *managerButton;

@end

@implementation LLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.managerButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.loginButton.frame = CGRectMake((self.view.width - 80)/2, self.view.height - 220, 120, 40);
    self.managerButton.frame = CGRectMake((self.view.width - 80)/2, self.loginButton.bottom + 10, 80, 40);
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = ({
            @LZY_weakify(self)
            UIButton *button = [[UIButton alloc] init];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(17.0);
            [button setTitleColor:RGB3(51) forState:UIControlStateNormal];
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button setBackgroundColor:RGB3(255)];
            button.layer.cornerRadius = 4;
            [button bk_addEventHandler:^(id sender) {
                @LZY_strongify(self)
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] setValue:@(self.managerButton.selected) forKey:@"isManager"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LLCustomTabBarController *tabVC = [[LLCustomTabBarController alloc] init];
                appDelegate.window.rootViewController = tabVC;

            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _loginButton;
}

- (UIButton *)managerButton {
    if (!_managerButton) {
        _managerButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(17.0);
            [button setTitleColor:RGB3(255) forState:UIControlStateNormal];
            [button setTitle:@"职员" forState:UIControlStateNormal];
            [button setTitle:@"管理员" forState:UIControlStateSelected];
            [button setBackgroundColor:RGB(24, 197, 247)];
            button.layer.cornerRadius = 4;
            [button bk_addEventHandler:^(UIButton *sender) {
                sender.selected = !sender.selected;
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _managerButton;
}
@end
