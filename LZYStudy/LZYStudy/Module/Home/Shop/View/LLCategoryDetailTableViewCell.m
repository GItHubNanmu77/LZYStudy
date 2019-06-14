//
//  LLCategoryDetailTableViewCell.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLCategoryDetailTableViewCell.h"

@interface LLCategoryDetailTableViewCell ()

@property (nonatomic, strong) UIImageView *selectedView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation LLCategoryDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.selectedView];
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).mas_offset(-10);
    }];
}

- (void)updateData:(NSString *)data {
    self.nameLabel.text = data;
    if (self.selected) {
        self.selectedView.hidden = NO;
        self.nameLabel.font = LZY_FONT_FROM_NAME_SIZE_MEDIUM(16);
        self.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        self.selectedView.hidden = YES;
        self.nameLabel.font = LZY_FONT_FROM_NAME_SIZE(13);
        self.contentView.backgroundColor = RGB3(220);
    }
}

#pragma mark - Getter

- (UIImageView*)selectedView{
    if(!_selectedView){
        _selectedView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _selectedView.image = [UIImage imageNamed:@""];
        _selectedView.backgroundColor = [UIColor redColor];
    }
    return _selectedView;
}

- (UILabel*)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.text = @"";
        _nameLabel.textColor = RGB3(51);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}
@end
