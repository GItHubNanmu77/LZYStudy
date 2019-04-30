//
//  LZYConfirmView.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/30.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYConfirmView.h"

/// 按钮高度
static const CGFloat kButtonHeight = 44.0;
/// 内容区高度
static CGFloat _kContentViewHeight = 180.0;

@interface LZYConfirmView ()

/// 背景遮罩
@property (nonatomic, strong) UIView *coverView;
/// 内容视图
@property (nonatomic, strong) UIView *contentView;
/// 内容区宽度
@property (nonatomic, assign) CGFloat contentViewWidth;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 内容
@property (nonatomic, strong) UILabel *contentLabel;
/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
/// 确定按钮
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) NSString *contentString;

@property (nonatomic, assign) BOOL isDouble;

@end

@implementation LZYConfirmView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content isDoubleButton:(BOOL )isDouble{
    self = [super init];
    if (self) {
        self.titleString = title;
        self.contentString = content;
        self.isDouble = isDouble;
        
        
        self.contentViewWidth = [UIScreen mainScreen].bounds.size.width - 100;
        
        [self setupContent];
        [self setupSubViews];
        
    }
    return self;
}

/**
 *  Window
 *
 *  @return <#return value description#>
 */
- (UIView *)initTopWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.subviews[0];
}

#pragma mark - 初始化
/**
 *  初始化基础控件
 */
- (void)setupContent {
    //
    self.frame = [UIScreen mainScreen].bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    [[self initTopWindow] addSubview:self];
    
    // 遮罩
    self.coverView = [[UIView alloc] initWithFrame:self.frame];
    self.coverView.userInteractionEnabled = YES;
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.0;
    [self addSubview:self.coverView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.coverView addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    // 内容
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(50.0, (self.frame.size.height - _kContentViewHeight) / 2, self.contentViewWidth, _kContentViewHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
}

/**
 初始化内容控件
 */
- (void)setupSubViews {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.contentViewWidth, 22)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = self.titleString;
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 42, self.contentViewWidth - 40, 66)];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = self.contentString;
    [self.contentView addSubview:self.contentLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _kContentViewHeight - kButtonHeight - 1, self.contentViewWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self.contentView addSubview:lineView];
    
    if (self.isDouble) {
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _kContentViewHeight - kButtonHeight, (self.contentViewWidth - 1) / 2, kButtonHeight)];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancelButton setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
        self.cancelButton.backgroundColor = [UIColor whiteColor];
        [self.cancelButton addTarget:self action:@selector(buttonPressdAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelButton];
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.cancelButton.frame.size.width + 1, _kContentViewHeight - kButtonHeight, (self.contentViewWidth - 1) / 2, kButtonHeight)];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.confirmButton setTitleColor:[UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1] forState:UIControlStateNormal];
        self.confirmButton.backgroundColor = [UIColor whiteColor];
        [self.confirmButton addTarget:self action:@selector(buttonPressdAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.confirmButton];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(self.cancelButton.frame.size.width, _kContentViewHeight - kButtonHeight, 1, kButtonHeight)];
        line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:line];
        
    } else {
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _kContentViewHeight - kButtonHeight, self.contentViewWidth, kButtonHeight)];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.confirmButton setTitleColor:[UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1] forState:UIControlStateNormal];
        self.confirmButton.backgroundColor = [UIColor whiteColor];
        [self.confirmButton addTarget:self action:@selector(buttonPressdAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.confirmButton];
    }
}

#pragma mark - 方法
- (void)buttonPressdAction:(UIButton *)sender {
    if(sender == self.confirmButton) {
        if (self.confirmButtonPressedCallback) {
            self.confirmButtonPressedCallback();
        }
    } else {
        
    }
    [self hide];
}
/**
 *  显示
 */
- (void)show {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.coverView.alpha = 0.3;
                         self.contentView.frame = CGRectMake(50, (self.frame.size.height - _kContentViewHeight )/2, self.contentViewWidth, _kContentViewHeight);
                         //                         self.contentView.frame = CGRectMake(0.0, self.frame.size.height - self->_contentViewHeight, self.frame.size.width, self->_contentViewHeight);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

/**
 *  隐藏
 */
- (void)hide {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.coverView.alpha = 0.0;
                         //                         self.contentView.frame = CGRectMake(0.0, self.frame.size.height + self->_contentViewHeight, self.frame.size.width, self->_contentViewHeight);
                         self.contentView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self.titleLabel removeFromSuperview];
                         self.titleLabel = nil;
                         [self.contentLabel removeFromSuperview];
                         self.contentLabel = nil;
                         [self.cancelButton removeFromSuperview];
                         self.cancelButton = nil;
                         [self.confirmButton removeFromSuperview];
                         self.confirmButton = nil;
                         [self.contentView removeFromSuperview];
                         self.contentView = nil;
                         [self.coverView removeFromSuperview];
                         self.coverView = nil;
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Setter
- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor {
    _viewBackgroundColor = viewBackgroundColor;
    [self.contentView setBackgroundColor:viewBackgroundColor];
}

- (void)setCancelButtonTitleNormalColor:(UIColor *)cancelButtonTitleNormalColor {
    _cancelButtonTitleNormalColor = cancelButtonTitleNormalColor;
    [self.cancelButton setTitleColor:cancelButtonTitleNormalColor forState:UIControlStateNormal];
}

- (void)setConfirmButtonTitleNormalColor:(UIColor *)confirmButtonTitleNormalColor {
    _confirmButtonTitleNormalColor = confirmButtonTitleNormalColor;
    [self.confirmButton setTitleColor:confirmButtonTitleNormalColor forState:UIControlStateNormal];
}



@end
