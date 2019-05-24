//
//  NSMutableAttributedString+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/15.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSMutableAttributedString+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

#import <UIKit/UIKit.h>

@interface NSObject (MutableAttributedString)
+ (void)swizzleForMutableAttributedString;
@end

@implementation NSObject (MutableAttributedString)
+ (void)swizzleForMutableAttributedString {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(safeM_attributedSubstringFromRange:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(attributedSubstringFromRange:)];
    });
}

- (NSAttributedString *)safeM_attributedSubstringFromRange:(NSRange)range {
    NSAttributedString *attr = nil;
    @try {
        attr = [self safeM_attributedSubstringFromRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return attr;
    }
}

@end

@implementation NSMutableAttributedString (QTSafe)

+ (void)load {
//#if !DEBUG
        [self swizzleInstanceMethod:@selector(safeM_initWithString:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(initWithString:)];
        [self swizzleInstanceMethod:@selector(safeM_initWithString:attributes:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(initWithString:attributes:)];
        [self swizzleInstanceMethod:@selector(safeM_replaceCharactersInRange:withString:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(replaceCharactersInRange:withString:)];
        [self swizzleInstanceMethod:@selector(safeM_setAttributes:range:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(setAttributes:range:)];
        [self swizzleInstanceMethod:@selector(safeM_addAttributes:range:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(addAttributes:range:)];
        [self swizzleInstanceMethod:@selector(safeM_removeAttribute:range:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(removeAttribute:range:)];
        [self swizzleInstanceMethod:@selector(safeM_replaceCharactersInRange:withAttributedString:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(replaceCharactersInRange:withAttributedString:)];
        
        [NSObject swizzleForMutableAttributedString];
        
        [self swizzleInstanceMethod:@selector(safeM_addAttribute:value:range:)
                           tarClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                             tarSel:@selector(addAttribute:value:range:)];
        
//        [self test];
//#endif
}

- (instancetype)safeM_initWithString:(NSString *)str {
    
    id instance = nil;
    @try {
        instance = [self safeM_initWithString:str];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
        instance = [self safeM_initWithString:@""];
    } @finally {
        return instance;
    }
}

- (instancetype)safeM_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    
    id instance = nil;
    @try {
        instance = [self safeM_initWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        
        instance = [self safeM_initWithString:@"" attributes:attrs];
    } @finally {
        return instance;
    }
}

- (void)safeM_replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    if (range.location + range.length > self.length || !str) {
        return;
    }
    @try {
        [self safeM_replaceCharactersInRange:range withString:str];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (void)safeM_replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString {
    if (range.location + range.length > self.length || !attrString) {
        return;
    }
    @try {
        [self safeM_replaceCharactersInRange:range withAttributedString:attrString];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)safeM_setAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeM_setAttributes:attrs range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)safeM_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeM_addAttributes:attrs range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)safeM_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeM_removeAttribute:name range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

- (void)safeM_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range {
    @try {
        [self safeM_addAttribute:name value:value range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    }
}

#pragma mark - Debug

//+ (void)test {
//    
//    id value = nil;
//    NSMutableAttributedString *test = [[NSMutableAttributedString alloc] initWithString:value attributes:value];
//    test = [[NSMutableAttributedString alloc] initWithString:value];
//    test = [[NSMutableAttributedString alloc] initWithAttributedString:value];
//    
//    test = [[NSMutableAttributedString alloc] initWithString:@"1111"];
//    NSRange range;
//    range = NSMakeRange(0, 10);
//    id t = [test attributedSubstringFromRange:range];
//    
//    range = NSMakeRange(0, 2);
//     t = [test attributedSubstringFromRange:range];
//    
//    range = NSMakeRange(0, 10);
//    [test replaceCharactersInRange:range withString:value];
//    [test addAttribute:NSLinkAttributeName value:value range:range];
//    [test addAttributes:value range:range];
//    [test removeAttribute:NSLinkAttributeName range:range];
//    [test replaceCharactersInRange:range withString:value];
//    [test insertAttributedString:value atIndex:10];
//    [test appendAttributedString:value];
//    [test deleteCharactersInRange:range];
//    [test setAttributedString:value];
//}

@end
