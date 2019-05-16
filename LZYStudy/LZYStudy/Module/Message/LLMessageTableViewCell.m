//
//  LLMessageTableViewCell.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/16.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLMessageTableViewCell.h"

@interface LLMessageTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation LLMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        self.showBottomSeparator = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setCustomSeparator:16];
    
    self.nameLabel.frame = CGRectMake(0, 20, 100, 20);
}
- (UILabel*)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.text = @"123123";
        _nameLabel.textColor = RGB3(51);
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}



@end
