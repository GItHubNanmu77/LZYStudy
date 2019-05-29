//
//  LLPdfReaderViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/28.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLPdfReaderViewController.h"


@interface LLPdfReaderViewController ()<UIDocumentInteractionControllerDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSURL *fileURL;
@property (nonatomic, strong) UIBarButtonItem *item;
@end

@implementation LLPdfReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.fileURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"QzTeam" ofType:@"pdf"]];
    [self initWebView];
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"分享"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    rightButton.tintColor = RGB3(51);
    self.item = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)rightBtnAction:(UIBarButtonItem*)sender{
    [self shareDoc];
}

- (void)initWebView {
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.fileURL];
    [self.webView loadRequest:request];
    //使文档的显示范围适合UIWebView的bounds
    [self.webView setScalesPageToFit:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在加载中...";
}

- (void)shareDoc {
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"QzTeam" ofType:@"pdf"]];
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    
    self.documentController.delegate = self; // UIDocumentInteractionControllerDelegate
    
//    [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
    [self.documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

#pragma mark - UIDocumentInteractionControllerDelegate methods

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    self.documentController = nil;
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
    }
    return _webView;
}

@end
