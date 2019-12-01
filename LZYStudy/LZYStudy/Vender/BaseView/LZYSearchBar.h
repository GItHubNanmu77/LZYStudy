//
//  LZYSearchBar.h
//  LZYStudy
//
//  Created by cisdi on 2019/7/22.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, SearchBarType){
    SearchBarTypePlaceholderCenter,
    SearchBarTypePlaceholderLeft
};

@class LZYSearchBar;
@protocol LZYSearchBarDelegate <NSObject>
@optional

- (void)searchBar:(LZYSearchBar *)searchBar textDidChange:(NSString *)searchText; // called when text changes (including clear)
- (void)searchBarSearchButtonClicked:(LZYSearchBar *)searchBar; // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(LZYSearchBar *)searchBar; // called when cancel button pressed
- (void)searchBarTextDidBeginEditing:(LZYSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(LZYSearchBar *)searchBar;

@end

@interface LZYSearchBar : UIView

/// 搜索框背景颜色（背景颜色和背景图片可二选一）
@property (nonatomic, strong) UIColor *sBackgroundColorName;
/// 搜索框背景图片
@property (nonatomic, strong) NSString *sBackgroundImageName;
/// 搜索小图标图片
@property (nonatomic, strong) NSString *sSearchIconImageName;
/// 边框的宽度
@property (nonatomic, assign) CGFloat sBoderWidth;
/// 边框圆角度
@property (nonatomic, assign) CGFloat sCornerRadius;
/// 边框颜色
@property (nonatomic, strong) UIColor *sBoderColorName;

/// placeholder字体颜色
@property (nonatomic, strong) UIColor *sPlaceholderTextColorName;
/// 输入文字颜色
@property (nonatomic, strong) UIColor *sTextColorName;
/// 默认文本
@property (nonatomic, strong) NSString *placeholder;
/// 取消按钮颜色
@property (nonatomic, strong) UIColor *sCancelButtonColorName;
/// 字体大小
@property (nonatomic, assign) CGFloat sFont;
/// 是否显示取消按钮,默认不显示
@property (nonatomic, assign) BOOL showsCancelButton;
/// 代理
@property (nonatomic, weak) id<LZYSearchBarDelegate> delegate;
/// 类型
@property (nonatomic, assign) SearchBarType type;


/// 搜索输入框，方便外部获取文本
@property (nonatomic, strong) UITextField *searchTextField;

@end

NS_ASSUME_NONNULL_END

