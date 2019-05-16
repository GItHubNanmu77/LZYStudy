//
//  SDQZEncryptUtils.m
//  QingZhu
//
//  Created by xian yang on 2019/1/23.
//  Copyright © 2019年 xian yang. All rights reserved.
//

#import "SDQZEncryptUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "MF_Base64Additions.h"

#define FBENCRYPT_ALGORITHM kCCAlgorithmDES
#define FBENCRYPT_BLOCK_SIZE kCCBlockSizeDES
#define FBENCRYPT_KEY_SIZE kCCKeySizeDES

static NSString *_key = @"VE:~%Az9";

@implementation SDQZEncryptUtils

/**
 *  MD5 加密
 *
 *  @param plainText <#plainText description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)MD5:(NSString *)plainText {
    const char *cStr = [plainText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

/**
 *  DES 加密
 *
 *  @param plainText <#plainText description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)DESEncode:(NSString *)plainText {
    NSString *result = nil;
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [[_key dataUsingEncoding:NSUTF8StringEncoding] getBytes:cKey length:FBENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    [[_key dataUsingEncoding:NSUTF8StringEncoding] getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    
    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do decrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, FBENCRYPT_ALGORITHM, kCCOptionPKCS7Padding, cKey, FBENCRYPT_KEY_SIZE, cIv, [data bytes], [data length], buffer, bufferSize, &decryptedSize);
    
    if (cryptStatus == kCCSuccess) {
        result = [MF_Base64Codec base64StringFromData:[NSData dataWithBytesNoCopy:buffer length:decryptedSize]];
    } else {
        free(buffer);
    }
    
    return result;
}

/**
 *  DES 解密
 *
 *  @param plainText <#plainText description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)DESDecode:(NSString *)plainText {
    NSString *result = nil;
    NSData *data = [MF_Base64Codec dataFromBase64String:plainText];
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [[_key dataUsingEncoding:NSUTF8StringEncoding] getBytes:cKey length:FBENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    [[_key dataUsingEncoding:NSUTF8StringEncoding] getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    
    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do decrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, FBENCRYPT_ALGORITHM, kCCOptionPKCS7Padding, cKey, FBENCRYPT_KEY_SIZE, cIv, [data bytes], [data length], buffer, bufferSize, &decryptedSize);
    
    if (cryptStatus == kCCSuccess) {
        result = [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:buffer length:decryptedSize] encoding:NSUTF8StringEncoding];
    } else {
        free(buffer);
    }
    
    return result;
}

@end
