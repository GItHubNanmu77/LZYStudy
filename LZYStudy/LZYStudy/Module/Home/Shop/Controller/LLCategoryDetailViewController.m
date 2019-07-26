//
//  LLCategoryDetailViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLCategoryDetailViewController.h"

#import "LLCategoryDetailTableViewCell.h"

@interface LLCategoryDetailViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger selRow;

@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) NSMutableArray *collDataArray;

@end

@implementation LLCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table];
    [self.view addSubview:self.collView];
}

#pragma  mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLCategoryDetailTableViewCell *cell = (LLCategoryDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LLCategoryDetailTableViewCell"];
    if (indexPath.row == self.selRow) {
        cell.isSelected = YES;
    } else {
        cell.isSelected = NO;
    }
    [cell updateData:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selRow = indexPath.row;
    [self.table reloadData];
    [self.collView reloadData];
}

#pragma mark - collectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.collDataArray[self.selRow];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    NSArray *array = self.collDataArray[self.selRow];
    NSString *name = array[indexPath.row];
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height - 20)];
    imageView.backgroundColor = RGB3(154);
    [cell.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.height - 20, cell.width, 20)];
    label.text = name;
    label.textColor = RGB3(51);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = LZY_FONT_FROM_NAME_SIZE(15);
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (LZY_SCREEN_WIDTH - self.table.width - 20)  / 3;
    return CGSizeMake(w,w + 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Getter
- (UITableView *)table {
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, self.view.height - LZY_TAB_BAR_SAFE_BOTTOM_MARGIN- LZY_IPHONE_NAV_STATUS_HEIGHT) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _table.delegate = self;
        _table.dataSource = self;
        
        [_table registerClass:[LLCategoryDetailTableViewCell class] forCellReuseIdentifier:@"LLCategoryDetailTableViewCell"];
    }
    return _table;
}

- (UICollectionView *)collView {
    if (!_collView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.table.width, 0, LZY_SCREEN_WIDTH - self.table.width, self.view.height - LZY_TAB_BAR_SAFE_BOTTOM_MARGIN - LZY_IPHONE_NAV_STATUS_HEIGHT) collectionViewLayout:layout];
        [_collView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        _collView.contentInset = UIEdgeInsetsMake(10, 5, 0, 5);
        _collView.backgroundColor = RGB3(255);
        _collView.delegate = self;
        _collView.dataSource = self;
    }
    return _collView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
         _dataArray = [NSMutableArray arrayWithObjects:@"男装",@"女装",@"童装",@"手机数码",@"美妆护肤",@"电脑办公",@"电器",@"食品",@"图书",@"男装",@"女装",@"童装",@"手机数码",@"美妆护肤",@"电脑办公",@"电器",@"食品",@"图书", nil];
    }
    return _dataArray;
}

- (NSMutableArray *)collDataArray {
    if (!_collDataArray) {
        _collDataArray = [NSMutableArray array];
        NSArray *arr1 = @[@"T恤",@"牛仔裤",@"夹克",@"衬衫",@"休闲裤",@"T恤",@"牛仔裤",@"夹克",@"衬衫",@"休闲裤",@"T恤",@"牛仔裤",@"夹克",@"衬衫",@"休闲裤",@"T恤",@"牛仔裤",@"夹克",@"衬衫",@"休闲裤"];
        NSArray *arr2 = @[@"短裙",@"连衣裙",@"T恤",@"外套",@"裤裙",@"帽子",@"牛仔裤"];
        NSArray *arr3 = @[@"外套",@"T恤",@"裤子",@"鞋子",@"裙子"];
        _collDataArray = [NSMutableArray arrayWithObjects:arr1, arr2, arr3, arr1, arr2, arr3, nil];
    }
    return _collDataArray;
}
@end
