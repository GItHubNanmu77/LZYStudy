//
//  LLWeakScriptMessageDelegate.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 防止WKWebView初始化WKUserContentController关闭页面不调用dealloc导致的内存泄露
 */
@interface LLWeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;


@end

NS_ASSUME_NONNULL_END
