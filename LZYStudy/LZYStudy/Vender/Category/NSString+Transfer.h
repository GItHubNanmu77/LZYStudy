//
//  NSString+Transfer.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/29.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Transfer)

#pragma mark - NSString 转 日期,格式化日期
/**
 把标准yyyy-MM-dd HH:mm:ss 日期转传入的格式
 @param formatterStyle 格式(例如:2018-11-14 17:49:11)
 @return 返回string
 */
- (NSString *)parseDateString:(NSString *)formatterStyle;

/**
 把原格式日期转传入的格式 转 传入的格式
 @param fromStyle 格式(例如:2018-11-14 17:49:11)
 @param toStyle 格式(例如:2018-11-14 17:49:11)
 @return 返回string
 */
- (NSString *)parseDateStringFrom:(NSString*)fromStyle to:(NSString*)toStyle;

/**
 时间戳转指定日期格式字符串
 @param timeStamp 时间戳
 @param style 格式(例如:2018-11-14 17:49:11)
 @return 返回string
 */
+ (NSString *)timeStampConverTime:(NSTimeInterval)timeStamp toStyle:(NSString *)style;

/**
 时间戳字符串转指定日期格式字符串
 @param timeStamp 时间戳字符串
 @param style 格式(例如:2018-11-14 17:49:11)
 @return 返回string
 */
+ (NSString*)timeStampConverTimeWithStr:(NSString*)timeStamp toStyle:(NSString *)style;

/**
 指定格式字符串转日期
 @param formStyle 格式(例如:2018-11-14 17:49:11)
 @return 返回日期
 */
- (NSDate *)parseToDate:(NSString *)formStyle;

/**
 HTML5 转成字符串
 @param htlmString 格式(例如:2018-11-14 17:49:11)
 @return string
 */
+ (NSString *)htmlEntityDecode:(NSString *)htlmString;

/**
 转成Json字符串
 @return string
 */
- (NSString *)parseToJsonString;
@end

NS_ASSUME_NONNULL_END
