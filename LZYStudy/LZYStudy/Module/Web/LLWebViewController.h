//
//  LLWebViewController.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLWebViewController : UIViewController

/// 请求的url：必填
@property (nonatomic,copy) NSString *urlString;
/// 要注入的js方法：非必填
@property (nonatomic,copy) NSString *jsString;
/// 是否下拉重新加载：非必填
@property (nonatomic, assign) BOOL canDownRefresh;

@end

NS_ASSUME_NONNULL_END
