//
//  LLHomeViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLHomeViewController.h"

#import "LLCategoryViewController.h"
#import "LLCategoryDetailViewController.h"
#import "LLShoppingCartViewController.h"
#import "LZYPullTableView.h"
#import "LZYSheetAlertManager.h"
#import "CTMainViewController.h"

@interface LLHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *vcArray;


@end

@implementation LLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor systemRedColor];
    [self initSubviews];
   
    
}

- (void)initSubviews {
    [self.view addSubview:self.table];
}

- (void)copyString {
    //UIPasteboard：该类支持写入和读取数据，类似剪贴板
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *string = @"sdf123123sdfsd";
    pasteBoard.string = string;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

#pragma  mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = self.vcArray[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter & Setter
- (UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.rowHeight = 50.0;
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"商城常用标签分类"];
        [_dataArray addObject:@"商城常用两表联动分类"];
        [_dataArray addObject:@"商城常用购物车动画"];
        [_dataArray addObject:@"CTMediator"];
    }
    return _dataArray;
}

- (NSMutableArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
        [_vcArray addObject:[LLCategoryViewController new]];
        [_vcArray addObject:[LLCategoryDetailViewController new]];
        [_vcArray addObject:[LLShoppingCartViewController new]];
        [_vcArray addObject:[CTMainViewController new]];
    }
    return _vcArray;
}
@end
