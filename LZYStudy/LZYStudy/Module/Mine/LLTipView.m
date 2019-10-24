//
//  LLTipView.m
//  LZYReactiveCocoaStudy
//
//  Created by cisdi on 2019/7/10.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLTipView.h"


@interface LLTipView ()
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) UIView *backView;
@end

@implementation LLTipView
- (void)dealloc {
    NSLog(@"销毁");
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor cyanColor];
        
        [self addSubview:self.backView];
        [self.backView addSubview:self.btnConfirm];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
      
    }
    return self;
}

+ (instancetype)shareView {
    UIView *tipView = [[NSBundle mainBundle] loadNibNamed:@"LLTipView" owner:self options:nil].firstObject;
    return tipView;
}

- (UIButton *)btnConfirm {
    if (!_btnConfirm) {
        _btnConfirm = ({
            @LZY_weakify(self)
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"确认" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor redColor]];
            button.layer.cornerRadius = 4;
            [button bk_addEventHandler:^(id sender) {
                @LZY_strongify(self)
                [self btnConfirmAction];
                [self dismiss];
            } forControlEvents:UIControlEventTouchUpInside];
//            [button addTarget:self action:@selector(btnConfirmAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _btnConfirm;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            view;
        });
    }
    return _backView;
}
- (void)btnConfirmAction {
    NSLog(@"按钮点击");
}
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)dismiss {
    [self.btnConfirm removeFromSuperview];
    [self removeFromSuperview];
    self.btnConfirm = nil;
    
}
@end
