//
//  LLMiniAppViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/7/24.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLMiniAppViewController.h"

@interface LLMiniAppViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) UIView *vHeader;

@end

@implementation LLMiniAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"小程序";
    
    self.view.backgroundColor = RGB3(216);
    [self.view addSubview:self.vHeader];
    
    [self.view addSubview:self.collView];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, cell.width-30, cell.height-30)];
    imgView.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:imgView];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = LZY_SCREEN_WIDTH / 4;
    return CGSizeMake(w, w);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


- (UICollectionView*)collView{
    if (!_collView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -LZY_IPHONE_NAV_HEIGHT, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT - LZY_IPHONE_NAV_HEIGHT) collectionViewLayout:layout];
        [_collView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        _collView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collView.backgroundColor = RGB3(216);
        _collView.delegate = self;
        _collView.dataSource = self;
    }
    return _collView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (int i = 0;i < 10 ; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [_dataSource addObject:str];
        }
    }
    return _dataSource;
}

- (UIView *)vHeader {
    if(!_vHeader) {
        _vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_IPHONE_NAV_HEIGHT)];
        _vHeader.backgroundColor = RGB3(216);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, LZY_IPHNOE_STATUS_BAR_HEIGHT, LZY_SCREEN_WIDTH - 120, LZY_IPHONE_NAV_HEIGHT - LZY_IPHNOE_STATUS_BAR_HEIGHT)];
        label.text = @"小程序";
        label.textColor = RGB3(0);
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        [_vHeader addSubview:label];
    }
    return _vHeader;
}

@end
