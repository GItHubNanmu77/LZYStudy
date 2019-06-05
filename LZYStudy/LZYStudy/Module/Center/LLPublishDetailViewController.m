//
//  LLPublishDetailViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/7.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLPublishDetailViewController.h"
#import "LLWebViewController.h"
#import <PPNetworkHelper/PPNetworkHelper.h>
#import "LZYBaseRequest.h"
#import "LLCenterDetailPostRequest.h"
#import "LZYDownloadRequest.h"

@interface LLPublishDetailViewController ()

@end

@implementation LLPublishDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor magentaColor];
    self.title = @"发布详情";
    self.name = @"123123123";
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 100, 100, 50)];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(150, 200, 100, 50)];
    btn3.backgroundColor = [UIColor yellowColor];
    [btn3 addTarget:self action:@selector(loadListData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
}

- (void)btnAction {
    NSString *url = @"http://file-test.qingzhuyun.com/41673c078ee04a109dbf5877c5ce4b57/1464dfe66cc14eb29cbd7104515e401b.pdf";
    
    [PPNetworkHelper downloadWithURL:url fileDir:nil progress:^(NSProgress *progress) {
        [SVProgressHUD showProgress:progress.fractionCompleted status:@"下载中"];
    } success:^(NSString *filePath) {
        [SVProgressHUD showSuccessWithStatus:@"下载完成"];
        NSLog(@"---%@",filePath);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)action{
    NSString *url = @"http://file-test.qingzhuyun.com/41673c078ee04a109dbf5877c5ce4b57/1464dfe66cc14eb29cbd7104515e401b.pdf";
    LZYDownloadRequest *request = [[LZYDownloadRequest alloc] initDownloadFileWithAPIURL:url fileName:nil fileDir:nil];
    
    [request startWithCompletionHandlerWithProgress:^(NSProgress * _Nonnull progress) {
        [SVProgressHUD showProgress:progress.fractionCompleted status:@"下载中"];
    } success:^(NSString * _Nonnull filePath) {
        [SVProgressHUD showSuccessWithStatus:@"下载完成"];
        NSLog(@"==%@",filePath);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)loadListData {
    LLCenterDetailPostRequest *request = [[LLCenterDetailPostRequest alloc] initPreWarningDetailWithoutTokenAPI:@"94b5ece42bde4754a2634d721506e0a6"];
    [request startWithCompletionHandlerWithSuccess:^(__kindof LZYBaseRequest * _Nonnull request, id  _Nonnull response) {
        if (response) {
            NSDictionary *dic = response;
            NSLog(@"data===%@",dic);
        }
    } failure:^(__kindof LZYBaseRequest * _Nonnull request, NSInteger code, NSString * _Nonnull errorMsg) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LLWebViewController *vc = [[LLWebViewController alloc] init];
    vc.urlString = @"";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
