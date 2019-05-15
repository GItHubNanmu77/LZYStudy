//
//  LZYSheetAlertManager.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYSheetAlertManager.h"
#import "IAPManager.h"
#import "LZYDeviceUtils.h"

@interface LZYSheetAlertManager ()

@end

@implementation LZYSheetAlertManager 

// 单例
SINGLETON_FOR_CLASS(LZYSheetAlertManager)

- (void)showSelectPicSourceActionSheet:(UIViewController *)vc handlerCameraPicker:(void (^)(void))handlerCameraPicker handlerAlbumPicker:(void (^)(void))handlerAlbumPicker handlerCancel:(void (^)(void))handlerCancel {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !handlerCameraPicker ?: handlerCameraPicker();
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !handlerAlbumPicker ?: handlerAlbumPicker();
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

- (void)showVersionCheckActionSheet:(UIViewController *)vc handlerConfirmAction:(void (^)(void))handlerConfirmAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"App有新的版本需要更新" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        !handlerConfirmAction ?: handlerConfirmAction();
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

- (void)showActionSheet:(UIViewController *)vc message:(NSString *)message sheets:(NSArray<NSString *> *)sheets handlerConfirmAction:(void (^)(NSInteger))handlerConfirmAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i=0; i<sheets.count; i++) {
        NSString *title = sheets[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !handlerConfirmAction ?: handlerConfirmAction(i);
        }];
        [alertVC addAction:action];
    }
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

- (void)showAlert:(UIViewController *)vc title:(NSString *)title message:(NSString *)message handlerConfirmAction:(void (^)(void))handlerConfirmAction {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !handlerConfirmAction ?: handlerConfirmAction();
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

- (void)showSettingAlert:(UIViewController *)vc deviceName:(NSString *)deviceName {
    NSString *title = [NSString stringWithFormat:@"%@权限已关闭", deviceName];
    NSString *message = [self settingTips:deviceName];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url =  [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

/**
 *  权限设置提示
 *
 *  @param deviceName 设备名
 *
 *  @return <#return value description#>
 */
- (NSString *)settingTips:(NSString *)deviceName {
    NSString *tips;
    if (deviceName.length > 0) {
        tips = [NSString stringWithFormat:@"请到[设置]->[隐私]->[%@]中开启[%@]%@权限", deviceName, [LZYDeviceUtils CFBundleDisplayName], deviceName];
    } else {
        tips = [NSString stringWithFormat:@"请到[设置]->[隐私]中开启[%@]对应的权限", [LZYDeviceUtils CFBundleDisplayName]];
    }
    
    return tips;
}

@end
