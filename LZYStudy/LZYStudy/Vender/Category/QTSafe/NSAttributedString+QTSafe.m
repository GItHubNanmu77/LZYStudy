//
//  NSAttributedString+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/15.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSAttributedString+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

#import <UIKit/UIKit.h>

@implementation NSAttributedString (QTSafe)

+ (void)load {
//#if !DEBUG
        [self swizzleInstanceMethod:@selector(safe_initWithString:)
                           tarClass:NSClassFromString(@"NSConcreteAttributedString")
                             tarSel:@selector(initWithString:)];
        [self swizzleInstanceMethod:@selector(safe_initWithAttributedString:)
                           tarClass:NSClassFromString(@"NSConcreteAttributedString")
                             tarSel:@selector(initWithAttributedString:)];
        [self swizzleInstanceMethod:@selector(safe_initWithString:attributes:)
                           tarClass:NSClassFromString(@"NSConcreteAttributedString")
                             tarSel:@selector(initWithString:attributes:)];
//        if (@available(iOS 10.0, *)) {
            [self swizzleInstanceMethod:@selector(safe_attributedSubstringFromRange:)
                               tarClass:NSClassFromString(@"NSConcreteAttributedString")
                                 tarSel:@selector(attributedSubstringFromRange:)];
//        }

        
//        [self test];
    //#endif
}

- (instancetype)safe_initWithString:(NSString *)str {
    
    id instance = nil;
    @try {
        instance = [self safe_initWithString:str];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return instance;
    }
}

- (instancetype)safe_initWithAttributedString:(NSAttributedString *)attrStr {
    id instance = nil;
    @try {
        instance = [self safe_initWithAttributedString:attrStr];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return instance;
    }
    
}

- (instancetype)safe_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    
    id instance = nil;
    @try {
        instance = [self safe_initWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return instance;
    }
}

- (NSAttributedString *)safe_attributedSubstringFromRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return nil;
    }
    id instance = nil;
    @try {
        instance = [self safe_attributedSubstringFromRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return instance;
    }
}


#pragma mark - Debug

//+ (void)test {
//    id value = nil;
//    NSAttributedString *test = [[NSAttributedString alloc] initWithString:value attributes:value];
//    test = [[NSAttributedString alloc] initWithString:value];
//    test = [[NSAttributedString alloc] initWithAttributedString:value];
//    
//    test = [[NSAttributedString alloc] initWithString:@"11111"];
//    NSRange range;
//    range = NSMakeRange(0, 10);
//    id t = [test attributedSubstringFromRange:range];
//    
//    range = NSMakeRange(0, 2);
//     t = [test attributedSubstringFromRange:range];
//    NSLog(@"");
//}

@end
