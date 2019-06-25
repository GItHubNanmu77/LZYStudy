//
//  LLCardViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLCardViewController.h"
#import "LLCardCollectionViewCell.h"
#import "LLCardSwitchLayout.h"

@interface LLCardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, assign) NSInteger selIndex;

@property (nonatomic, assign) CGFloat dragStartX;

@property (nonatomic, assign) CGFloat dragEndX;

@property (nonatomic, assign) CGFloat dragAtIndex;

@end

@implementation LLCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collView];
}

#pragma mark - UICollectionViewDataSource + UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.collView.width, self.collView.width / 0.7);
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLCardCollectionViewCell *cell = (LLCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LLCardCollectionViewCell" forIndexPath:indexPath];
  
    cell.imageView.image = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    self.selIndex = indexPath.row;
    [self scrollToCenterAnimated:YES];
}

#pragma mark - scrollViewDelegate
//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragStartX = scrollView.contentOffset.x;
    self.dragAtIndex = self.selIndex;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

#pragma mark - private
//滚动到中间
- (void)scrollToCenterAnimated:(BOOL)animated {
    [self.collView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//配置cell自动居中
- (void)fixCellToCenter {
    if (self.selIndex != [self dragAtIndex]) {
        [self scrollToCenterAnimated:true];
        return;
    }
    //最小滚动距离
    float dragMiniDistance = self.collView.bounds.size.width / 20.0f;
    if (self.dragStartX -  self.dragEndX >= dragMiniDistance) {
        self.selIndex -= 1;//向右
    }else if(self.dragEndX -  self.dragStartX >= dragMiniDistance){
        self.selIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collView numberOfItemsInSection:0] - 1;
    self.selIndex = self.selIndex <= 0 ? 0 : self.selIndex;
    self.selIndex = self.selIndex >= maxIndex ? maxIndex : self.selIndex;
    [self scrollToCenterAnimated:true];
}

- (UICollectionView *)collView {
    if (!_collView) {
        _collView = ({
            LLCardSwitchLayout *layout = [[LLCardSwitchLayout alloc] init];
            @LZY_weakify(self)
            layout.centerBlock = ^(NSIndexPath * _Nonnull indexPath) {
                @LZY_strongify(self)
                self.selIndex = indexPath.row;
                NSLog(@"--%ld",(long)self.selIndex);
            };
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_WIDTH * 0.54) collectionViewLayout:layout];
            collectionView.backgroundColor = RGB3(255);
            //            collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerClass:[LLCardCollectionViewCell class] forCellWithReuseIdentifier:@"LLCardCollectionViewCell"];
            collectionView.userInteractionEnabled = YES;
            
            collectionView;
        });
    }
    return _collView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i=0; i<20; i++) {
            NSString *name = [NSString stringWithFormat:@"%d.jpg",i];
            UIImage *img = [UIImage imageNamed:name];
            [_dataArray addObject:img];
        }
    }
    return _dataArray;
}
@end
