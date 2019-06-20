//
//  LLPhotosWaterFlowLayout.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WaterFlowLayoutDelegate <NSObject>
// 返回每一个item的高度
- (CGFloat)heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LLPhotosWaterFlowLayout : UICollectionViewLayout
// 设置代理，用于获取item的高度
@property (nonatomic, weak) id<WaterFlowLayoutDelegate>delegate;
/// item的大小，需要根据这个获取宽度
@property (nonatomic, assign) CGSize itemSize;
/// 内边距的设置
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
/// item的间距(这里水平方向和垂直方向的间距一样)
@property (nonatomic, assign) CGFloat spacing;
/// 列数
@property (nonatomic, assign) NSInteger numberOfColumn;


@end


NS_ASSUME_NONNULL_END
