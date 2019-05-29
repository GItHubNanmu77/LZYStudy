//
//  LZYAuthorizationUtils.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYAuthorizationUtils.h"



#import "BlocksKit+UIKit.h"
#import "LZYDeviceUtils.h"

@implementation LZYAuthorizationUtils

#pragma mark - 检测是否开启消息推送
+ (void)openMessageNotificationServiceWithBlock:(ReturnBlock)returnBlock
{
    BOOL isOpen = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types != UIUserNotificationTypeNone) {
        isOpen = YES;
    }
#else
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (type != UIRemoteNotificationTypeNone) {
        isOpen = YES;
    }
#endif
    if (returnBlock) {
        returnBlock(isOpen);
    }
}

#pragma mark - 检测是否允许访问相机
+ (void)openCaptureDeviceServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (returnBlock) {
                returnBlock(granted);
            }
        }];
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        returnBlock(NO);
    } else {
        returnBlock(YES);
    }
#endif
}

#pragma mark - 检测是否允许访问手机相册
+ (void)openAlbumServiceWithBlock:(ReturnBlock)returnBlock
{
    BOOL isOpen;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    isOpen = YES;
    if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
        isOpen = NO;
    }
#else
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    isOpen = YES;
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        isOpen = NO;
    }
#endif
    if (returnBlock) {
        returnBlock(isOpen);
    }
}

#pragma mark - 检测是否允许访问麦克风
+ (void)openRecordServiceWithBlock:(ReturnBlock)returnBlock
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (returnBlock) {
                returnBlock(granted);
            }
        }];
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        returnBlock(NO);
    } else {
        returnBlock(YES);
    }
#endif
}

#pragma mark - 检测是否允许使用定位服务
+ (void)openLocationServiceWithBlock:(ReturnBlock)returnBlock  {
    BOOL isOpen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOpen = YES;
    }
    if (returnBlock) {
        returnBlock(isOpen);
    }
}

#pragma mark - 是否开启通讯录
+ (void)openContactsServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CNAuthorizationStatus cnAuthStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (cnAuthStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
            if (returnBolck) {
                returnBolck(granted);
            }
        }];
    } else if (cnAuthStatus == CNAuthorizationStatusRestricted || cnAuthStatus == CNAuthorizationStatusDenied) {
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#else
    //ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@", (__bridge NSError *)error);
                    if (returnBolck) {
                        returnBolck(NO);
                    }
                } else {
                    if (returnBolck) {
                        returnBolck(YES);
                    }
                }
            });
        });
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#endif
}


#pragma mark - 是否开启蓝牙
//+ (void)openPeripheralServiceWithBolck:(ReturnBlock)returnBolck
//{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//    CBPeripheralManagerAuthorizationStatus cbAuthStatus = [CBPeripheralManager authorizationStatus];
//    if (cbAuthStatus == CBPeripheralManagerAuthorizationStatusNotDetermined) {
//        if (returnBolck) {
//            returnBolck(NO);
//        }
//    } else if (cbAuthStatus == CBPeripheralManagerAuthorizationStatusRestricted || cbAuthStatus == CBPeripheralManagerAuthorizationStatusDenied) {
//        if (returnBolck) {
//            returnBolck(NO);
//        }
//    } else {
//        if (returnBolck) {
//            returnBolck(YES);
//        }
//    }
//#endif
//}

#pragma mark -  是否开启联网
+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
        if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
            if (returnBolck) {
                returnBolck(NO);
            }
        } else {
            if (returnBolck) {
                returnBolck(YES);
            }
        }
    };
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#endif
}

