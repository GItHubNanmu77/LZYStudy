//
//  NSObject+Exceptioin.h
//  QTCategory
//
//  Created by 张俊博 on 2017/4/27.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Exceptioin)

+ (void)printExceptionReason:(NSException *)exception;
+ (void)printExceptionString:(NSString *)exception;

@end
