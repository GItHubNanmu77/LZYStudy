//
//  NSException+QTSafe.m
//  QTCategory
//
//  Created by 张俊博 on 2018/7/26.
//

#import "NSException+QTSafe.h"
#import "NSObject+QTAdd.h"
//#import "QTCategoryMacro.h"
//#import "UIDevice+QTAdd.h"

@implementation NSException (QTSafe)

+ (void)load {
    [self swizzleClassMethod:@selector(raise:format:) with:@selector(safe_raise:format:)];
}

//Iphone 5 10.3.3 启动崩溃
/*
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'An instance 0x14620de0 of class _UIPreviewGestureRecognizer was deallocated while key value observers were still registered with it. Current observation info: <NSKeyValueObservationInfo 0x147a5d90> (
 <NSKeyValueObservance 0x147a5d70: Observer: 0x147a5920, Key path: requiredPreviewForceState, Options: <New: YES, Old: NO, Prior: NO> Context: 0x38ffe50c, Property: 0x147a59c0>
 )'
 *** First throw call stack:
 (0x1c693b3d 0x1b91b067 0x1c693a85 0x1cf52729 0x1b935259 0x1b9357a1 0x1b91cca7 0x1b91dd09 0x16b0be7 0x16be549 0x16bd693 0x16bd717 0x16b0fa7 0x16b5153 0x16b01d1 0x16b0040)
 */
+ (void)safe_raise:(NSExceptionName)name format:(NSString *)format, ... {
    NSString *str = [NSString stringWithFormat:@"%@", format];
//    if ([name isEqualToString:@"NSInternalInconsistencyException"]
//        && [str containsString:@"_UIPreviewGestureRecognizer"]
//        && SYSTEM_VERSION_EQUAL_TO(@"10.3.3")
//        && [[UIDevice currentDevice].machineModelName isEqualToString:@"iPhone 5"]) {
//
//    } else {
        [self safe_raise:name format:format];
//    }
}

@end
