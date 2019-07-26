//
//  LLWebViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLWebViewController.h"

#import <WebKit/WebKit.h>
#import "LLWeakScriptMessageDelegate.h"


// WebViewJavascriptBridge 第三方桥接库

static NSString *const LL_WKWebView_EstimatedProgress = @"estimatedProgress";
static NSString *const LL_WKWebView_Title = @"title";


@interface LLWebViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic,strong) WKWebView *wkWebView;  // WKWebView
@property (nonatomic,strong) UIRefreshControl *refreshControl; // 刷新
@property (nonatomic,strong) UIProgressView *progressView; // 进度条
@property (nonatomic,strong) UIButton *reloadButton; // 重新加载按钮

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem; // 返回按钮
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem; // 关闭按钮


@end

@implementation LLWebViewController

- (void)dealloc {
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"closeQZWebView"];
    
    
    [self.wkWebView removeObserver:self forKeyPath:LL_WKWebView_EstimatedProgress];
    [self.wkWebView removeObserver:self forKeyPath:LL_WKWebView_Title];
    [self.wkWebView stopLoading];
    self.wkWebView.UIDelegate = nil;
    self.wkWebView.navigationDelegate = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"加载中...";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];;
    // 下拉刷新关闭：H5有问题
    self.canDownRefresh = NO;
    
    [self initSubviews];
    [self loadRequest];
}

#pragma mark private Methods
- (void)initSubviews{
    [self showLeftBarButtonItem];
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.reloadButton];
}

- (void)loadRequest {
    if (![self.urlString hasPrefix:@"http"]) {
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
    [self.wkWebView loadRequest:request];
}

- (void)wkWebViewReload{
    [self.wkWebView reload];
}

- (void)showLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.closeBarButtonItem;
}

- (void)refreshJSAccessToken {
//    NSString *accessToken = [SDQZUserDefaultsUtils getUserDefaults:SDQZ_UserInfo_AccessToken defaultValue:nil];
    NSString *accessToken ;
    NSString *jsStr = [NSString stringWithFormat:@"refreshQZAccessToken('%@')", accessToken];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"H5页面token刷新失败：%@", result);
        } else {
            NSLog(@"H5页面token刷新成功：%@", error);
        }
    }];
}

#pragma mark - WKNavigationDelegate
/// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    self.wkWebView.hidden = NO;
    self.reloadButton.hidden = YES;
    // 看是否加载空网页
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
}

/// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self showLeftBarButtonItem];
    [self.refreshControl endRefreshing];
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
}

/// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"地址：%@",navigationResponse.response.URL.absoluteString);
    NSString *absoluteString = navigationResponse.response.URL.absoluteString;
    if ([absoluteString hasSuffix:@".pdf"]) {
        //不允许跳转
        decisionHandler(WKNavigationResponsePolicyCancel);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:absoluteString] options:@{} completionHandler:nil];
    } else {
        //允许跳转
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

/// 页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    webView.hidden = YES;
    self.reloadButton.hidden = NO;
}

#pragma mark - WKUIDelegate
// Alert弹框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    completionHandler();
}

// confirm弹框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
}

// TextInput弹框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
}

#pragma mark - WKScriptMessageHandler
/// js 拦截 调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"方法名:%@，参数:%@", message.name, message.body);
    if ([message.name isEqualToString:@"closeQZWebView"]) {
        // 关闭webView，推出当前页面
        [self dismissWebViewController];
    }
}

- (void)dismissWebViewController {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Event Responses
- (void)backAction:(UIBarButtonItem *)item {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        [self dismissWebViewController];
    }
}

- (void)closeAction:(UIBarButtonItem *)item {
    [self dismissWebViewController];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:LL_WKWebView_EstimatedProgress]) {
        self.progressView.progress = [change[@"new"] floatValue];
        if (self.progressView.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
            });
        }
    } else if ([keyPath isEqualToString:LL_WKWebView_Title]) {
        if (object == self.wkWebView) {
            self.title = self.wkWebView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Getters & Setters
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = ({
            // 设置WKWebView基本配置信息
            WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
            configuration.preferences = [[WKPreferences alloc] init];
            configuration.allowsInlineMediaPlayback = YES;
            configuration.selectionGranularity = YES;
            
            // 注册js方法
            WKUserContentController *userContentController = [[WKUserContentController alloc] init];
            [userContentController addScriptMessageHandler:[[LLWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"closeQZWebView"];
            
            if (self.jsString) {
                WKUserScript *jsString = [[WKUserScript alloc] initWithSource:self.jsString injectionTime:(WKUserScriptInjectionTimeAtDocumentStart) forMainFrameOnly:NO];
                [userContentController addUserScript:jsString];
            }
            configuration.userContentController = userContentController;
            
            WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT - LZY_IPHONE_NAV_STATUS_HEIGHT) configuration:configuration];
            wkWebView.UIDelegate = self;
            wkWebView.navigationDelegate = self;
            wkWebView.allowsBackForwardNavigationGestures = YES;
            
            // 是否开启下拉刷新
            if (_canDownRefresh) {
                if (@available(iOS 10.0, *)) {
                    wkWebView.scrollView.refreshControl = self.refreshControl;
                }
            }
            // 添加进度监听
            [wkWebView addObserver:self forKeyPath:LL_WKWebView_EstimatedProgress options:(NSKeyValueObservingOptionNew) context:nil];
            // 添加监听标题
            [wkWebView addObserver:self forKeyPath:LL_WKWebView_Title options:NSKeyValueObservingOptionNew context:nil];
            wkWebView;
        });
    }
    return _wkWebView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = ({
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            [refreshControl addTarget:self action:@selector(wkWebViewReload) forControlEvents:(UIControlEventValueChanged)];
            refreshControl;
        });
    }
    return _refreshControl;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = ({
            UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 2.0)];
            progressView.progressTintColor = [UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1];
            progressView.trackTintColor = [UIColor whiteColor];;
            progressView;
        });
    }
    return _progressView;
}

- (UIButton *)reloadButton{
    if (!_reloadButton) {
        _reloadButton = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(0, -100, 155.5, 94.5);
            button.center = self.view.center;
            [button setBackgroundImage:[UIImage imageNamed:@"Tips_Network"] forState:UIControlStateNormal];
            [button setTitle:@"网络异常，点击重新加载" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(wkWebViewReload) forControlEvents:(UIControlEventTouchUpInside)];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
            button.titleLabel.numberOfLines = 0;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
//            button.frame.origin.y -= 100;
            button.hidden = YES;;
            
            button;
        });
    }
    return _reloadButton;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 36.0, 36.0)];
            [button setImage:[UIImage imageNamed:@"Nav_Back_Icon_web"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
            button.tintColor = [UIColor colorWithRed:24/255.0 green:129/255.0 blue:247/255.0 alpha:1];
            
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            buttonItem;
        });
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = ({
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
            buttonItem;
        });
    }
    return _closeBarButtonItem;
}

@end

