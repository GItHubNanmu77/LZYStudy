//
//  LZYAuthorizationUtils.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <Photos/Photos.h>
#import <CoreTelephony/CTCellularData.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <HealthKit/HealthKit.h>
#import <PassKit/PassKit.h>
#import <Speech/Speech.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Intents/Intents.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

#if NS_BLOCKS_AVAILABLE
typedef void(^ReturnBlock)(BOOL isOpen);
#endif

@interface LZYAuthorizationUtils : NSObject
 
#pragma mark - 检测是否开启消息推送
+ (void)openMessageNotificationServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 检测是否允许访问相机
+ (void)openCaptureDeviceServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 检测是否允许访问手机相册
+ (void)openAlbumServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 检测是否允许访问麦克风
+ (void)openRecordServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 检测是否允许使用定位服务
+ (void)openLocationServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 是否开启通讯录
+ (void)openContactsServiceWithBolck:(ReturnBlock)returnBolck;

#pragma mark - 是否开启蓝牙
+ (void)openPeripheralServiceWithBolck:(ReturnBlock)returnBolck;

#pragma mark -  是否开启联网
+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck;

#pragma mark - 是否开启健康
+ (void)openHealthServiceWithBolck:(ReturnBlock)returnBolck;

#pragma mark - 开启Touch ID服务
+ (void)openTouchIDServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 开启语音识别服务
+ (void)openSpeechServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 开启媒体资料库/Apple Music 服务
+ (void)openMediaPlayerServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 开启Siri服务
+ (void)openSiriServiceWithBlock:(ReturnBlock)returnBlock;

#pragma mark - 开启日历备忘录
+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck withType:(EKEntityType )entityType;

/**
 *  检测是否开启3DTouch
 *
 *  @param traitCollection <#traitCollection description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isForceTouchAvailable:(UITraitCollection *)traitCollection;

@end

NS_ASSUME_NONNULL_END
