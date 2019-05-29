//
//  LLPublishDetailViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/7.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLPublishDetailViewController.h"
#import "LLWebViewController.h"

@interface LLPublishDetailViewController ()

@end

@implementation LLPublishDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor magentaColor];
    self.title = @"发布详情";
    self.name = @"123123123";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LLWebViewController *vc = [[LLWebViewController alloc] init];
    vc.urlString = @"";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
