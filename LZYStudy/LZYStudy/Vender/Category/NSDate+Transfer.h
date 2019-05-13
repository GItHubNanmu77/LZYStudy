//
//  NSDate+Transfer.h
//  LZYStudy
//
//  Created by cisdi on 2019/4/29.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Transfer)

#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties
///=============================================================================

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///< Nanosecond component
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger quarter; ///< Quarter component
@property (nonatomic, readonly) BOOL isLeapMonth; ///< Weather the month is leap month
@property (nonatomic, readonly) BOOL isLeapYear; ///< Weather the year is leap year
@property (nonatomic, readonly) BOOL isToday; ///< Weather date is today (based on current locale)
@property (nonatomic, readonly) BOOL isYesterday; ///< Weather date is yesterday (based on current locale)
@property (nonatomic, readonly) NSInteger nextDay; ///< the next day
@property (nonatomic, readonly) NSInteger nextMonth; ///< the next month


#pragma mark - Date modify
- (nullable NSDate *)dateByAddingYears:(NSInteger)years;
- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;
- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;
- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;
- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;


#pragma mark - Date Format
///=============================================================================
/// @name Date Format
///=============================================================================

/**
 格式化日期
 @return 返回格式化后字符串,标准日期字符串：@"yyyy-MM-dd hh:mm:ss"
 */
- (NSString *)formterToString;

/**
 格式化日期 
 @param style 格式 如@"yyyy-MM-dd hh:mm:ss"
 @return 返回格式化后字符串
 */
- (NSString *)formterToStringByStyle:(NSString *)style;

/**
 *  返回一个漂亮的日期字符串显示
 *
 *  1分钟以内 显示 = 刚刚
 *  1小时以内 显示 = X分钟前
 *  今天或者昨天显示 = 今天 09:30 | 昨天 09:30
 *  今年显示 = 09月12日
 *  大于本年显示 = 2013/09/09
 *
 *
 *  @return <#return value description#>
 */
- (NSString *)praseToPrettyDateString;

@end

NS_ASSUME_NONNULL_END
