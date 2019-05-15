//
//  LZYFileManager.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/15.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYFileManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation LZYFileManager

/**
 *  格式化Byte, KB, MB, G
 *
 *  @param size size description
 *
 *  @return return value description
 */
+ (NSString *)formatByte:(unsigned long long)size {
    float f;
    if (size < 1024 * 1024) {
        f = ((float)size / 1024.0);
        return [NSString stringWithFormat:@"%.2fKB", f];
    } else if (size >= 1024 * 1024 && size < 1024 * 1024 * 1024) {
        f = ((float)size / (1024.0 * 1024.0));
        return [NSString stringWithFormat:@"%.2fMB", f];
    }
    f = ((float)size / (1024.0 * 1024.0 * 1024.0));
    return [NSString stringWithFormat:@"%.2fG", f];
}

/**
 *  读取文件
 *
 *  @param name name description
 *
 *  @return return value description
 */
+ (NSString *)getFileWithName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]];
    NSString *path = [resourcePath stringByAppendingPathComponent:name];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return text;
}

/**
 *  获取文件MD5
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getFileMD5WithPath:(NSString *)path {
    if (path.length == 0) {
        return nil;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"%s 不存在", __FUNCTION__);
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (handle == nil) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while (!done) {
        NSData *fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, fileData.bytes, fileData.length);
        if ([fileData length] == 0) {
            done = YES;
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *result =
    [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7], digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15]];
    
    return result;
}

/**
 *  获取文档路径
 *
 *  @param pathname <#pathname description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getDocumentDirectory:(NSString *)pathname {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *userFolderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/", pathname]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:userFolderPath]) {
        [fileManager createDirectoryAtPath:userFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return userFolderPath;
}

/**
 *  删除文件
 *
 *  @param path 文件路径
 *
 *  @return <#return value description#>
 */
+ (BOOL)deleteFileAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/**
 *  获取Documents下文件
 *
 *  @param filename <#filename description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getDocumentWithFileName:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *userFolderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/", filename]];
    return userFolderPath;
}

/**
 *  获取 NSData MD5
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getMD5WithData:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

/**
 *  获取文件名(带后缀)
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getFileNameAtPath:(NSString *)path {
    NSURL *pathURL = [NSURL URLWithString:path];
    return pathURL.lastPathComponent;
}

/**
 *  获取文件大小
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+ (unsigned long long)getFileSizeAtPath:(NSString *)path {
    NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    if (fileDictionary) {
        // make use of attributes
        return [fileDictionary[@"NSFileSize"] longLongValue];
    }
    return 0;
}

@end
 
