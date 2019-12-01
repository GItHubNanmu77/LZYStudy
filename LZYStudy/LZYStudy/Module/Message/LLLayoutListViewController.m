//
//  LLLayoutListViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/20.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLLayoutListViewController.h"

#import "LLDynamicViewController.h"
#import "LLMessageViewController.h"
#import "LLDragViewController.h"
#import "LLCardViewController.h"
#import "LLPileCardViewController.h"
#import "LLWeChatViewController.h"

@interface LLLayoutListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;


@end

@implementation LLLayoutListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    [self initSubviews];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<1000; i++) {
        UIImage *ima = [UIImage imageNamed:@"Tips_Error"];
        [arr addObject:ima];
    }
}

- (void)initSubviews {
    [self.view addSubview:self.table];
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
    
    switch (indexPath.row) {
        case 0:{
                LLDynamicViewController *vc = [[LLDynamicViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } break;
        case 1:{
            LLMessageViewController *vc = [[LLMessageViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 2:{
            LLDragViewController *vc = [[LLDragViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 3:{
            LLCardViewController *vc = [[LLCardViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 4:{
            LLPileCardViewController *vc = [[LLPileCardViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 5:{
            LLWeChatViewController *vc = [[LLWeChatViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 6:{
            
            
            
        } break;
            
        default:
            break;
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
        [_dataArray addObject:@"横竖变化布局"];
        [_dataArray addObject:@"图片流水布局"];
        [_dataArray addObject:@"拖动排序"];
        [_dataArray addObject:@"中心卡片放大"];
        [_dataArray addObject:@"层叠卡片滑动"];
        [_dataArray addObject:@"微信列表"];
    }
    return _dataArray;
}
@end
