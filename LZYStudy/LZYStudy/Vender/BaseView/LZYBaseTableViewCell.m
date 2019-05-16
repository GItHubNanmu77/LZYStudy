//
//  LZYBaseTableViewCell.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/16.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYBaseTableViewCell.h"

//CGFloat const LeftIntend = 15.0;
//CGFloat const LeftMargins = 10.0;
//CGFloat const RightMargins = 10.0;
//CGFloat const TopMargins = 10.0;
//CGFloat const BottomMargins = 10.0;
//CGFloat const Padding = 5.0;

@interface LZYBaseTableViewCell ()

/// Top 分隔线
@property (nonatomic, strong) UIImageView *topSeparator;
/// Bottom 分隔线
@property (nonatomic, strong) UIImageView *bottomSeparator;

@end

@implementation LZYBaseTableViewCell

/**
 *  <#Description#>
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

/**
 *  <#Description#>
 *
 *  @param style           <#style description#>
 *  @param reuseIdentifier <#reuseIdentifier description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.textLabel.hidden = YES;
//        self.detailTextLabel.hidden = YES;
        self.showBottomSeparator = YES;
        
        // 初如化背景
        [self setupBackgroundView];
        // 初始化分隔线
        [self setupSeparator];
    }
    return self;
}

/**
 *  <#Description#>
 *
 *  @param selected <#selected description#>
 *  @param animated <#animated description#>
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/**
 <#Description#>
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.topSeparator.hidden = YES;
//    self.bottomSeparator.hidden = YES;
}

/**
 *  初如化背景
 */
- (void)setupBackgroundView {
    // 背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    // 背景
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bgView;
    
    // 选中背景
    UIView *selectedBgView = [[UIView alloc] initWithFrame:self.frame];
    selectedBgView.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    self.selectedBackgroundView = selectedBgView;
}

/**
 *  初始化分隔线
 */
- (void)setupSeparator {
    // Top 分隔线
    self.topSeparator = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.topSeparator.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    self.topSeparator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    self.topSeparator.hidden = YES;
    [self.contentView addSubview:self.topSeparator];
    
    // Bottom 分隔线
    self.bottomSeparator = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bottomSeparator.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    self.bottomSeparator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    self.bottomSeparator.hidden = YES;
    [self.contentView addSubview:self.bottomSeparator];
}

/**
 *  透明背景
 */
- (void)transparencyBackground {
    // 清空背景颜色
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    
    // 背景
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor clearColor];
    self.backgroundView = bgView;
    bgView = nil;
    
    // 选中背景
    UIView *selectedBgView = [[UIView alloc] initWithFrame:self.frame];
    selectedBgView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectedBgView;
    selectedBgView = nil;
}

/**
 *  设置自定义分隔线
 */
- (void)setCustomSeparator {
    [self setCustomSeparator:0.0];
}

/**
 *  设置自定义分隔线
 *
 *  @param leftRightIntend 左右缩进值，大于零则 leftIntendSeparator 无效
 */
- (void)setCustomSeparator:(CGFloat)leftRightIntend {
    // TOP 分隔线
    if (self.showTopSeparator) {
        self.topSeparator.hidden = NO;
        CGRect frame = self.topSeparator.frame;
        frame.size.width = self.contentView.frame.size.width;
        self.topSeparator.frame = frame;
    } else {
        self.topSeparator.hidden = YES;
        self.topSeparator.frame = CGRectZero;
    }
    [self.contentView bringSubviewToFront:self.topSeparator];
    
    // Bottom 分隔线
    if (self.showBottomSeparator) {
        self.bottomSeparator.hidden = NO;
        CGRect frame = self.bottomSeparator.frame;
        frame.origin.x = leftRightIntend > 0.0 ? leftRightIntend : (self.leftIntendSeparator ? 15.0 : 0.0);
        frame.origin.y = self.contentView.frame.size.height - self.bottomSeparator.frame.size.height;
        frame.size.width = self.contentView.frame.size.width - (leftRightIntend > 0.0 ? self.bottomSeparator.frame.origin.x + leftRightIntend : self.bottomSeparator.frame.origin.x);
        self.bottomSeparator.frame = frame;
    } else {
        self.bottomSeparator.hidden = YES;
        self.bottomSeparator.frame = CGRectZero;
    }
    [self.contentView bringSubviewToFront:self.bottomSeparator];
}

/**
 *  设置自定义分隔线，左缩进
 *
 *  @param leftIntend 左缩进值，大于零则 leftIntendSeparator 无效
 */
- (void)setCustomLeftSeparator:(CGFloat)leftIntend {
    // TOP 分隔线
    if (self.showTopSeparator) {
        self.topSeparator.hidden = NO;
        CGRect frame = self.topSeparator.frame;
        frame.size.width = self.contentView.frame.size.width;
        self.topSeparator.frame = frame;
    } else {
        self.topSeparator.hidden = YES;
        self.topSeparator.frame = CGRectZero;
    }
    [self.contentView bringSubviewToFront:self.topSeparator];
    
    // Bottom 分隔线
    if (self.showBottomSeparator) {
        self.bottomSeparator.hidden = NO;
        CGRect frame = self.bottomSeparator.frame;
        frame.origin.x = leftIntend;
        frame.origin.y = self.contentView.frame.size.height - self.bottomSeparator.frame.size.height;
        frame.size.width = self.contentView.frame.size.width - self.bottomSeparator.frame.origin.x;
        self.bottomSeparator.frame = frame;
    } else {
        self.bottomSeparator.hidden = YES;
        self.bottomSeparator.frame = CGRectZero;
    }
    [self.contentView bringSubviewToFront:self.bottomSeparator];
}

/**
 *  cell复用唯一标识符
 *
 *  @return return value description
 */
+ (NSString *)cellIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

+ (CGFloat)getContentStrHeight:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
}

#pragma mark - set
/**
 <#Description#>
 
 @param sNormalBackGroudViewColor sNormalBackGroudViewColor
 */
- (void)setSNormalBackGroudViewColorNum:(UIColor *)sNormalBackGroudViewColor {
    _sNormalBackGroudViewColor = sNormalBackGroudViewColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = _sNormalBackGroudViewColor;
    self.backgroundView = bgView;
}

/**
 <#Description#>
 
 @param sSelectedBackGroudViewColor sSelectedBackGroudViewColor
 */
- (void)setSSelectedBackGroudViewColorNum:(UIColor *)sSelectedBackGroudViewColor {
    _sSelectedBackGroudViewColor = sSelectedBackGroudViewColor;
    
    UIView *selectedBgView = [[UIView alloc] initWithFrame:self.frame];
    selectedBgView.backgroundColor = _sSelectedBackGroudViewColor;
    self.selectedBackgroundView = selectedBgView;
}

@end
