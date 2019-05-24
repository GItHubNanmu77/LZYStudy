//
//  NSObject+Zombie.h
//  QTCategory
//
//  Created by 张俊博 on 2018/4/11.
//  Copyright © 2018年 CISDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Zombie)

+ (void)enableZombie;
- (BOOL)zombie_dealloc;

@end
