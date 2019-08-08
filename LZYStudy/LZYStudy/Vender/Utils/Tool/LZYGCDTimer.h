//
//  LZYGCDTimer.h
//  LZYStudy
//
//  Created by cisdi on 2019/8/8.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZYGCDTimer : NSObject

@property (nonatomic,assign)__block int timeout;

+ (instancetype)shareLZYGCDTimer;

- (void)countDown;
@end

NS_ASSUME_NONNULL_END
