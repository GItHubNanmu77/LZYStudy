//
//  LZYDeviceUtils.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZYDeviceUtils : NSObject

/**
 *  设备别名
 *
 *  @return <#return value description#>
 */
+ (NSString *)name;

/**
 *  设备型号
 *
 *  @return <#return value description#>
 */
+ (NSString *)model;

/**
 *  系统名称
 *
 *  @return <#return value description#>
 */
+ (NSString *)systemName;

/**
 *  系统版本
 *
 *  @return <#return value description#>
 */
+ (NSString *)systemVersion;

/**
 *  App 名称
 *
 *  @return <#return value description#>
 */
+ (NSString *)CFBundleDisplayName;

/**
 *  App 版本号
 *
 *  @return <#return value description#>
 */
+ (NSString *)CFBundleShortVersionString;

/**
 *  App 编译号
 *
 *  @return <#return value description#>
 */
+ (NSString *)CFBundleVersion;

/**
 *  App 标识符
 *
 *  @return <#return value description#>
 */
+ (NSString *)bundleIdentifier;

/**
 *  设备空余容量
 *
 *  @return return value description
 */
+ (int64_t)diskSpaceFree;

@end

NS_ASSUME_NONNULL_END
