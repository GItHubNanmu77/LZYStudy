//
//  NSObject+Exceptioin.m
//  QTCategory
//
//  Created by 张俊博 on 2017/4/27.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSObject+Exceptioin.h"

@implementation NSObject (Exceptioin)

+ (void)printExceptionReason:(NSException *)exception {
    
    NSArray *symbols = [NSThread callStackSymbols];
    NSString *symbolsString = [self priseMainCallStackSymbols:symbols];
    
    NSString *errorReason = exception.reason;
    
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"QTCrash" withString:@""];
    NSString *logMsg = [NSString stringWithFormat:@"\n%@\n%@\n", errorReason, symbolsString];
    NSLog(@"!!!!!!!!!!!!!!!!!! CRASH !!!!!!!!!!!!!!!!!!!!!!");
    NSLog(@"!!!!!!!!!!!!!!!!!! CRASH !!!!!!!!!!!!!!!!!!!!!!");
    NSLog(@"!!!!!!!!!!!!!!!!!! CRASH !!!!!!!!!!!!!!!!!!!!!!");
    NSLog(@"crash: %@",logMsg);
    NSLog(@"!!!!!!!!!!!!!!!!!! CRASH !!!!!!!!!!!!!!!!!!!!!!");
    NSLog(@"!!!!!!!!!!!!!!!!!! CRASH !!!!!!!!!!!!!!!!!!!!!!");
    NSLog(@"!!!!!!!!!!!!!!!!!! CRASH !!!!!!!!!!!!!!!!!!!!!!");
}

+ (void)printExceptionString:(NSString *)exception {
    NSArray *symbols = [NSThread callStackSymbols];
    NSString *symbolsString = [self priseMainCallStackSymbols:symbols];
    
    NSString *errorReason = exception;
    
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"QTCrash" withString:@""];
    NSString *logMsg = [NSString stringWithFormat:@"\n%@\n%@\n", errorReason, symbolsString];
    NSLog(@"crash: %@",logMsg);
    
}

+ (NSString *)priseMainCallStackSymbols:(NSArray *)callStackSymbols {
    
    //log格式，+[类名 方法名] 或者 -[类名 方法名]
    __block NSString *symbolsMessage = nil;
    
    //匹配格式
    NSString *regluarStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regluarExp = [[NSRegularExpression alloc] initWithPattern:regluarStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int idx = 2; idx<callStackSymbols.count; idx++) {
        
        NSString *symbolStr = callStackSymbols[idx];
        
        [regluarExp enumerateMatchesInString:symbolStr options:NSMatchingReportProgress range:NSMakeRange(0, symbolStr.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString *callStackSymbolMsg = [symbolStr substringWithRange:result.range];
                //get className
                NSString *className = [callStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    symbolsMessage = callStackSymbolMsg;
                    
                }
                *stop = YES;
            }
        }];
        
        if (symbolsMessage.length) {
            break;
        }
    }
    
    return symbolsMessage;
}

@end
