//
//  NSString+Transfer.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/29.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "NSString+Transfer.h"

@implementation NSString (Transfer)
/**
 把标准yyyy-MM-dd HH:mm:ss 日期转传入的格式
 @param formatterStyle 格式(例如:2018-11-14 17:49:11)
 @return 返回string
 */
- (NSString*)parseDateString:(NSString*)formatterStyle{
    return [self parseDateStringFrom:@"yyyy-MM-dd HH:mm:ss" to:formatterStyle];
}

/**
 把原格式日期转传入的格式 转 传入的格式
 @param fromStyle 格式(例如:2018-11-14 17:49:11)
 @param toStyle 格式(例如:2018-11-14 17:49:11)
 @return 返回string
 */
- (NSString*)parseDateStringFrom:(NSString*)fromStyle to:(NSString*)toStyle{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fromStyle];
    NSDate *date = [dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:toStyle];
    return [dateFormatter stringFromDate:date];
}

/**
 时间戳转指定日期格式字符串
 @param timeStamp 时间戳
 @param style 格式(例如:2018-11-14 17:49:11)
 @return 返回string
 */
+ (NSString *)timeStampConverTime:(NSTimeInterval)timeStamp toStyle:(NSString *)style{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:style];
    NSDate *recevieDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString *newTimeStr = [dateFormatter stringFromDate:recevieDate];
    return newTimeStr;
}


/**
 时间戳字符串转指定日期格式字符串
 @param timeStamp 时间戳字符串
 @param style 格式(例如:2018-11-14 17:49:11)
 @return 返回string
 */
+ (NSString *)timeStampConverTimeWithStr:(NSString *)timeStamp toStyle:(NSString *)style{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:style];
    return [dateFormatter stringFromDate:date];
}

/**
 指定格式字符串转日期
 
 @param formStyle 格式(例如:2018-11-14 17:49:11)
 @return 返回日期
 */
- (NSDate *)parseToDate:(NSString *)formStyle {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 时区
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:formStyle];
    return [dateFormatter dateFromString:self];
}

/**
 HTML5 转成字符串
 @param htlmString 格式(例如:2018-11-14 17:49:11)
 @return string
 */
+ (NSString *)htmlEntityDecode: (NSString *)htlmString{
    
    htlmString = [htlmString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    htlmString = [htlmString stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    htlmString = [htlmString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    htlmString = [htlmString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htlmString = [htlmString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    htlmString = [htlmString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n"];
    return htlmString;
}

/**
 转成Json
 */
- (NSString *)parseToJsonString {
    
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"json data:%@",jsonString);
        if(error) {
            NSLog(@"Error:%@", error);
        }
    }
    return jsonString;
}
@end
