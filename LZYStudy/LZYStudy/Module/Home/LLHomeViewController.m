//
//  LLHomeViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLHomeViewController.h"
#import "LLLoginViewController.h"
#import "AppDelegate.h"
#import "LZYCustomBaseNavigationViewController.h"

@interface LLHomeViewController ()
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation LLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.loginButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.loginButton.frame = CGRectMake((self.view.width - 80)/2, self.view.height - 220, 80, 40);
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
                NSString *str;
                NSDictionary *dic = @{@"str":str};
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

@end
