//
//  LLDynamicCollectionViewCell.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/17.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLDynamicCollectionViewCell.h"

@interface LLDynamicCollectionViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *btnCare;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LLDynamicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.headImageView];
    [self addSubview:self.numberLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.btnCare];
    [self addSubview:self.lineView];
    
}
- (void)layoutSubviews {
    [UIView animateWithDuration:0.3 animations:^{
        [super layoutSubviews];
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.headImageView.mas_right).offset(15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberLabel.mas_bottom).offset(5);
        make.left.equalTo(self.headImageView.mas_right).offset(15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(1);
    }];
    [self.btnCare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView);
        make.right.equalTo(self).offset(-16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(34);
    }];
   
}

- (void)updateData:(LLDynamicModel *)model {
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;
    self.numberLabel.text = model.number;
    self.headImageView.image = [UIImage imageNamed:model.image];
    
}


- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@""];
            imageView;
        });
    }
    return _headImageView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = LZY_FONT_FROM_NAME_SIZE_MEDIUM(15);
            label.textColor = RGB3(51);
            label;
        });
    }
    return _numberLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = LZY_FONT_FROM_NAME_SIZE(15);
            label.textColor = RGB3(51);
            label;
        });
    }
    return _nameLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = LZY_FONT_FROM_NAME_SIZE(14);
            label.textColor = RGB3(51);
            label.numberOfLines = 0;
            label;
        });
    }
    return _contentLabel;
}

- (UIButton *)btnCare {
    if (!_btnCare) {
        _btnCare = ({
            UIButton *button = [[UIButton alloc] init];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(17.0);
            [button setTitleColor:RGB(234, 88, 73) forState:UIControlStateNormal];
            [button setTitle:@"关注" forState:UIControlStateNormal];
            [button setBackgroundColor:RGB(107, 188, 245)];
            button.layer.cornerRadius = 4;
            [button bk_addEventHandler:^(id sender) {
                
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _btnCare;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = RGB3(202);
            view;
        });
    }
    return _lineView;
}
@end
