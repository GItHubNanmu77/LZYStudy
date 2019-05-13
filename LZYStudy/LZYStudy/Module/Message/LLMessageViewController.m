//
//  LLMessageViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLMessageViewController.h"

@interface LLMessageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *dataTableView;

@end

@implementation LLMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    [self setupTheTableView];
}

#pragma mark - UITableViewDataSource
- (void)setupTheTableView {
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, LZY_SCREEN_WIDTH, self.view.height - LZY_IPHONE_NAV_HEIGHT - 42.0)];
    self.dataTableView.backgroundColor = RGB3(255);
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    self.dataTableView.contentInset = LZY_VIEW_CONTENT_INSETS_MAKE;
    self.dataTableView.scrollIndicatorInsets = LZY_VIEW_CONTENT_INSETS_MAKE;
    self.dataTableView.rowHeight = 50;
    [self.view addSubview:self.dataTableView];
    
    [self.dataTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    if (@available(iOS 11.0, *)) {
        self.dataTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}



#pragma mark - Override Methods

#pragma mark - Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0) {
        [MBProgressHUD showInfoMessage:@"信息"];
    } else if (indexPath.row == 1){
        [MBProgressHUD showTipMessageInView:@"view提示"];
    } else if (indexPath.row == 2) {
        [MBProgressHUD showWarnMessage:@"警告"];
    } else if(indexPath.row == 3) {
        [MBProgressHUD showErrorMessage:@"错误"];
    } else {
        [MBProgressHUD showTipMessageInWindow:@"窗口提示"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}
@end
