//
//  LLCardCollectionViewCell.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLCardCollectionViewCell.h"

@interface LLCardCollectionViewCell ()


@end

@implementation LLCardCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).mas_offset(-10);
    }];
}

- (UIImageView *)imageView {
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@""];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.layer.borderWidth = 1;
//        _imageView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _imageView;
}

@end
