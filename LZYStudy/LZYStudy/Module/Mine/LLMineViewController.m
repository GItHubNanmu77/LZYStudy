//
//  LLMineViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLMineViewController.h"

#import "LLLoginViewController.h"
#import "AppDelegate.h"
#import "LZYCustomBaseNavigationViewController.h"
#import "LLPdfReaderViewController.h"

@interface LLMineViewController ()
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation LLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.nextButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.loginButton.frame = CGRectMake((self.view.width - 80)/2, self.view.height - 220, 80, 40);
    self.nextButton.frame = CGRectMake((self.view.width - 80)/2,  220, 80, 40);
}


- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = ({
            @LZY_weakify(self)
            UIButton *button = [[UIButton alloc] init];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(17.0);
            [button setTitleColor:RGB3(51) forState:UIControlStateNormal];
            [button setTitle:@"退出" forState:UIControlStateNormal];
            [button setBackgroundColor:RGB3(255)];
            button.layer.cornerRadius = 4;
            [button bk_addEventHandler:^(id sender) {
                @LZY_strongify(self)
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LLLoginViewController *loginVC = [[LLLoginViewController alloc]init];
                LZYCustomBaseNavigationViewController *loginNav = [[LZYCustomBaseNavigationViewController alloc] initWithRootViewController:loginVC];
                [appDelegate.window setRootViewController:loginNav];
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _loginButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = ({
            @LZY_weakify(self)
            UIButton *button = [[UIButton alloc] init];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(17.0);
            [button setTitleColor:RGB3(51) forState:UIControlStateNormal];
            [button setTitle:@"下一页" forState:UIControlStateNormal];
            [button setBackgroundColor:RGB3(123)];
            button.layer.cornerRadius = 4;
            [button bk_addEventHandler:^(id sender) {
                @LZY_strongify(self)
                LLPdfReaderViewController *vc = [[LLPdfReaderViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _nextButton;
}

@end
