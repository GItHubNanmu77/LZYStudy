//
//  NSObject+GrowingIO.m
//  QTCategory
//
//  Created by 张俊博 on 2018/10/10.
//

#import "NSObject+GrowingIO.h"
#import <objc/runtime.h>

@implementation NSObject (GrowingIO)

+ (void)load {
    Method exchangeM = class_getInstanceMethod(NSClassFromString(@"__NSFrozenDictionaryM"), @selector(growingHelper_safeSubStringWithLength:));
    class_addMethod(NSClassFromString(@"__NSFrozenDictionaryM"), @selector(growingHelper_safeSubStringWithLength:), class_getMethodImplementation(self, @selector(growingHelper_safeSubStringWithLength:)),method_getTypeEncoding(exchangeM));
}

- (NSString *)growingHelper_safeSubStringWithLength:(NSInteger)length {
    return nil;
}

@end
