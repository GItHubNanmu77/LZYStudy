//
//  LZYGCDTimer.m
//  LZYStudy
//
//  Created by cisdi on 2019/8/8.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYGCDTimer.h"

@implementation LZYGCDTimer

+ (instancetype)shareLZYGCDTimer {
    static LZYGCDTimer *timer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (timer == nil) {
            timer = [[self alloc] init];
        }
    });
    return timer;
}
- (void)countDown {
    @LZY_weakify(self)
    if (self.timeout >0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            @LZY_strongify(self)
            if(self.timeout <= 0){//倒计时结束，关闭
                dispatch_source_cancel(_timer);
            }else{
                self.timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}
 

@end
