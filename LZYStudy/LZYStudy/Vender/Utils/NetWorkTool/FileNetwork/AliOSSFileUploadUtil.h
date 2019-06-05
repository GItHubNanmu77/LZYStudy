//
//  AliOSSFileUploadUtil.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/8.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 阿里OSS上传文件
 */

typedef NS_ENUM(NSInteger, UploadDataState) {
    UploadDataFailed   = 0,
    UploadDataSuccess  = 1
};
typedef NS_ENUM(NSInteger, UploadDataType) {
    
    UploadDataTypeImage = 0,
    UploadDataTypeVideo = 1,
    UploadDataTypeAudio = 2,
    UploadDataTypeLocation = 3,
    UploadDataTypeImageGIF = 4,
};

@interface AliOSSFileUploadUtil : NSObject


+ (void)asyncUploadData:(NSData *)data Type:(UploadDataType )type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names,UploadDataState state,NSArray<NSString *> *urls))complete;

+ (void)syncUploadData:(NSData *)data Type:(UploadDataType )type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names,UploadDataState state,NSArray<NSString *> *urls))complete;

+ (void)asyncUploadDatas:(NSArray<NSData *> *)datas Type:(UploadDataType )type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names, UploadDataState state,NSArray<NSString *> *urls))complete;

+ (void)syncUploadDatas:(NSArray<NSData *> *)datas Type:(UploadDataType )type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names, UploadDataState state ,NSArray<NSString *> *urls))complete;


@end
