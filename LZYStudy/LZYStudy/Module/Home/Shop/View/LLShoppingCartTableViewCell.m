//
//  LLShoppingCartTableViewCell.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLShoppingCartTableViewCell.h"

@interface LLShoppingCartTableViewCell ()
@property (nonatomic, strong) LZYURLImageView *productImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *subButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation LLShoppingCartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.productImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.subButton];
        [self.contentView addSubview:self.addButton];
        [self.contentView addSubview:self.countLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
  
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-16);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.right.equalTo(self.subButton.mas_left).offset(-10);
        make.height.mas_equalTo(44);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-26);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.addButton.mas_left).offset(-5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    [self.subButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.countLabel.mas_left).offset(-5);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
}

- (void)updateData:(LLShoppingCartModel *)model {
    self.productImageView.imageUrl = model.url;
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue];
    self.countLabel.text = [NSString stringWithFormat:@"%zi",model.count];
    if (model.count <= 0) {
        self.subButton.hidden = YES;
        model.count = 0;
    } else {
        self.subButton.hidden = NO;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zi",model.count];
}

#pragma mark - Getter
- (LZYURLImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[LZYURLImageView alloc]initWithFrame:CGRectZero];
        _productImageView.image = [UIImage imageNamed:@""];
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
        _productImageView.clipsToBounds = YES;
        _productImageView.userInteractionEnabled = YES;
        
    }
    return _productImageView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.text = @"";
        _nameLabel.textColor = RGB3(51);
        _nameLabel.font = LZY_FONT_FROM_NAME_SIZE(16);
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.text = @"";
        _contentLabel.textColor = RGB3(120);
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = LZY_FONT_FROM_NAME_SIZE(14);
    }
    return _contentLabel;
}
- (UILabel *)priceLabel {
    if(!_priceLabel){
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _priceLabel.text = @"";
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = LZY_FONT_FROM_NAME_SIZE(14);
    }
    return _priceLabel;
}

- (UIButton *)subButton {
    if(!_subButton){
        _subButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_subButton setTitle:@"-" forState:UIControlStateNormal];
        [_subButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _subButton.backgroundColor = [UIColor whiteColor];
        _subButton.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(15);
        _subButton.tag = 100;
        _subButton.layer.cornerRadius = 10;
        _subButton.layer.borderColor = [UIColor redColor].CGColor;
        _subButton.layer.borderWidth = 1;
        [_subButton addTarget:self action:@selector(countChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subButton;
}

- (UIButton *)addButton {
    if(!_addButton){
        _addButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addButton.backgroundColor = [UIColor whiteColor];
        _addButton.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(15);
        _addButton.tag = 101;
        _addButton.layer.cornerRadius = 10;
        _addButton.layer.borderColor = [UIColor redColor].CGColor;
        _addButton.layer.borderWidth = 1;
        [_addButton setImage:[UIImage imageNamed:@"My_Highlighted"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(countChange:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _addButton;
}

- (UILabel *)countLabel {
    if(!_countLabel){
        _countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _countLabel.text = @"";
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = LZY_FONT_FROM_NAME_SIZE(14);
    }
    return _countLabel;
}
- (void)countChange:(UIButton *)sender {
    NSInteger count = self.countLabel.text.integerValue;
    if (sender == self.addButton) {
        count++;
        !self.cellButtonBlock ? : self.cellButtonBlock(sender);
    } else {
        count--;
    }
    if (count == 0) {
        self.subButton.hidden = YES;
    } else {
        self.subButton.hidden = NO;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zi",count];
}

@end

