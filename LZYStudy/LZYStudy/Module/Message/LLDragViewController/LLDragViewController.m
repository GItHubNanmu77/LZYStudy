//
//  LLDragViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLDragViewController.h"
#import "UIView+Snapshot.h"

@interface LLDragViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collView;

@property (nonatomic, strong) UIImageView *dragingCell;

@end

@implementation LLDragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.4;
    [self.collView addGestureRecognizer:longPress];
   
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:gesture];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd:gesture];
            break;
            
        default:
            break;
    }
}

- (void)dragBegin:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.collView];
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {
        return;
        
    }
    NSLog(@"拖拽开始 indexPath = %@",_dragingIndexPath);
    [self.collView bringSubviewToFront:self.dragingCell];
    //更新被拖拽的cell
    UICollectionViewCell *cell = [self.collView cellForItemAtIndexPath:_dragingIndexPath];
    self.dragingCell.image = [cell snapshotImage];
    self.dragingCell.frame = [self.collView cellForItemAtIndexPath:_dragingIndexPath].frame;
    self.dragingCell.hidden = false;
    self.dragingCell.backgroundColor = [UIColor redColor];
    self.dragingCell.userInteractionEnabled = YES;
    @LZY_weakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        @LZY_strongify(self)
        [self.dragingCell setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    }];
    
}

- (void)dragChanged:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"拖拽中。。。");
    CGPoint point = [gesture locationInView:self.collView];
    _dragingCell.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    NSLog(@"targetIndexPath = %@",_targetIndexPath);
    if (_targetIndexPath && _dragingIndexPath) {
        [self.collView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

- (void)dragEnd:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"拖拽结束");
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [self.collView cellForItemAtIndexPath:_dragingIndexPath].frame;
    @LZY_weakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        @LZY_strongify(self)
        [self.dragingCell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        self.dragingCell.frame = endFrame;
    }completion:^(BOOL finished) {
        self.dragingCell.hidden = true;
    }];
}

//获取被拖动IndexPath的方法
- (NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point
{
    NSIndexPath* dragingIndexPath = nil;
    //遍历所有屏幕上的cell
    for (NSIndexPath *indexPath in [self.collView indexPathsForVisibleItems]) {
        //判断cell是否包含这个点
        if (CGRectContainsPoint([self.collView cellForItemAtIndexPath:indexPath].frame, point)) {
            dragingIndexPath = indexPath;
            break;
        }
    }
    return dragingIndexPath;
}

//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point
{
    NSIndexPath *targetIndexPath = nil;
    //遍历所有屏幕上的cell
    for (NSIndexPath *indexPath in self.collView.indexPathsForVisibleItems) {
        //避免和当前拖拽的cell重复
        if ([indexPath isEqual:_dragingIndexPath]) {
            continue;
        }
        //判断是否包含这个点
        if (CGRectContainsPoint([self.collView cellForItemAtIndexPath:indexPath].frame, point)) {
            targetIndexPath = indexPath;
        }
    }
    return targetIndexPath;
}
    
#pragma mark - UICollectionViewDataSource + UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.text = self.dataArray[indexPath.row];
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = 2;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    view.backgroundColor = [UIColor blueColor];
    [cell addSubview:view];
    [cell addSubview:label];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}

- (UICollectionView *)collView {
    if (!_collView) {
        _collView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
            layout.minimumLineSpacing = 10.0;
            layout.minimumInteritemSpacing = 10.0;
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, self.view.height - LZY_TAB_BAR_SAFE_BOTTOM_MARGIN) collectionViewLayout:layout];
            collectionView.backgroundColor = RGB3(255);
            //            collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
            collectionView.userInteractionEnabled = YES;
            
            self.dragingCell = [[UIImageView alloc] init];
            self.dragingCell.hidden = true;
            [collectionView addSubview:self.dragingCell];
           
            
            collectionView;
        });
    }
    return _collView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i=0; i<20; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [_dataArray addObject:str];
        }
    }
    return _dataArray;
}
@end
