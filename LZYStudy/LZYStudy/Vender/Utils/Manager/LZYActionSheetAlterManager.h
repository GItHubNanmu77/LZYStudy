//
//  LZYActionSheetAlterManager.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZYActionSheetAlterManager : NSObject

SINGLETON_FOR_HEADER(LZYActionSheetAlterManager)

/**
 相册选择提示框
 */
- (void)showSelectPicSourceActionSheet:(UIViewController *)vc handlerCameraPicker:(void (^)(void))handlerCameraPicker handlerAlbumPicker:(void (^)(void))handlerAlbumPicker handlerCancel:(void (^)(void))handlerCancel;

/**
 版本更新提示框
 */
- (void)showVersionCheckActionSheet:(UIViewController *)vc handlerConfirmAction:(void (^)(void))handlerConfirmAction;

/**
 自定义sheet提示框
 */
- (void)showActionSheet:(UIViewController *)vc handlerCameraPicker:(void (^)(void))handlerCameraPicker handlerAlbumPicker:(void (^)(void))handlerAlbumPicker handlerCancel:(void (^)(void))handlerCancel;

@end

NS_ASSUME_NONNULL_END
