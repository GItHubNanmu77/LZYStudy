//
//  LZYSheetAlertManager.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZYSheetAlertManager : NSObject

SINGLETON_FOR_HEADER(LZYSheetAlertManager)

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
- (void)showActionSheet:(UIViewController *)vc message:(nullable NSString *)message sheets:(NSArray <NSString *>*)sheets handlerConfirmAction:(void (^)(NSInteger sheetTag))handlerConfirmAction;
/**
 自定义alert提示框
 */
- (void)showAlert:(UIViewController *)vc  title:(NSString *)title message:(NSString *)message handlerConfirmAction:(void (^)(void))handlerConfirmAction;

/**
 权限设置提示
 */
- (void)showSettingAlert:(UIViewController *)vc deviceName:(NSString *)deviceName;
@end

NS_ASSUME_NONNULL_END
