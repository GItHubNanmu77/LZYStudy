//
//  LLWeChatViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/7/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLWeChatViewController.h"
#import "LLMiniAppViewController.h"
#import "SDEyeAnimationView.h"

@interface LLWeChatViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *vHeader;
@property (nonatomic, assign) BOOL tableViewIsHidden;

@property (nonatomic, strong) LLMiniAppViewController *miniAppVC;
@property (nonatomic, strong) UIView *eyeView;

@end

@implementation LLWeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"微信";
    self.view.backgroundColor = RGB3(216);
    [self initSubviews];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    pan.delegate = self;
    [self.table.superview addGestureRecognizer:pan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupEyeAnimationView];
    if (!self.miniAppVC) {
        self.miniAppVC = [[LLMiniAppViewController alloc] init];
        [self.view insertSubview:self.miniAppVC.view atIndex:0];
    }
}

- (void)initSubviews {
    [self.view addSubview:self.table];
}

- (void)setupEyeAnimationView {
    if (!self.eyeView) {
//        SDEyeAnimationView *view = [[SDEyeAnimationView alloc] init];
//        view.frame = CGRectMake(0, -88, LZY_SCREEN_WIDTH, 88);
//        view.center = CGPointMake(self.view.bounds.size.width * 0.5, 70);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -88, LZY_SCREEN_WIDTH, 88)];
        view.backgroundColor = RGB3(216);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake((LZY_SCREEN_WIDTH - 40 )/2, 40, 40, 40)];
        imageview.image = [UIImage imageNamed:@"My_Normal"];
        [view addSubview:imageview];
        [imageview sizeToFit];
        [self.view addSubview:view];
        self.eyeView = view;
    }
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
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"一直滚动--%f",scrollView.contentOffset.y);
    if (self.table.contentOffset.y < 0) {
        self.navigationController.navigationBar.y = -self.table.contentOffset.y + LZY_IPHNOE_STATUS_BAR_HEIGHT;
    }
    
    
}
- (void)panView:(UIPanGestureRecognizer *)pan
{
        NSLog(@">>>>>  pan 导航栏--%f",self.navigationController.navigationBar.y);
    
    if (self.table.contentOffset.y < 0) {
        CGFloat height = LZY_IPHONE_NAV_HEIGHT;
        CGFloat progress = (-self.table.contentOffset.y + LZY_IPHONE_NAV_HEIGHT) / height;
        if (progress > 0) {
            self.eyeView.transform = CGAffineTransformMakeScale(progress, progress);
        }
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
       
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.table.contentOffset.y < - (64 + 80) && !self.tableViewIsHidden) {
            [UIView animateWithDuration:0.5 animations:^{
                self.table.y = LZY_SCREEN_HEIGHT - LZY_IPHONE_NAV_HEIGHT;
                self.navigationController.navigationBar.y = self.table.y + LZY_IPHNOE_STATUS_BAR_HEIGHT;
                CGFloat progress = self.table.y / (LZY_SCREEN_HEIGHT - LZY_IPHONE_NAV_HEIGHT);
                self.eyeView.alpha = 1 - progress;
                self.miniAppVC.view.transform = CGAffineTransformMakeTranslation(0, LZY_SCREEN_HEIGHT);
                self.miniAppVC.view.transform = CGAffineTransformMakeScale(1, progress);
                self.miniAppVC.view.alpha = progress;
            } completion:^(BOOL finished) {
                self.tableViewIsHidden = YES;
                self.table.y = LZY_SCREEN_HEIGHT - LZY_IPHONE_NAV_HEIGHT * 2;
                self.table.tableHeaderView = self.vHeader;
                self.navigationController.navigationBar.y = -LZY_IPHONE_NAV_HEIGHT;
                self.eyeView.hidden = YES;
                self.eyeView.transform = CGAffineTransformMakeScale(1, 1);
                self.eyeView.alpha = 1;
            }];
            
        } else if (self.tableViewIsHidden && self.table.y < LZY_SCREEN_HEIGHT - 50) {
            [UIView animateWithDuration:0.5 animations:^{
                self.table.y = -LZY_IPHONE_NAV_HEIGHT;
                self.miniAppVC.view.transform = CGAffineTransformMakeTranslation(0, -LZY_SCREEN_HEIGHT);
                self.miniAppVC.view.alpha = 0;
            } completion:^(BOOL finished) {
                self.tableViewIsHidden = NO;
                self.table.y = 0;
                self.navigationController.navigationBar.y = LZY_IPHNOE_STATUS_BAR_HEIGHT;
                self.table.tableHeaderView = nil;
                self.eyeView.hidden = NO;
                self.miniAppVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
                self.miniAppVC.view.alpha = 1;
            }];
        } else {
            self.eyeView.transform = CGAffineTransformMakeScale(1, 1);
        }
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
        [_dataArray addObject:@"123"];
        [_dataArray addObject:@"234"];
        [_dataArray addObject:@"345"];
        [_dataArray addObject:@"456"];
        [_dataArray addObject:@"567"];
    }
    return _dataArray;
}
- (UIView *)vHeader {
    if(!_vHeader) {
        _vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_IPHONE_NAV_HEIGHT)];
        _vHeader.backgroundColor = RGB3(255);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, LZY_IPHNOE_STATUS_BAR_HEIGHT, LZY_SCREEN_WIDTH - 120, LZY_IPHONE_NAV_HEIGHT - LZY_IPHNOE_STATUS_BAR_HEIGHT)];
        label.text = @"微信";
        label.textColor = RGB3(0);
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        [_vHeader addSubview:label];
    }
    return _vHeader;
}
@end

