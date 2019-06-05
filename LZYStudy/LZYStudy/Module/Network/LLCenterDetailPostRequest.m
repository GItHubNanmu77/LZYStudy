//
//  LLCenterDetailPostRequest.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/5.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLCenterDetailPostRequest.h"

@implementation LLCenterDetailPostRequest
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}


- (id)initPreWarningDetailWithoutTokenAPI:(NSString *)recordId  {
    self = [super init];
    if (self) {
//        self.requestAPIUrl = @"http://10.73.1.205:882/api/client/device/deviceMonitor/getWarningList";
        self.requestAPIUrl = @"http://10.73.1.205:882/api/client/device/deviceMonitor/getInfoById";
        self.requestParamDict = @{@"recordId":recordId};
    }
    return  self;
}

@end
