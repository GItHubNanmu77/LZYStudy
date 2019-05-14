//
//  LZYActionSheetAlterManager.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYActionSheetAlterManager.h"
#import "IAPManager.h"

@interface LZYActionSheetAlterManager ()

@end

@implementation LZYActionSheetAlterManager

// 单例
SINGLETON_FOR_CLASS(LZYActionSheetAlterManager)

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

- (void)showActionSheet:(UIViewController *)vc message:(NSString *)message handlerConfirmAction:(void (^)(void))handlerConfirmAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !handlerConfirmAction ?: handlerConfirmAction();
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

@end
