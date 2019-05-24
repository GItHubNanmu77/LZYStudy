//
//  NSString+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/9.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSString+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSString (QTSafe)

+ (void) load {
//#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleClassMethod:@selector(stringWithCString:encoding:)
                            with:@selector(safe_stringWithCString:encoding:)];
        
        //__NSCFConstantString
        [self swizzleInstanceMethod:@selector(safe_characterAtIndex:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(characterAtIndex:)];
        [self swizzleInstanceMethod:@selector(safe_substringFromIndex:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(substringFromIndex:)];
        [self swizzleInstanceMethod:@selector(safe_substringToIndex:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(substringToIndex:)];
        [self swizzleInstanceMethod:@selector(safe_substringWithRange:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(substringWithRange:)];
        [self swizzleInstanceMethod:@selector(safe_getCharacters:range:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(getCharacters:range:)];
        [self swizzleInstanceMethod:@selector(safe_rangeOfComposedCharacterSequenceAtIndex:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(rangeOfComposedCharacterSequenceAtIndex:)];
        [self swizzleInstanceMethod:@selector(safe_getLineStart:end:contentsEnd:forRange:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(getLineStart:end:contentsEnd:forRange:)];
        [self swizzleInstanceMethod:@selector(safe_getBlockStart:end:contentsEnd:forRange:stopAtLineSeparators:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:NSSelectorFromString(@"_getBlockStart:end:contentsEnd:forRange:stopAtLineSeparators:")];
        [self swizzleInstanceMethod:@selector(safe_enumerateSubstringsInRange:options:usingBlock:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(enumerateSubstringsInRange:options:usingBlock:)];

        //NSTaggedPointerString
        [self swizzleInstanceMethod:@selector(safePointer_characterAtIndex:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:@selector(characterAtIndex:)];
        [self swizzleInstanceMethod:@selector(safePointer_substringFromIndex:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:@selector(substringFromIndex:)];
        [self swizzleInstanceMethod:@selector(safePointer_substringToIndex:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:@selector(substringToIndex:)];
        [self swizzleInstanceMethod:@selector(safePointer_substringWithRange:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:@selector(substringWithRange:)];
        [self swizzleInstanceMethod:@selector(safePointer_getCharacters:range:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:@selector(getCharacters:range:)];
        [self swizzleInstanceMethod:@selector(safePointer_rangeOfComposedCharacterSequenceAtIndex:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:@selector(rangeOfComposedCharacterSequenceAtIndex:)];
        [self swizzleInstanceMethod:@selector(safePointer_getLineStart:end:contentsEnd:forRange:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:@selector(getLineStart:end:contentsEnd:forRange:)];
        [self swizzleInstanceMethod:@selector(safePointer_getBlockStart:end:contentsEnd:forRange:stopAtLineSeparators:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:NSSelectorFromString(@"_getBlockStart:end:contentsEnd:forRange:stopAtLineSeparators:")];
        [self swizzleInstanceMethod:@selector(safePointer_enumerateSubstringsInRange:options:usingBlock:)
                           tarClass:NSClassFromString(@"NSTaggedPointerString")
                             tarSel:@selector(enumerateSubstringsInRange:options:usingBlock:)];
        
        //NSBigMutableString
        [self swizzleInstanceMethod:@selector(safeBig_characterAtIndex:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:@selector(characterAtIndex:)];
        [self swizzleInstanceMethod:@selector(safeBig_substringFromIndex:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:@selector(substringFromIndex:)];
        [self swizzleInstanceMethod:@selector(safeBig_substringToIndex:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:@selector(substringToIndex:)];
        [self swizzleInstanceMethod:@selector(safeBig_substringWithRange:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:@selector(substringWithRange:)];
        [self swizzleInstanceMethod:@selector(safeBig_getCharacters:range:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:@selector(getCharacters:range:)];
        [self swizzleInstanceMethod:@selector(safeBig_rangeOfComposedCharacterSequenceAtIndex:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:@selector(rangeOfComposedCharacterSequenceAtIndex:)];
        [self swizzleInstanceMethod:@selector(safeBig_getLineStart:end:contentsEnd:forRange:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:@selector(getLineStart:end:contentsEnd:forRange:)];
        [self swizzleInstanceMethod:@selector(safeBig_getBlockStart:end:contentsEnd:forRange:stopAtLineSeparators:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:NSSelectorFromString(@"_getBlockStart:end:contentsEnd:forRange:stopAtLineSeparators:")];
        [self swizzleInstanceMethod:@selector(safeBig_enumerateSubstringsInRange:options:usingBlock:)
                           tarClass:NSClassFromString(@"NSBigMutableString")
                             tarSel:@selector(enumerateSubstringsInRange:options:usingBlock:)];
        
//        [NSString test];
    });
//#endif
}

+ (nullable instancetype)safe_stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc {
    if (!cString) {
        return nil;
    }
    id str;
    @try {
        str = [self safe_stringWithCString:cString encoding:enc];
    } @catch (NSException *exception) {
        
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return str;
    }
}

#pragma mark - __NSCFConstantString

- (unichar)safe_characterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        return 0;
    }
    
    unichar character;
    @try {
        character = [self safe_characterAtIndex:index];
    } @catch (NSException *exception) {
        
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return character;
    }
}

- (NSString *)safe_substringFromIndex:(NSUInteger)from {
    
    if (from > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safe_substringFromIndex:from];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        str = nil;
    } @finally {
        
        return str;
    }
}

- (NSString *)safe_substringToIndex:(NSUInteger)to {
    
    if (to > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safe_substringToIndex:to];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        str = nil;
    } @finally {
        
        return str;
    }
}

- (NSString *)safe_substringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safe_substringWithRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        //越界，将str赋值为nil，以免取到垃圾值
        str = nil;
    } @finally {
        return str;
    }
}

- (void)safe_getCharacters:(unichar *)buffer range:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    
    @try {
        [self safe_getCharacters:buffer range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (NSRange)safe_rangeOfComposedCharacterSequenceAtIndex:(NSUInteger)index {
    NSRange range = NSMakeRange(0, 0);
    if (index > self.length) {
        return range;
    }

    @try {
        range = [self safe_rangeOfComposedCharacterSequenceAtIndex:index];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return range;
    }
}

- (void)safe_getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safe_getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safe_getBlockStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range stopAtLineSeparators:(BOOL)stop {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safe_getBlockStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range stopAtLineSeparators:stop];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safe_enumerateSubstringsInRange:(NSRange)range options:(NSStringEnumerationOptions)opts usingBlock:(void (^)(NSString * _Nullable, NSRange, NSRange, BOOL * _Nonnull))block {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safe_enumerateSubstringsInRange:range options:opts usingBlock:block];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

#pragma mark - NSTaggedPointerString

- (unichar)safePointer_characterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        return 0;
    }
    
    unichar character;
    @try {
        character = [self safePointer_characterAtIndex:index];
    } @catch (NSException *exception) {
        
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return character;
    }
}

- (NSString *)safePointer_substringFromIndex:(NSUInteger)from {
    
    if (from > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safePointer_substringFromIndex:from];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        str = nil;
    } @finally {
        
        return str;
    }
}

- (NSString *)safePointer_substringToIndex:(NSUInteger)to {
    
    if (to > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safePointer_substringToIndex:to];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        str = nil;
    } @finally {
        
        return str;
    }
}

- (NSString *)safePointer_substringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safePointer_substringWithRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        //越界，将str赋值为nil，以免取到垃圾值
        str = nil;
    } @finally {
        return str;
    }
}

- (void)safePointer_getCharacters:(unichar *)buffer range:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    
    @try {
        [self safePointer_getCharacters:buffer range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (NSRange)safePointer_rangeOfComposedCharacterSequenceAtIndex:(NSUInteger)index {
    NSRange range = NSMakeRange(0, 0);
    if (index > self.length) {
        return range;
    }
    
    @try {
        range = [self safePointer_rangeOfComposedCharacterSequenceAtIndex:index];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return range;
    }
}

- (void)safePointer_getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safePointer_getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safePointer_getBlockStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range stopAtLineSeparators:(BOOL)stop {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safePointer_getBlockStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range stopAtLineSeparators:stop];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safePointer_enumerateSubstringsInRange:(NSRange)range options:(NSStringEnumerationOptions)opts usingBlock:(void (^)(NSString * _Nullable, NSRange, NSRange, BOOL * _Nonnull))block {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safePointer_enumerateSubstringsInRange:range options:opts usingBlock:block];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

#pragma mark - NSBigMutableString

- (unichar)safeBig_characterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        return 0;
    }
    
    unichar character;
    @try {
        character = [self safeBig_characterAtIndex:index];
    } @catch (NSException *exception) {
        
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return character;
    }
}

- (NSString *)safeBig_substringFromIndex:(NSUInteger)from {
    
    if (from > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safeBig_substringFromIndex:from];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        str = nil;
    } @finally {
        
        return str;
    }
}

- (NSString *)safeBig_substringToIndex:(NSUInteger)to {
    
    if (to > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safeBig_substringToIndex:to];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        str = nil;
    } @finally {
        
        return str;
    }
}

- (NSString *)safeBig_substringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safeBig_substringWithRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        //越界，将str赋值为nil，以免取到垃圾值
        str = nil;
    } @finally {
        return str;
    }
}

- (void)safeBig_getCharacters:(unichar *)buffer range:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    
    @try {
        [self safeBig_getCharacters:buffer range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (NSRange)safeBig_rangeOfComposedCharacterSequenceAtIndex:(NSUInteger)index {
    NSRange range = NSMakeRange(0, 0);
    if (index > self.length) {
        return range;
    }
    
    @try {
        range = [self safeBig_rangeOfComposedCharacterSequenceAtIndex:index];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return range;
    }
}

- (void)safeBig_getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeBig_getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeBig_getBlockStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range stopAtLineSeparators:(BOOL)stop {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeBig_getBlockStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range stopAtLineSeparators:stop];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeBig_enumerateSubstringsInRange:(NSRange)range options:(NSStringEnumerationOptions)opts usingBlock:(void (^)(NSString * _Nullable, NSRange, NSRange, BOOL * _Nonnull))block {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeBig_enumerateSubstringsInRange:range options:opts usingBlock:block];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

#pragma mark - Debug

+ (void)test {
    NSString *tmpConstantString = @"1"; //__NSCFConstantString
    NSString *tmpPointerString = [NSString stringWithFormat:@"4"]; //NSTaggedPointerString
    NSString *tmpBigString = [[NSClassFromString(@"NSBigMutableString") alloc] init]; //NSTaggedPointerString
    
    //__NSCFConstantString/NSTaggedPointerString/__NSCFString
    unichar charBuffer[2];
    NSUInteger s, e, ce;
    
    [tmpPointerString characterAtIndex:10];
    [tmpPointerString substringFromIndex:10];
    [tmpPointerString substringToIndex:10];
    [tmpPointerString substringWithRange:NSMakeRange(10, 10)];
    [tmpPointerString getCharacters:charBuffer range:NSMakeRange(10, 10)];
    [tmpPointerString rangeOfComposedCharacterSequenceAtIndex:10];
    [tmpPointerString rangeOfComposedCharacterSequencesForRange:NSMakeRange(10, 10)];
    [tmpPointerString getLineStart:&s end:&e contentsEnd:&ce forRange:NSMakeRange(10, 10)];
    [tmpPointerString lineRangeForRange:NSMakeRange(10, 10)];
    [tmpPointerString getParagraphStart:&s end:&e contentsEnd:&ce forRange:NSMakeRange(10, 10)];
    [tmpPointerString paragraphRangeForRange:NSMakeRange(10, 10)];
    [tmpPointerString enumerateSubstringsInRange:NSMakeRange(0, 10) options:NSStringEnumerationByLines usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
    }];
    [tmpPointerString stringByReplacingOccurrencesOfString:@"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 10)];
    [tmpPointerString stringByReplacingCharactersInRange:NSMakeRange(0, 10) withString:@""];
    
    [tmpConstantString characterAtIndex:10];
    [tmpConstantString substringFromIndex:10];
    [tmpConstantString substringToIndex:10];
    [tmpConstantString substringWithRange:NSMakeRange(10, 10)];
    [tmpConstantString getCharacters:charBuffer range:NSMakeRange(10, 10)];
    [tmpConstantString rangeOfComposedCharacterSequenceAtIndex:10];
    [tmpConstantString rangeOfComposedCharacterSequencesForRange:NSMakeRange(10, 10)];
    [tmpConstantString getLineStart:&s end:&e contentsEnd:&ce forRange:NSMakeRange(10, 10)];
    [tmpConstantString lineRangeForRange:NSMakeRange(10, 10)];
    [tmpConstantString getParagraphStart:&s end:&e contentsEnd:&ce forRange:NSMakeRange(10, 10)];
    [tmpConstantString paragraphRangeForRange:NSMakeRange(10, 10)];
    [tmpConstantString enumerateSubstringsInRange:NSMakeRange(0, 10) options:NSStringEnumerationByLines usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
    }];
    [tmpConstantString stringByReplacingOccurrencesOfString:@"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 10)];
    [tmpConstantString stringByReplacingCharactersInRange:NSMakeRange(0, 10) withString:@""];
    
    [tmpBigString characterAtIndex:10];
    [tmpBigString substringFromIndex:10];
    [tmpBigString substringToIndex:10];
    [tmpBigString substringWithRange:NSMakeRange(10, 10)];
    [tmpBigString getCharacters:charBuffer range:NSMakeRange(10, 10)];
    [tmpBigString rangeOfComposedCharacterSequenceAtIndex:10];
    [tmpBigString rangeOfComposedCharacterSequencesForRange:NSMakeRange(10, 10)];
    [tmpBigString getLineStart:&s end:&e contentsEnd:&ce forRange:NSMakeRange(10, 10)];
    [tmpBigString lineRangeForRange:NSMakeRange(10, 10)];
    [tmpBigString getParagraphStart:&s end:&e contentsEnd:&ce forRange:NSMakeRange(10, 10)];
    [tmpBigString paragraphRangeForRange:NSMakeRange(10, 10)];
    [tmpBigString enumerateSubstringsInRange:NSMakeRange(0, 10) options:NSStringEnumerationByLines usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
    }];
    [tmpBigString stringByReplacingOccurrencesOfString:@"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 10)];
    [tmpBigString stringByReplacingCharactersInRange:NSMakeRange(0, 10) withString:@""];
}

@end
