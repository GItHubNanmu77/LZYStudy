//
//  LLUserInfoViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/17.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLUserInfoViewController.h"
#import "LLDynamicCollectionViewCell.h"
#import "LLDynamicModel.h"

@interface LLUserInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *collDataArray;
@property (nonatomic, strong) UICollectionView *collView;

@property (nonatomic, strong) UICollectionViewFlowLayout *verticalLayout;
@property (nonatomic, strong) UICollectionViewFlowLayout *horizonLayout;

@property (nonatomic, assign) BOOL isVertical;
@end

@implementation LLUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collView];
    
    self.isVertical = YES;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"变化"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    rightButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}
- (void)changeDataSource {
    [self.collDataArray addObjectsFromArray:self.collDataArray];
    [self.collView setCollectionViewLayout:self.horizonLayout animated:YES];
    [self.collView reloadData];
}
- (void)rightBtnAction:(UIBarButtonItem*)sender{
    NSLog(@"右上角按钮点击");
    if (self.isVertical) {
        [self.collView setCollectionViewLayout:self.horizonLayout animated:YES];
        self.isVertical = NO;
    } else {
        self.isVertical = YES;
        [self.collView setCollectionViewLayout:self.verticalLayout animated:YES];
    }
    [self.collView reloadData];
}


#pragma mark - UICollectionViewDataSource + UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLDynamicCollectionViewCell *cell = (LLDynamicCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LLDynamicCollectionViewCell" forIndexPath:indexPath];
    [cell updateData:self.collDataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - JXPagingViewListViewDelegate
/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。
 
 @return UIView
 */
- (UIView *)listView {
    return self.view;
}

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
 
 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView {
    return self.collView;
}


/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
 
 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback {
    
}

#pragma mark - Getter & Setter
- (UICollectionView *)collView {
    if (!_collView) {
        _collView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT - LZY_IPHONE_NAV_HEIGHT  - LZY_TAB_BAR_SAFE_BOTTOM_MARGIN) collectionViewLayout:self.verticalLayout];
            collectionView.backgroundColor = RGB3(247);
            collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerClass:[LLDynamicCollectionViewCell class] forCellWithReuseIdentifier:@"LLDynamicCollectionViewCell"];
            collectionView.userInteractionEnabled = YES;
            
            collectionView;
        });
    }
    return _collView;
}

- (UICollectionViewFlowLayout *)verticalLayout {
    if(!_verticalLayout) {
        _verticalLayout = [[UICollectionViewFlowLayout alloc] init];
        _verticalLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _verticalLayout.minimumLineSpacing = 0;
        _verticalLayout.minimumInteritemSpacing = 0;
        _verticalLayout.itemSize = CGSizeMake(LZY_SCREEN_WIDTH, 110);
    }
    return _verticalLayout;
}

- (UICollectionViewFlowLayout *)horizonLayout {
    if (!_horizonLayout) {
        _horizonLayout = [[UICollectionViewFlowLayout alloc] init];
        _horizonLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _horizonLayout.minimumInteritemSpacing = 0;
        _horizonLayout.minimumLineSpacing = 0;
        _horizonLayout.itemSize = CGSizeMake(LZY_SCREEN_WIDTH / 2 , 150);
    }
    return _horizonLayout;
}

- (NSMutableArray *)collDataArray {
    if (!_collDataArray) {
        _collDataArray = [NSMutableArray array];
        LLDynamicModel *model1 = [[LLDynamicModel alloc] init];
        model1.name = @"Tom";
        model1.content = @"Tom sdfsdjdjaxnv jdslk dsafjiew dafkl sde  sdew  s q dsk adsf e";
        model1.number = @"001";
        model1.image = @"1.jpg";
        
        LLDynamicModel *model2 = [[LLDynamicModel alloc] init];
        model2.name = @"Lily";
        model2.content = @"点击奥拉夫IE人口多少年的设计费饿地方， 十大风景金额";
        model2.number = @"002";
        model2.image = @"2.jpg";
        
        LLDynamicModel *model3 = [[LLDynamicModel alloc] init];
        model3.name = @"Han";
        model3.content = @"额UR我我都快三年累计Jody发的， 我埃及二期偶开始的";
        model3.number = @"003";
        model3.image = @"3.jpg";
        
        LLDynamicModel *model4 = [[LLDynamicModel alloc] init];
        model4.name = @"Queen";
        model4.content = @"发生地解决机";
        model4.number = @"004";
        model4.image = @"4.jpg";
        
        LLDynamicModel *model5 = [[LLDynamicModel alloc] init];
        model5.name = @"Mary";
        model5.content = @"打就欧非王嘉尔熊就发收到打飞机度搜佛为noise为奇偶is金佛ID就发我也";
        model5.number = @"005";
        model5.image = @"5.jpg";
        
        _collDataArray = [NSMutableArray arrayWithArray:@[model1,model2,model3,model4,model5,model1,model2,model3,model4,model5]];
    }
    return _collDataArray;
}

@end

