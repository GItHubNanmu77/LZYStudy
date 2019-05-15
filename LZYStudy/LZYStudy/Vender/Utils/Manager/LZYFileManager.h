//
//  LZYFileManager.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/15.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZYFileManager : NSObject

/**
 *  格式化Byte，KB, MB
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)formatByte:(unsigned long long)size;

/**
 *  读取文件
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getFileWithName:(NSString *)name;

/**
 *  获取文件MD5
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getFileMD5WithPath:(NSString *)path;

/**
 *  获取文档路径
 *
 *  @param pathname <#pathname description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getDocumentDirectory:(NSString *)pathname;

/**
 *  删除文件
 *
 *  @param path 文件路径
 *
 *  @return <#return value description#>
 */
+ (BOOL)deleteFileAtPath:(NSString *)path;

/**
 *  获取Documents下文件
 *
 *  @param filename <#filename description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getDocumentWithFileName:(NSString *)filename;


/**
 *  获取 NSData MD5
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getMD5WithData:(NSData *)data;


/**
 *  获取文件名(带后缀)
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getFileNameAtPath:(NSString *)path;


/**
 *  获取文件大小
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+ (unsigned long long)getFileSizeAtPath:(NSString *)path;
 

@end

NS_ASSUME_NONNULL_END
