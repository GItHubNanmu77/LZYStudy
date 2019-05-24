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
#import "UITextView+Placeholder.h"

@interface LLHomeViewController ()
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation LLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.textView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.textView.frame = CGRectMake(0, LZY_IPHONE_NAV_HEIGHT, LZY_SCREEN_WIDTH, 300);
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

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [_textView setPlaceholder:@"请输入" placeholdColor:[UIColor grayColor]];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor blueColor];
    }
    return _textView;
}

@end
