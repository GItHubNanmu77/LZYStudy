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

@interface LLHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;


@end

@implementation LLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
    if (indexPath.row == 0) {
        LLCategoryViewController *vc = [[LLCategoryViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        LLCategoryDetailViewController *vc = [[LLCategoryDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        LLShoppingCartViewController *vc = [[LLShoppingCartViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LZYPullTableView *pullView = [[LZYPullTableView alloc] initWithFrame:CGRectZero dataSource:@[@"111",@"222",@"333"]];
        pullView.selectedBlock = ^(NSString * _Nonnull text) {
            NSLog(@"%@",text);
        };
        [pullView show];
    }
}

#pragma mark - Getter & Setter
- (UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
        [_dataArray addObject:@"商城下拉弹窗"];
    }
    return _dataArray;
}
@end
