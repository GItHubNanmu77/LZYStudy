//
//  LLRegisterViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/8/8.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLRegisterViewController.h"
#import "LZYGCDTimer.h"

@interface LLRegisterViewController ()

@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,assign) __block int timeout;
@end

@implementation LLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.codeButton];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT);
    self.codeButton.frame = CGRectMake(80, 100, 200, 50);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    LZYGCDTimer *timer = [LZYGCDTimer shareLZYGCDTimer];
    int temp = timer.timeout;
    if (temp >0) {
        self.timeout= temp;//倒计时时间
        [self startTimer];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timeout >0) {
        LZYGCDTimer *timer = [LZYGCDTimer shareLZYGCDTimer];
        if (timer.timeout == 0) {
            timer.timeout = self.timeout;
            [timer countDown];
        }
        _timeout = 0;//置为0，释放controller
    }
}



- (void)buttonAction:(UIButton *)sender {
    
    self.timeout = 60;
    [self startTimer];
}

- (void)startTimer {
    
    @LZY_weakify(self)
    int allTime = _timeout;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, (uint64_t)(1.0* NSEC_PER_SEC), 0);
    
    dispatch_source_set_event_handler(self.timer, ^{
        @LZY_strongify(self)
        
        if (self.timeout <= 0) {
            dispatch_source_cancel(self.timer);
            self.timer = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.codeButton.backgroundColor = [UIColor redColor];
                self.codeButton.enabled = YES;
            });
        } else {
            int seconds = self.timeout % (allTime + 1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:[NSString stringWithFormat:@"%.2d秒", seconds] forState:UIControlStateNormal];
                self.codeButton.backgroundColor = [UIColor grayColor];
                self.codeButton.enabled = NO;
            });
            self.timeout--;
        }
    });
    dispatch_resume(self.timer);
}


- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(17.0);
            [button setTitleColor:RGB3(255) forState:UIControlStateNormal];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor redColor]];
            button.layer.cornerRadius = 4;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _codeButton;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT * 1.7);
        _scrollView.backgroundColor = [UIColor whiteColor];
        
    }
    return _scrollView;
}
@end
