//
//  LLMessagePhotoCollectionViewCell.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLMessagePhotoCollectionViewCell.h"

@interface LLMessagePhotoCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LLMessagePhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)updateData:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImageView*)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@""];
    }
    return _imageView;
}
@end
