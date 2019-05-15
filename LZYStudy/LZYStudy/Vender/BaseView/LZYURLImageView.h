//
//  LZYURLImageView.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/15.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 显示网络图片的ImageView
 */
@interface LZYURLImageView : UIImageView

/// 是否拉伸图片：可选
@property (nonatomic, assign) BOOL resizeable;
/// 默认图片名
@property (nonatomic, strong) NSString *placeHolderName;
/// 圆角半径：可选
@property (nonatomic, assign) CGFloat cornerRadius;
/// 圆角位置
@property (nonatomic, assign) UIRectCorner corners;
/// 头像地址
@property (nonatomic, strong) NSString *imageUrl;
/// 非必传：图片加载完毕且成功后的回调，如需要对图片进行处理则设置
@property (nonatomic, strong) void(^loadSuccessedBlock)(UIImage *image);

/**
 初始化网络图片视图
 
 @param frame frame
 @param placeHolderName 默认内置图路径名
 @param resizeable 是否可拉伸
 @param imageUrl 图片网络地址
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame placeHolderName:(NSString *)placeHolderName resizeable:(BOOL)resizeable imageUrl:(NSString *)imageUrl;

/**
 初始化网络图片视图
 
 @param frame frame
 @param placeHolderName 默认内置图路径名
 @param resizeable 是否可拉伸
 @param cornerRadius 圆角半径
 @param imageUrl 图片网络地址
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame placeHolderName:(NSString *)placeHolderName resizeable:(BOOL)resizeable cornerRadius:(CGFloat)cornerRadius imageUrl:(NSString *)imageUrl;

/**
 初始化网络图片视图
 
 @param frame frame
 @param placeHolderName 默认内置图路径名
 @param resizeable 是否可拉伸
 @param cornerRadius 圆角半径
 @param corners 圆角显示位置
 @param imageUrl 图片网络地址
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame placeHolderName:(NSString *)placeHolderName resizeable:(BOOL)resizeable cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners imageUrl:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END


