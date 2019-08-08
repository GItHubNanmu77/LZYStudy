//
//  LZYPullTableView.m
//  LZYStudy
//
//  Created by cisdi on 2019/8/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYPullTableView.h"

@interface LZYPullTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation LZYPullTableView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 400, LZY_SCREEN_WIDTH, 0);
        
        self.dataSource = [NSMutableArray arrayWithArray:dataSource];
        [self setup];
        [self addSubview:self.table];
    }
    return self;
}
- (void)setup {
    [[self initTopWindow] addSubview:self];
}
- (void)show { 
    [UIView animateWithDuration:0.5 animations:^{
        self.height = self.dataSource.count * 60;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.table removeFromSuperview];
        self.table = nil;
        [self removeFromSuperview];
    }];
}

/**
 *  Window
 *
 *  @return <#return value description#>
 */
- (UIView *)initTopWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.subviews[0];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZYBaseTableViewCell *cell = (LZYBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LZYBaseTableViewCell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        cell.showTopSeparator = YES;
    } else {
        cell.showTopSeparator = NO;
    }
    if (indexPath.row == self.dataSource.count - 1) {
        cell.showBottomSeparator = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *data = self.dataSource[indexPath.row];
    !self.selectedBlock ? : self.selectedBlock(data);
    [self hide];
}

- (UITableView *)table {
    if (!_table) {
        _table = ({
            UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, 60 * self.dataSource.count) style:UITableViewStylePlain];
            table.backgroundColor = [UIColor whiteColor];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.contentInset = LZY_VIEW_CONTENT_INSETS_MAKE;
            table.scrollIndicatorInsets = LZY_VIEW_CONTENT_INSETS_MAKE;
            table.delegate = self;
            table.dataSource = self;
            [table registerClass:[LZYBaseTableViewCell class] forCellReuseIdentifier:@"LZYBaseTableViewCell"];
            table;
        });
    }
    return _table;
}



@end
