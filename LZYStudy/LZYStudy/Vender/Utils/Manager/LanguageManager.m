//
//  LanguageManager.m
//  LZYStudy
//
//  Created by cisdi on 2019/9/2.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LanguageManager.h"

@implementation LanguageManager


static NSBundle *bundle = nil;
+ (NSBundle *)bundle {
    if(!bundle) {
        return [NSBundle mainBundle];
    }
    return bundle;
}

//跟随系统语言
+ (void)followSystemLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"LocalLanguageKey"];
    [def setValue:nil forKey:@"LocalLanguageKey"];
    [def synchronize];
    bundle = nil;
}

//设置语言
+ (void)setUserLanguage:(NSString *)language {
    if(!language || language.length == 0) {
        [self followSystemLanguage];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:@"LocalLanguageKey"];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    [userDefaults setValue:language forKey:@"LocalLanguageKey"];
    [userDefaults synchronize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

//获取当前语言
+ (NSString *)currentUserLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"LocalLanguageKey"];
    if(!language) {//系统默认第一语言
        return [NSLocale preferredLanguages].firstObject;
    }
    return language;
    
}


 



@end
