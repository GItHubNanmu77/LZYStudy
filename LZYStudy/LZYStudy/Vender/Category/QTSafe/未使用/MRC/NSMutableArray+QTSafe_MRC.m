//
//  NSMutableArray+QTSafe_MRC.m
//  QTCategory
//
//  Created by 张俊博 on 2017/2/9.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import "NSMutableArray+QTSafe_MRC.h"
#import "NSObject+QTAdd.h"
#import "NSObject+Exceptioin.h"

@implementation NSMutableArray (QTSafe_MRC)

+ (void)load {
//#if !DEBUG
                [self swizzleInstanceMethod:@selector(safeM_objectAtIndex:)
                                   tarClass:NSClassFromString(@"__NSArrayM")
                                     tarSel:@selector(objectAtIndex:)];
//#endif
}

- (id)safeM_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    id objc = nil;
    @try {
        objc = [self safeM_objectAtIndex:index];
    } @catch (NSException *exception) {
        
        [NSObject printExceptionReason:exception];
        
    } @finally {
        return  objc;
    }
}


@end
