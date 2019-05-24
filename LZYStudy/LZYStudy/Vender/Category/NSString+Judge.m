//
//  NSString+Judge.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/23.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "NSString+Judge.h"

@implementation NSString (Judge)
- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)validateUserName {
    NSString *nameRegex = @"^([a-z]|[A-Z]|[\u4e00-\u9fa5]|[\\s]|[0-9])*$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:self];
    
}

- (BOOL)validatePassword{
    if (self.length < 6 && self.length > 20) {
        return NO;
    }
    
    NSString *numberRegex = @"^.*[0-9]+.*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    BOOL isContainNumber =[numberTest evaluateWithObject:self];
    NSString *SmallLetter = @"^.*[a-z]+.*$";
    NSPredicate *SmallLetterTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",SmallLetter];
    BOOL isContainSmallLetter = [SmallLetterTest evaluateWithObject:self];
    NSString *CapitalLetterRegex = @"^.*[A-Z]+.*$";
    NSPredicate *CapitalLetterTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CapitalLetterRegex];
    BOOL isContainCapitalLetter = [CapitalLetterTest evaluateWithObject:self];
    NSString *SymbolRegex = @"^.*[^a-zA-Z0-9]+.*$";
    NSPredicate *SymbolTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",SymbolRegex];
    BOOL isContainSymbol = [SymbolTest evaluateWithObject:self];
    
    BOOL isValidate = NO;
    int count = 0;
    if (isContainNumber) {
        count++;
    }
    if (isContainSmallLetter) {
        count++;
    }
    if (isContainCapitalLetter) {
        count++;
    }
    if (isContainSymbol) {
        count++;
    }
    if (count >= 2) {
        isValidate = YES;
    }
    return isValidate;
}

- (BOOL)containEmoji
{
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

- (BOOL)isURL {
    NSString *urlRegex = @"(((https?|ftp)://)|(www(\\.)){1})[-A-Za-z0-9+&@#/%?=~_|!:,;]+(\\.){1}[-A-Za-z0-9+&@#/:%=~_|.?]+";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlPredicate evaluateWithObject:self];
}

//- (BOOL)isInputChinese {
//     判断当前输入法是否是中文
//    bool isChinese;
//
//    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"en-US"]) {
//        isChinese = false;
//    } else {
//        isChinese = true;
//    }
//    if (isChinese) {
//        // 中文输入法下
//        UITextRange *selectedRange = [textField markedTextRange];
//        // 获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
//                [self.delegate searchBar:self textDidChange:textField.text];
//            }
//        } else {
//            // 输入的英文还没有转化为汉字的状态
//        }
//    } else {
//        // 英文输入法下
//        if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
//            [self.delegate searchBar:self textDidChange:textField.text];
//        }
//    }
//}
@end
