//
//  LZYCommonTipView.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYCommonTipView.h"
#import "LZYMacro.h"

@interface LZYCommonTipView ()

/// 图片
@property (nonatomic, strong) UIImageView *animationImageView;
/// 文字
@property (nonatomic, strong) UILabel *tipsLabel;
/// 按钮
@property (nonatomic, strong) UIButton *actionButton;
/// 事件
@property (nonatomic, copy, nullable) ButtonActionBlock buttonActionBlock;
/// 样式
@property (nonatomic, assign) SDQZTipsViewStyle viewStyle;

@end

@implementation LZYCommonTipView

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewStyle:SDQZTipsViewNoDataStyle];
}

- (instancetype)initWithFrame:(CGRect)frame viewStyle:(SDQZTipsViewStyle)viewStyle {
    return [self initWithFrame:frame viewStyle:viewStyle buttonAction:nil];
}

- (instancetype)initWithFrame:(CGRect)frame viewStyle:(SDQZTipsViewStyle)viewStyle buttonAction:(ButtonActionBlock)buttonAction {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        self.buttonActionBlock = buttonAction;
        self.viewStyle = viewStyle;
        
        switch (self.viewStyle) {
            case SDQZTipsViewNoDataStyle: {
                [self setupAnimationImageView:@"Tips_NoData"];
                [self setupTipsLabel];
                self.userInteractionEnabled = NO;
            } break;
            case SDQZTipsViewErrorStyle: {
                [self setupAnimationImageView:@"Tips_Error"];
                [self setupTipsLabel];
                self.userInteractionEnabled = NO;
            } break;
            case SDQZTipsViewLoginStyle: {
                [self setupAnimationImageView:@"Tips_Network"];
                [self setupTipsLabel];
                [self setupActionButton];
                self.userInteractionEnabled = YES;
            } break;
        }
    }
    return self;
}

- (void)show {
    [self show:nil];
}

- (void)show:(NSString *)tipsText {
    [self show:tipsText btnTitle:nil];
}

- (void)show:(NSString *)tipsText btnTitle:(NSString *)btnTitle {
    self.animationImageView.x = (self.width - self.animationImageView.width) / 2;
    self.animationImageView.y = (self.height - self.animationImageView.height) / 2 - LZY_IPHONE_NAV_STATUS_HEIGHT;
    
    self.tipsLabel.text = tipsText;
    [self.tipsLabel sizeToFit];
    self.tipsLabel.x = (self.width - self.tipsLabel.width) / 2;
    self.tipsLabel.y = self.animationImageView.bottom + 15.0;
    
    if (self.viewStyle == SDQZTipsViewLoginStyle) {
        [self.actionButton setTitle:@"登录" forState:UIControlStateNormal];
        self.actionButton.frame = CGRectMake((self.width - 200.0) / 2, self.tipsLabel.bottom + 15.0, 200.0, 40.0);
    }
    
    [self.superview bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.00
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.00
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self.animationImageView removeFromSuperview];
                         self.animationImageView = nil;
                         [self.tipsLabel removeFromSuperview];
                         self.tipsLabel = nil;
                         if (self.actionButton) {
                             [self.actionButton removeFromSuperview];
                             self.actionButton = nil;
                         }
                         
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Private Methods
- (void)setupAnimationImageView:(NSString *)imagePath {
    self.animationImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.animationImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.animationImageView.image = [UIImage imageNamed:imagePath];
    [self.animationImageView setWidth:self.animationImageView.image.size.width];
    [self.animationImageView setHeight:self.animationImageView.image.size.height];
    [self addSubview:self.animationImageView];
}

- (void)setupTipsLabel {
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, self.width - 60.0, 0.0)];
    self.tipsLabel.backgroundColor = [UIColor clearColor];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.font = [UIFont systemFontOfSize:15.0];
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.textColor = RGB3(102);
    [self addSubview:self.tipsLabel];
}

- (void)setupActionButton {
    if (self.actionButton) {
        return;
    }
    self.actionButton = [self setupActionButton:100];
    [self addSubview:self.actionButton];
}

- (UIButton *)setupActionButton:(NSInteger)btnTag {
    @LZY_weakify(self)
    UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectZero];
    actionButton.tag = btnTag;
    actionButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [actionButton setTitleColor:RGB(24, 129, 247) forState:UIControlStateNormal];
    actionButton.layer.borderWidth = 1;
    actionButton.layer.borderColor = RGB(24, 129, 247).CGColor;
    [actionButton bk_addEventHandler:^(id sender) {
        @LZY_strongify(self)
        if (self.buttonActionBlock) {
            self.buttonActionBlock(btnTag);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return actionButton;
}

@end
