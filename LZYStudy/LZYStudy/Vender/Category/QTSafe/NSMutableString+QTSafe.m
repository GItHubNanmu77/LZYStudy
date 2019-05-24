//
//  NSMutableString+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/9.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSMutableString+QTSafe.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSMutableString (QTSafe)

+ (void)load {
//#if !DEBUG
        //__NSCFString
        [self swizzleInstanceMethod:@selector(safeM_replaceOccurrencesOfString:withString:options:range:)
                           tarClass:NSClassFromString(@"__NSCFString")
                             tarSel:@selector(replaceOccurrencesOfString:withString:options:range:)];
        [self swizzleInstanceMethod:@selector(safeM_replaceCharactersInRange:withString:)
                           tarClass:NSClassFromString(@"__NSCFString")
                             tarSel:@selector(replaceCharactersInRange:withString:)];
        [self swizzleInstanceMethod:@selector(safeM_insertString:atIndex:)
                           tarClass:NSClassFromString(@"__NSCFString")
                             tarSel:@selector(insertString:atIndex:)];
        [self swizzleInstanceMethod:@selector(safeM_deleteCharactersInRange:)
                           tarClass:NSClassFromString(@"__NSCFString")
                             tarSel:@selector(deleteCharactersInRange:)];
//        [self swizzleInstanceMethod:@selector(safeM_characterAtIndex:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:@selector(characterAtIndex:)];
//        [self swizzleInstanceMethod:@selector(safeM_substringFromIndex:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:@selector(substringFromIndex:)];
//        [self swizzleInstanceMethod:@selector(safeM_substringToIndex:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:@selector(substringToIndex:)];
//        [self swizzleInstanceMethod:@selector(safeM_substringWithRange:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:@selector(substringWithRange:)];
//        [self swizzleInstanceMethod:@selector(safeM_getCharacters:range:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:@selector(getCharacters:range:)];
//        [self swizzleInstanceMethod:@selector(safeM_rangeOfComposedCharacterSequenceAtIndex:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:@selector(rangeOfComposedCharacterSequenceAtIndex:)];
//        [self swizzleInstanceMethod:@selector(safeM_getLineStart:end:contentsEnd:forRange:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:@selector(getLineStart:end:contentsEnd:forRange:)];
//        [self swizzleInstanceMethod:@selector(safeM_getBlockStart:end:contentsEnd:forRange:stopAtLineSeparators:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:NSSelectorFromString(@"_getBlockStart:end:contentsEnd:forRange:stopAtLineSeparators:")];
//        [self swizzleInstanceMethod:@selector(safeM_enumerateSubstringsInRange:options:usingBlock:)
//                           tarClass:NSClassFromString(@"__NSCFString")
//                             tarSel:@selector(enumerateSubstringsInRange:options:usingBlock:)];
        
        
        [self swizzleInstanceMethod:@selector(safe_appendString:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(appendString:)];
        [self swizzleInstanceMethod:@selector(safe_appendFormat:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(appendFormat:)];
        [self swizzleInstanceMethod:@selector(safe_setString:)
                           tarClass:NSClassFromString(@"__NSCFConstantString")
                             tarSel:@selector(setString:)];
        

//        [NSMutableString test];
//#endif
}

#pragma mark __NSCFString

- (NSUInteger)safeM_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    
    NSInteger location = 0;
    if (searchRange.location + searchRange.length > self.length) {
        return location;
    }
    
    @try {
        location = [self safeM_replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return location;
    }
}

- (void)safeM_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if (range.location + range.length > self.length) {
        return;
    }
    
    @try {
        [self safeM_replaceCharactersInRange:range withString:aString];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (void)safeM_insertString:(NSString *)aString atIndex:(NSUInteger)index {
    if (index > [self length] || !aString) {
        return;
    }
    @try {
        [self safeM_insertString:aString atIndex:index];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeM_deleteCharactersInRange:(NSRange)range {
    
    if (range.location + range.length > self.length) {
        return;
    }
    
    @try {
        [self safeM_deleteCharactersInRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (unichar)safeM_characterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        return 0;
    }
    
    unichar character;
    @try {
        character = [self safeM_characterAtIndex:index];
    } @catch (NSException *exception) {
        
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return character;
    }
}

- (NSString *)safeM_substringFromIndex:(NSUInteger)from {
    
    if (from > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safeM_substringFromIndex:from];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        str = nil;
    } @finally {
        
        return str;
    }
}

- (NSString *)safeM_substringToIndex:(NSUInteger)to {

    if (to > self.length) {
        return nil;
    }

    NSString *str = nil;
    @try {
        str = [self safeM_substringToIndex:to];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        str = nil;
    } @finally {

        return str;
    }
}

- (NSString *)safeM_substringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return nil;
    }
    
    NSString *str = nil;
    @try {
        str = [self safeM_substringWithRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
        //越界，将str赋值为nil，以免取到垃圾值
        str = nil;
    } @finally {
        return str;
    }
}

- (void)safeM_getCharacters:(unichar *)buffer range:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    
    @try {
        [self safeM_getCharacters:buffer range:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
    }
}

- (NSRange)safeM_rangeOfComposedCharacterSequenceAtIndex:(NSUInteger)index {
    NSRange range = NSMakeRange(0, 0);
    if (index > self.length) {
        return range;
    }
    
    @try {
        range = [self safeM_rangeOfComposedCharacterSequenceAtIndex:index];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        return range;
    }
}

- (void)safeM_getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeM_getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeM_getBlockStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range stopAtLineSeparators:(BOOL)stop {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeM_getBlockStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range stopAtLineSeparators:stop];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safeM_enumerateSubstringsInRange:(NSRange)range options:(NSStringEnumerationOptions)opts usingBlock:(void (^)(NSString * _Nullable, NSRange, NSRange, BOOL * _Nonnull))block {
    if (range.location + range.length > self.length) {
        return;
    }
    @try {
        [self safeM_enumerateSubstringsInRange:range options:opts usingBlock:block];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

#pragma mark - __NSCFConstantString

- (void)safe_appendString:(NSString *)aString {
    if (!aString) {
        return;
    }
    @try {
        [self safe_appendString:aString];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}

- (void)safe_appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
    if (!format) {
        return;
    }
    
    @try {
        va_list arguments;
        va_start(arguments, format);
        NSString *formatStr = [[NSString alloc] initWithFormat:format arguments:arguments];
        [self safe_appendFormat:@"%@",formatStr];
        va_end(arguments);
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
    
}

- (void)safe_setString:(NSString *)aString {
    if (!aString) {
        return;
    }
    @try {
        [self safe_setString:aString];
    } @catch (NSException *exception) {
        [NSObject printExceptionReason:exception];
    } @finally {
        
    }
}



#pragma mark - Debug

//+ (void)test {
//    NSMutableString *tmpCFString = [NSMutableString stringWithFormat:@"1"]; //__NSCFString
//    id value = nil;
//    NSString *str = nil;
//    
//    //__NSCFConstantString/NSTaggedPointerString/__NSCFString
////    [tmpCFString characterAtIndex:10];
////    [tmpCFString substringFromIndex:10];
////    [tmpCFString substringToIndex:10];
////    [tmpCFString substringWithRange:NSMakeRange(10, 10)];
//    unichar charBuffer[2];
////    [tmpCFString getCharacters:charBuffer range:NSMakeRange(10, 10)];
////    [tmpCFString rangeOfComposedCharacterSequenceAtIndex:10];
////    [tmpCFString rangeOfComposedCharacterSequencesForRange:NSMakeRange(10, 10)];
////    NSUInteger s, e, ce;
////    [tmpCFString getLineStart:&s end:&e contentsEnd:&ce forRange:NSMakeRange(10, 10)];
////    [tmpCFString lineRangeForRange:NSMakeRange(10, 10)];
////    [tmpCFString getParagraphStart:&s end:&e contentsEnd:&ce forRange:NSMakeRange(10, 10)];
////    [tmpCFString paragraphRangeForRange:NSMakeRange(10, 10)];
////    [tmpCFString enumerateSubstringsInRange:NSMakeRange(0, 10) options:NSStringEnumerationByLines usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
////
////    }];
//    [tmpCFString stringByReplacingOccurrencesOfString:@"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 10)];
//    [tmpCFString stringByReplacingCharactersInRange:NSMakeRange(0, 10) withString:@""];
//    [NSString stringWithCharacters:charBuffer length:10];
//    
//    //__NSCFString
//    [tmpCFString replaceCharactersInRange:NSMakeRange(0, 10) withString:@""];
//    [tmpCFString insertString:@"" atIndex:10];
//    [tmpCFString deleteCharactersInRange:NSMakeRange(0, 10)];
//    [tmpCFString appendString:value];
//    [tmpCFString appendFormat:str, value];
//    [tmpCFString setString:value];
//    [tmpCFString replaceOccurrencesOfString:@"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 10)];
//}


@end
