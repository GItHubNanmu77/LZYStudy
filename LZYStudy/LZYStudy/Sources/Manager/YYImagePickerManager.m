//
//  YYImagePickerManager.m
//  Project
//
//  Created by luowei on 2018/12/4.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYImagePickerManager.h"

@interface YYImagePickerManager()
@property (nonatomic, strong) UIViewController *currentVC;
@end

@implementation YYImagePickerManager

- (void)showActionWithVC:(UIViewController*)vc withBlock:(void(^)(YYImagePickerType actionType))block{
    self.clickBlockAction = block;
    self.currentVC = vc;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self albumSelectphoto];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cameraShootingphoto];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:albumAction];
    [alertController addAction:cameraAction];
    [vc presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - UIActionSheetDelegate
- (void)albumSelectphoto{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"支持相册");
        if (self.clickBlockAction) {
            self.clickBlockAction(YYImagePickerTypePhotosAlbum);
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:knowAction];
        [self.currentVC presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)cameraShootingphoto{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"支持相机");
        if (self.clickBlockAction) {
            self.clickBlockAction(YYImagePickerTypeCamera);
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:knowAction];
        [self.currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
@end
