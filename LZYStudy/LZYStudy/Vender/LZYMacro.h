//
//  LZY_Macro.h
//  LZY_Study
//
//  Created by cisdi on 2019/4/19.
//  Copyright © 2019 LZY_. All rights reserved.
//

#ifndef LZYMacro_h
#define LZYMacro_h

#import "BlocksKit+UIKit.h"
#import "NSDate+Transfer.h"
#import "NSString+Transfer.h"
#import "UIView+Frame.h"
#import "UIImage+Zip.h"
#import "NSDictionary+SafeAccess.h"
#import "MBProgressHUD+XY.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry/Masonry.h>


/// 当前设备iOS版本
#ifndef LZY_IOS_VERSION
#define LZY_IOS_VERSION [[UIDevice currentDevice].systemVersion doubleValue]
#endif
/// 是否为 视网膜屏
#ifndef LZY_IS_RETINA
#define LZY_IS_RETINA ([UIScreen instancesRespondToSelector:@selector(scale)] ? (2 == [[UIScreen mainScreen] scale]) : NO)
#endif
/// 是否为 3倍视网膜屏
#ifndef LZY_IS_3X_RETINA
#define LZY_IS_3X_RETINA ([UIScreen instancesRespondToSelector:@selector(scale)] ? (3 == [[UIScreen mainScreen] scale]) : NO)
#endif

/// 当前设备的屏幕宽度、高度
#ifndef LZY_SCREEN_WIDTH
#define LZY_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#endif
#ifndef LZY_SCREEN_HEIGHT
#define LZY_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#endif


/// 当前设备iOS版本
#ifndef LZY_IOS_VERSION
#define LZY_IOS_VERSION [[UIDevice currentDevice].systemVersion doubleValue]
#endif

// 设备：是否iPhone、iPad
#ifndef LZY_IS_IPHONE_DEVICE
#define LZY_IS_IPHONE_DEVICE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#endif
#ifndef LZY_IS_IPAD_DEVICE
#define LZY_IS_IPAD_DEVICE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif


// iPhone X 宏定义(iPhone X、iPhone XR、iPhone XS、iPhone XS Max)
#ifndef LZY_IS_IPHONEX
#define LZY_IS_IPHONEX (LZY_SCREEN_WIDTH >=375.0f && LZY_SCREEN_HEIGHT >=812.0f && LZY_IS_IPHONE_DEVICE)
#endif
// 适配iPhone X 状态栏高度
#ifndef LZY_IPHNOE_STATUS_BAR_HEIGHT
#define LZY_IPHNOE_STATUS_BAR_HEIGHT (LZY_IS_IPHONEX ? 44.f : 20.f)
#endif
// 适配iPhone X Tabbar高度
#ifndef LZY_IPHNOE_TAB_BAR_HEIGHT
#define LZY_IPHNOE_TAB_BAR_HEIGHT (LZY_IS_IPHONEX ? (49.f+34.f) : 49.f)
#endif
// 适配iPhone X Tabbar距离底部的距离
#ifndef LZY_TAB_BAR_SAFE_BOTTOM_MARGIN
#define LZY_TAB_BAR_SAFE_BOTTOM_MARGIN (LZY_IS_IPHONEX ? 34.f : 0.f)
#endif
// 适配iPhone X 导航栏高度
#ifndef LZY_IPHONE_NAV_HEIGHT
#define LZY_IPHONE_NAV_HEIGHT (LZY_IS_IPHONEX ? 88.f : 64.f)
#endif
// 适配iPhone X 表格等视图的偏移
#ifndef LZY_VIEW_CONTENT_INSETS_MAKE
#define LZY_VIEW_CONTENT_INSETS_MAKE UIEdgeInsetsMake(0.0, 0.0, LZY_TAB_BAR_SAFE_BOTTOM_MARGIN, 0.0)
#endif


// Adapt
#ifndef LZY_WIDTH_SCALE_IPHONE
#define LZY_WIDTH_SCALE_IPHONE(px)  ((px) * (((LZY_SCREEN_WIDTH < LZY_SCREEN_HEIGHT) ? LZY_SCREEN_WIDTH : LZY_SCREEN_HEIGHT) / 375.0))
#endif
#ifndef LZY_HEIGHT_SCALE_IPHONE
#define LZY_HEIGHT_SCALE_IPHONE(px) ((px) * ((((LZY_SCREEN_WIDTH < LZY_SCREEN_HEIGHT) ? LZY_SCREEN_WIDTH : LZY_SCREEN_HEIGHT) / 667.0))
#endif

/// 强/弱引用
/**
 Synthsize a weak or strong reference.
 
 Example:
 @LZY__weakify(self)
 [self doSomething^{
 @LZY_strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef LZY_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define LZY_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define LZY_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define LZY_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define LZY_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef LZY_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define LZY_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define LZY_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define LZY_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define LZY_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

//颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1)
#define RGB3(v) RGB(v,v,v)
#define RandomColor RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
// rgb颜色转换（16进制->10进制）
#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

/// 字体
#ifndef LZY_FONT_FROM_NAME_SIZE
#define LZY_FONT_FROM_NAME_SIZE(sizeValue) ([UIFont fontWithName:@"PingFangSC-Regular" size:LZY_WIDTH_SCALE_IPHONE(sizeValue)])
#endif

//国际化
#define NSLocString(key,comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#endif /* LZYMacro_h */
