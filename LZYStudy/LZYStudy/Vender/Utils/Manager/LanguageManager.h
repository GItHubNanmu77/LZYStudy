//
//  LanguageManager.h
//  LZYStudy
//
//  Created by cisdi on 2019/9/2.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



static NSString *const kEnglish = @"en";
static NSString *const kChinese = @"zh-Hans";
static NSString *const kJapanese = @"ja";

@interface LanguageManager : NSObject

//获取当前资源文件
+ (NSBundle *)bundle;
//获取应用当前语言
+ (NSString *)currentUserLanguage;
//设置当前语言,需要传语言包名
+ (void)setUserLanguage:(NSString *)language;
//跟随系统语言
+ (void)followSystemLanguage;

@end

 

NS_ASSUME_NONNULL_END
