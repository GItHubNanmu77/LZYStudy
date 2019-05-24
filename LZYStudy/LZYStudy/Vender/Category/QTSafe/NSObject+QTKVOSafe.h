//
//  NSObject+QTKVOSafe.h
//  QTCategory
//
//  Created by 张俊博 on 2017/11/2.
//  Copyright © 2017年 CISDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QTKVOSafe)

+ (void)swizzleKVO;

- (void)_qt_removeAllNSObjectKVOTargets;

@end

@interface QTKVOWeakOberserver : NSObject

@property (nullable, nonatomic, weak) id weakObserver;

@end
