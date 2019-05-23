//
//  LLWeakScriptMessageDelegate.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLWeakScriptMessageDelegate.h"

@implementation LLWeakScriptMessageDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