#pragma mark - 是否开启健康
//+ (void)openHealthServiceWithBolck:(ReturnBlock)returnBolck
//{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
//    if (![HKHealthStore isHealthDataAvailable]) {
//        if (returnBolck) {
//            returnBolck(NO);
//        }
//    } else {
//        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
//        HKObjectType *hkObjectType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//        HKAuthorizationStatus hkAuthStatus = [healthStore authorizationStatusForType:hkObjectType];
//        if (hkAuthStatus == HKAuthorizationStatusNotDetermined) {
//            // 1. 你创建了一个NSSet对象，里面存有本篇教程中你将需要用到的从Health Stroe中读取的所有的类型：个人特征（血液类型、性别、出生日期）、数据采样信息（身体质量、身高）以及锻炼与健身的信息。
//            NSSet <HKObjectType *> * healthKitTypesToRead = [[NSSet alloc] initWithArray:@[[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType],[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],[HKObjectType workoutType]]];
//            // 2. 你创建了另一个NSSet对象，里面有你需要向Store写入的信息的所有类型（锻炼与健身的信息、BMI、能量消耗、运动距离）
//            NSSet <HKSampleType *> * healthKitTypesToWrite = [[NSSet alloc] initWithArray:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],[HKObjectType workoutType]]];
//            [healthStore requestAuthorizationToShareTypes:healthKitTypesToWrite readTypes:healthKitTypesToRead completion:^(BOOL success, NSError *error) {
//                if (returnBolck) {
//                    returnBolck(success);
//                }
//            }];
//        } else if (hkAuthStatus == HKAuthorizationStatusSharingDenied) {
//            if (returnBolck) {
//                returnBolck(NO);
//            }
//        } else {
//            if (returnBolck) {
//                returnBolck(YES);
//            }
//        }
//    }
//#endif
//}

#pragma mark - 开启Touch ID服务
//+ (void)openTouchIDServiceWithBlock:(ReturnBlock)returnBlock
//{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
//    LAContext *laContext = [[LAContext alloc] init];
//    laContext.localizedFallbackTitle = @"输入密码";
//    NSError *error;
//    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
//        NSLog(@"恭喜,Touch ID可以使用!");
//        [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError *error) {
//            if (success) {
//                // 识别成功
//                if (returnBlock) {
//                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        returnBlock(YES);
//                    }];
//                }
//            } else if (error) {
//                if (returnBlock) {
//                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        returnBlock(NO);
//                    }];
//                }
//                if (error.code == LAErrorAuthenticationFailed) {
//                    // 验证失败
//                }
//                if (error.code == LAErrorUserCancel) {
//                    // 用户取消
//                }
//                if (error.code == LAErrorUserFallback) {
//                    // 用户选择输入密码
//                }
//                if (error.code == LAErrorSystemCancel) {
//                    // 系统取消
//                }
//                if (error.code == LAErrorPasscodeNotSet) {
//                    // 密码没有设置
//                }
//            }
//        }];
//    } else {
//        NSLog(@"设备不支持Touch ID功能,原因:%@",error);
//        if (returnBlock) {
//            returnBlock(NO);
//        }
//    }
//#endif
//}

#pragma mark - 开启Apple Pay服务
//+ (void)openApplePayServiceWithBlock:(ReturnBlock)returnBlock
//{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
//    NSArray<PKPaymentNetwork> *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkDiscover];
//    if ([PKPaymentAuthorizationViewController canMakePayments] && [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
//        if (returnBlock) {
//            returnBlock(YES);
//        }
//    } else {
//        if (returnBlock) {
//            returnBlock(NO);
//        }
//    }
//#endif
//}

#pragma mark - 开启语音识别服务
//+ (void)openSpeechServiceWithBlock:(ReturnBlock)returnBlock
//{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//    SFSpeechRecognizerAuthorizationStatus speechAuthStatus = [SFSpeechRecognizer authorizationStatus];
//    if (speechAuthStatus == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
//        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
//            if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (returnBlock) {
//                        returnBlock(YES);
//                    }
//                });
//            } else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (returnBlock) {
//                        returnBlock(YES);
//                    }
//                });
//            }
//        }];
//    } else if (speechAuthStatus == SFSpeechRecognizerAuthorizationStatusAuthorized) {
//        if (returnBlock) {
//            returnBlock(YES);
//        }
//    } else{
//        if (returnBlock) {
//            returnBlock(NO);
//        }
//    }
//#endif
//}

