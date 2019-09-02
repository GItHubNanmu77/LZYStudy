//
//  LLWebTableViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/8/26.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLWebTableViewController.h"
#import <WebKit/WebKit.h>

@interface LLWebTableViewController () <UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *vFooter;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat wbHeight;
@end

@implementation LLWebTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    [self initSubviews];
    
    [self loadRequest];
}

- (void)initSubviews {
    [self.view addSubview:self.table];
}
- (void)loadRequest {
//    NSString *url = @"https://www.jianshu.com/u/842cccac8576";
    NSString *url = @"https://www.baidu.com";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)wkWebViewReload{
    [self.webView reload];
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

#pragma mark - Getter & Setter
- (UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, self.view.height- LZY_IPHONE_NAV_STATUS_HEIGHT) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.delegate = self;
        _table.dataSource = self;
//        _table.tableFooterView = self.vFooter;
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

- (WKWebView *)webView {
    if(!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, 100)];
        _webView.scrollView.scrollEnabled = YES;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = RGB3(245);

    }
    return _webView;
}

-(UIView *)vFooter{
    if (!_vFooter){
        _vFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, 100)];
        _vFooter.backgroundColor = RGB3(245);
        [_vFooter addSubview:self.webView];
    }
    return _vFooter;
}


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"width=%f--height=%f",webView.scrollView.contentSize.width,webView.scrollView.contentSize.height);
    self.wbHeight = webView.scrollView.contentSize.height;
    
    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        
        self.wbHeight = [result floatValue];
        NSLog(@"scrollHeight高度：%.2f",[result floatValue]);
    }];
    
    [webView evaluateJavaScript:@"document.body.offsetHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        self.wbHeight = [result floatValue];
        NSLog(@"offsetHeight高度：%.2f",[result floatValue]);
    }];
    
    self.vFooter.frame = CGRectMake(0, 0, LZY_SCREEN_WIDTH, self.wbHeight);
    [self.vFooter addSubview:self.webView];
    self.webView.frame = CGRectMake(0, 0, LZY_SCREEN_WIDTH, self.wbHeight);
    self.table.tableFooterView = self.vFooter;
    
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.table]) {
        NSLog(@"tableView");
        CGFloat yOffSet = scrollView.contentOffset.y;
        NSLog(@"偏移%.2f",yOffSet);
        if (yOffSet >= 0) {
            self.webView.scrollView.scrollEnabled = YES;
            self.table.bounces = NO;
        }else{
            self.webView.scrollView.scrollEnabled = NO;
            self.table.bounces = YES;
        }
    }
}


@end

