//
//  YYNetworkingConfig.m
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYNetworkingConfig.h"

static NSString *const DEFAULT_CODE_STRING = @"code";
static NSString *const DEFAULT_MESSAGE_STRING = @"msg";

@implementation YYNetworkingConfig

+ (YYNetworkingConfig *)shareInstance
{
    static YYNetworkingConfig * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YYNetworkingConfig alloc] init];
    });
    
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.requestSerializerType = RequestSerializerTypeHttp;
        self.status = DEFAULT_CODE_STRING;
        self.message = DEFAULT_MESSAGE_STRING;
    }
    return self;
}

@end
