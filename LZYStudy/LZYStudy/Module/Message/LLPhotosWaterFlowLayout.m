//
//  LLPhotosWaterFlowLayout.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLPhotosWaterFlowLayout.h"

@interface LLPhotosWaterFlowLayout ()
/// 保存一共有多少个item
@property (nonatomic, assign) NSInteger numberOfItems;
/// 保存计算好的每一个item的信息
@property (nonatomic, strong) NSMutableArray *itemAttributes;
/// 保存每一列的高度
@property (nonatomic, strong) NSMutableArray *columnHeights;

@end

@implementation LLPhotosWaterFlowLayout

- (NSMutableArray *)itemAttributes {
    if (!_itemAttributes) {
        _itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}


// 找到当前最长列
- (NSInteger)indexOfHeightestColumn {
     // 记录最长列的下标
    NSInteger index = 0;
     // 记录最长列的高度
    CGFloat length = 0;
    for (int i = 0; i < self.columnHeights.count; i++) {
         // 将数组中的对象转为基本数值
        CGFloat currentLength = [self.columnHeights[i] floatValue];
        if (currentLength > length) {
            length = currentLength;
            index = i;
            }
        }
    return index;
}

// 找到当前最短列
- (NSInteger)indexOfShortestColumn {
    NSInteger index = 0;
    CGFloat length = MAXFLOAT;
    for (int i = 0; i < self.columnHeights.count; i++) {
        CGFloat currentLength = [self.columnHeights[i] floatValue];
        if (currentLength < length) {
            length = currentLength;
            index = i;
            }
        }
    return index;
}

// 接下来重写三个方法

// 准备布局，在这里计算每个item的frame
- (void)prepareLayout {
    
    // 拿到一共有多少个item
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    // 每一列添加一个top高度
    for (int i = 0; i < self.numberOfColumn; i++) {
         // @() NSNumber字面量创建对象
        self.columnHeights[i] = @(self.sectionInsets.top);
    }
    
    // 依次为每个item设置位置信息，并存储在数组中
    for (int i = 0; i < self.numberOfItems; i++) {
        // 1.找到最短列的下标
        NSInteger shortestIndex = [self indexOfShortestColumn];
        // 2.计算X 目标X = 内边距左间距 + (宽 + item间距)*最短列下标
        CGFloat detalX = self.sectionInsets.left + shortestIndex * (self.itemSize.width + self.spacing);
        // 3.找到最短列的高度
        CGFloat height = [self.columnHeights[shortestIndex] floatValue];
        // 4.计算Y
        CGFloat detalY = height + self.spacing;
        // 5.创建indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 6.调用代理方法计算高度
        CGFloat itemHeight = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(heightForItemAtIndexPath:)]) {
            itemHeight = [_delegate heightForItemAtIndexPath:indexPath];
        }
        
        // 定义保存位置信息的对象
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 7.生成frame
        attributes.frame = CGRectMake(detalX, detalY, self.itemSize.width, itemHeight);
        // 8.将位置信息添加到数组中
        [self.itemAttributes addObject:attributes];
        
        // 9.更新这一列的高度
        self.columnHeights[shortestIndex] = @(detalY + itemHeight);
    }
    
}

// 返回UICollectionView的大小
- (CGSize)collectionViewContentSize {
    
    // 求最高列的下标
    NSInteger heightest = [self indexOfHeightestColumn];
    // 最高列的高度
    CGFloat height = [self.columnHeights[heightest] floatValue];
    // 拿到collectionView的原始大小
    CGSize size = self.collectionView.frame.size;
    size.height = height + self.sectionInsets.bottom;
    
    return size;
}

// 返回每一个item的位置信息
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.itemAttributes;
}
@end
