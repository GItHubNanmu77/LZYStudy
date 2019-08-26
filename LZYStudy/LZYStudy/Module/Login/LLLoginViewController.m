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
#import "LLRegisterViewController.h"
#import "NSString+Convert.h"

@interface LLLoginViewController ()
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *managerButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) NSMutableArray *firstArray;
@end

@implementation LLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.managerButton];
    [self.view addSubview:self.registerButton];
    
    self.firstArray = [NSMutableArray arrayWithArray:@[@"1",@"3",@"2"]];
    
   
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [SVProgressHUD setContainerView:nil];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [self.navigationController.navigationBar setHidden:NO];
    NSLog(@"---%@",self.firstArray);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     NSLog(@"---%@",self.firstArray);
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.managerButton.frame = CGRectMake((self.view.width - 80)/2, self.view.height - 220 + 10, 80, 40);
    self.loginButton.frame = CGRectMake(40, self.managerButton.bottom + 10, self.view.width - 80, 50);
    self.registerButton.frame = CGRectMake(40, self.loginButton.bottom + 10, self.view.width - 80, 50);
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
                [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0,0)];
                [SVProgressHUD show];
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _managerButton;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        @LZY_weakify(self)
        _registerButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(17.0);
            [button setTitleColor:RGB3(255) forState:UIControlStateNormal];
            [button setTitle:@"注册" forState:UIControlStateNormal];
            [button setBackgroundColor:RGB(24, 197, 247)];
            button.layer.cornerRadius = 4;
            [button bk_addEventHandler:^(UIButton *sender) {
                @LZY_strongify(self)
                LLRegisterViewController *vc = [[LLRegisterViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _registerButton;
}


@end