#pragma mark - 开启媒体资料库/Apple Music 服务
//+ (void)openMediaPlayerServiceWithBlock:(ReturnBlock)returnBlock
//{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_3
//    MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
//    if (authStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
//        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
//            if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (returnBlock) {
//                        returnBlock(YES);
//                    }
//                });
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (returnBlock) {
//                        returnBlock(NO);
//                    }
//                });
//            }
//        }];
//    }else if (authStatus == MPMediaLibraryAuthorizationStatusAuthorized){
//        if (returnBlock) {
//            returnBlock(YES);
//        }
//    }else{
//        if (returnBlock) {
//            returnBlock(NO);
//        }
//    }
//#endif
//}

#pragma mark - 开启Siri服务
//+ (void)openSiriServiceWithBlock:(ReturnBlock)returnBlock
//{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//    INSiriAuthorizationStatus siriAutoStatus = [INPreferences siriAuthorizationStatus];
//    if (siriAutoStatus == INSiriAuthorizationStatusNotDetermined) {
//        [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
//            if (status == INSiriAuthorizationStatusAuthorized) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (returnBlock) {
//                        returnBlock(YES);
//                    }
//                });
//            } else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (returnBlock) {
//                        returnBlock(YES);
//                    }
//                });
//            }
//        }];
//    } else if (siriAutoStatus == INSiriAuthorizationStatusAuthorized) {
//        if (returnBlock) {
//            returnBlock(YES);
//        }
//    } else{
//        if (returnBlock) {
//            returnBlock(NO);
//        }
//    }
//#endif
//}

#pragma mark - 开启日历备忘录
//+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck withType:(EKEntityType )entityType
//{
//    // EKEntityTypeEvent    代表日历
//    // EKEntityTypeReminder 代表备忘
//    EKAuthorizationStatus ekAuthStatus = [EKEventStore authorizationStatusForEntityType:entityType];
//    if (ekAuthStatus == EKAuthorizationStatusNotDetermined) {
//        EKEventStore *store = [[EKEventStore alloc] init];
//        [store requestAccessToEntityType:entityType completion:^(BOOL granted, NSError *error) {
//            if (returnBolck) {
//                returnBolck(granted);
//            }
//        }];
//    } else if (ekAuthStatus == EKAuthorizationStatusRestricted || ekAuthStatus == EKAuthorizationStatusDenied) {
//        if (returnBolck) {
//            returnBolck(NO);
//        }
//    } else {
//        if (returnBolck) {
//            returnBolck(YES);
//        }
//    }
//}

#pragma mark - 检测是否开启3DTouch
//+ (BOOL)isForceTouchAvailable:(UITraitCollection *)traitCollection {
//    BOOL isForceTouchAvailable = NO;
//    if ([traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
//        isForceTouchAvailable = traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
//    }
//    return isForceTouchAvailable;
//}

/**
 *  权限设置提示
 *
 *  @param deviceName 设备名
 *
 *  @return <#return value description#>
 */
+ (NSString *)settingTips:(NSString *)deviceName {
    NSString *tips;
    if (deviceName.length > 0) {
        tips = [NSString stringWithFormat:@"请到[设置]->[隐私]->[%@]中开启[%@]%@权限", deviceName, [LZYDeviceUtils CFBundleDisplayName], deviceName];
    } else {
        tips = [NSString stringWithFormat:@"请到[设置]->[隐私]中开启[%@]对应的权限", [LZYDeviceUtils CFBundleDisplayName]];
    }
    
    return tips;
}

/**
 *  弹出提示
 *
 *  @param deviceName 设备名
 */
+ (void)showAlertView:(NSString *)deviceName {
    NSString *title = [NSString stringWithFormat:@"%@权限已关闭", deviceName];
    NSString *message = [self settingTips:deviceName];
    [UIAlertView bk_showAlertViewWithTitle:title
                                   message:message
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex){
                                   }];
}
@end

