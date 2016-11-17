//
//  IHArithmeticKit.m
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHArithmeticKit.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "iHLog.h"
#import "iHSingletonCloud.h"

@implementation iHArithmeticKit

#pragma mark - String
+ (NSString *)getStrByBytesIndex:(NSUInteger)bytesIndex fromString:(NSString *)sourceStr
{
    NSData *dataFromSourceStr = [sourceStr dataUsingEncoding:NSUTF8StringEncoding];
    if ([dataFromSourceStr length] <= bytesIndex) {
        return sourceStr;
    }
    
    NSRange range = NSMakeRange(0, bytesIndex);
    
    UInt8 bytes[range.length];
    [dataFromSourceStr getBytes:bytes range:range];
    
    NSString *newStr;
    for (int i = 0; i < 3; i++) {
        NSData *newData = [[NSData alloc] initWithBytes:bytes length:(sizeof(bytes) - i)];
        newStr = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        if (newStr) {
            break;
        }
    }
    
    return newStr;
    
}

+ (NSUInteger)lengthOfComplexStr:(NSString *)complexStr
{
    NSData *dataFromComplexStr = [complexStr dataUsingEncoding:NSUTF8StringEncoding];
    
    return [dataFromComplexStr length];
}

#pragma mark - Data
+ (NSDictionary *)getJsonData:(NSString *)jsonSourceStr
{
    NSData *jsonData = [jsonSourceStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:
                                        [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&e]];
    if (e) {
        iHLog *theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        [theLog pushLog:@"getJsonData"
                message:[NSString stringWithFormat:@"Code:%ld *** Domain:%@ *** UserInfo:%@", (long)e.code, e.domain, e.userInfo]
                   type:iH_LOGS_EXCEPTION
                   file:__FILE__ function:__func__ line:__LINE__];
    }
    
    return responseDic;
}

+ (NSString *)getStringFromDictionary:(NSDictionary *)dic {
    NSString *theString = [[CJSONSerializer serializer] serializeDictionary:dic];
    return theString;
}

#pragma mark - Date
+ (NSString *)getTimeWithMonthAndHourFromServerTimeStr:(NSString *)serverTimeStr
{
    // serverTimeStr : Wed Jun 01 00:50:25 +0800 2011
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
    NSDate *date = [dateFormat dateFromString:serverTimeStr];
    
    [dateFormat setDateFormat:@"MM'月'dd'日' HH:mm"];
    NSString *formattedTimeStr = [dateFormat stringFromDate:date];
    
    return formattedTimeStr;
}

+ (NSString *)getTimeSince1970:(NSString *)timeStr
{
    NSTimeInterval timeInterval = [timeStr intValue]; 
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:@"yyyy'/'MM'/'dd"];
//    [dateFormatte setDateFormat:@"MM'/'dd'/'yyyy HH:mm"];
    // Analyze
    NSString *readableTimeStr = [NSString stringWithString: [dateFormatte stringFromDate:date]];
    return readableTimeStr;
}

+ (NSString *)getTimeHintMessageWithTimestamp:(NSString *)timeStr
{
    NSTimeInterval timeInterval = [timeStr intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];    
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval interval = nowInterval - timeInterval;
    NSString *hint = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (interval < 0) {
        interval = 5;
    }
    
    if (interval < 60) {
        hint = [[NSString alloc] initWithFormat:@"%.0lf秒前", interval];
    } else if (interval >= 60 && interval < 60*60) {
        NSInteger minute = interval/60;
        //NSInteger second = interval - minute * 60;
        hint = [[NSString alloc] initWithFormat:@"%d分钟前", minute];
    } else if (interval >= 60*60 && interval < 24*60*60) {
        [formatter setDateFormat:@"HH"];
        hint = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@小时前", [formatter stringFromDate:date]]];         
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        hint = [[NSString alloc] initWithString:[formatter stringFromDate:date]];
    }
    
    return hint;     
}

+ (NSArray *)getYearMonthDayOfToday {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:@"yyyy M d"];
    // Analyze
    NSString *readableTimeStr = [NSString stringWithString: [dateFormatte stringFromDate:date]];
    
    
    return [readableTimeStr componentsSeparatedByString:@" "];
}

+ (CFGregorianDate)convertDateToCFGregorianDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit  | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    
    CFGregorianDate greDay;
    greDay.year = year;
    greDay.month = month;
    greDay.day = day;
    
    return greDay;
}

+ (NSDate *)convertCFGregorianDateToDate:(CFGregorianDate)cfgdate
{
    NSString *dateStr = [NSString stringWithFormat:@"%4d-%2d-%2d", (int)cfgdate.year, (int)cfgdate.month, (int)cfgdate.day];
    NSDate *date = [NSDate dateWithString:dateStr formate:@"yyyy-MM-dd"];
    return date;
}

+ (CFGregorianDate)moveForwardMonthWithInt:(int)months sinceTheDay:(CFGregorianDate)today {
    CFGregorianDate currentMonthDate = today;
    
    if (months == 0) {
        return today;
    }
    
    do {
        if(currentMonthDate.month > 1) {
            currentMonthDate.month -= 1;
        } else {
            currentMonthDate.month = 12;
            currentMonthDate.year -= 1;
        }
    } while (--months > 0);
    
    return currentMonthDate;
}

+ (CFGregorianDate)moveBackwardDayWithInt:(int)days sinceTheDay:(CFGregorianDate)today {
    CFGregorianDate	currentMonthDate = today;
	
    if(currentMonthDate.day > 1) {
		currentMonthDate.day -= 1;
    } else {
		if(currentMonthDate.month > 1) {
			currentMonthDate.month -= 1;
        } else {
			currentMonthDate.month = 12;
			currentMonthDate.year -= 1;
		}
        
		currentMonthDate.day = [self getMonthDays:currentMonthDate];
	}
	
    return currentMonthDate;
}

+ (CFGregorianDate)moveForwardDayWithInt:(int)days sinceTheDay:(CFGregorianDate)today
{
    CFGregorianDate currentMonthDate = today;
    if (days == 0) {
        return today;
    }
    do {
        if (currentMonthDate.day < [self getMonthDays:currentMonthDate]) {
            currentMonthDate.day += 1;
        } else {
            if (currentMonthDate.month < 12) {
                currentMonthDate.month += 1;
                currentMonthDate.day = 1;
            } else {
                currentMonthDate.year += 1;
                currentMonthDate.month = 1;
                currentMonthDate.day = 1;
            }
        }
        
        days--;
    } while (days > 0);
    
    return currentMonthDate;
}

+ (int)getMonthDays:(CFGregorianDate)date {
	switch (date.month)
	{
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return 31;
			
		case 2:
			if((date.year%4==0 && date.year%100!=0) || date.year%400==0)
				return 29;
			else
				return 28;
		case 4:
		case 6:
		case 9:
		case 11:
			return 30;
		default:
			return 31;
	}
}

+ (BOOL)isOneMoredayEarlierThanToday:(NSString *)timeStr {
    NSArray *todayArr = [self getYearMonthDayOfToday];
    CFGregorianDate today;
    today.year = [[todayArr objectAtIndex:0] intValue];
    today.month = [[todayArr objectAtIndex:1] intValue];
    today.day = [[todayArr objectAtIndex:2] intValue];
    
    NSArray *pastDayArr = [[self getTimeSince1970:timeStr] componentsSeparatedByString:@"/"];
    CFGregorianDate pastDay;
    pastDay.year = [[pastDayArr objectAtIndex:0] intValue];
    pastDay.month = [[pastDayArr objectAtIndex:1] intValue];
    pastDay.day = [[pastDayArr objectAtIndex:2] intValue];
    
    if ((today.year - pastDay.year) > 0
        || ((today.year == pastDay.year) && (today.month - pastDay.month) > 0)
        || ((today.year == pastDay.year) && (today.month == pastDay.month) && (today.day - pastDay.day) > 0)) {
        return YES;
    }

    return NO;
    
}

+ (BOOL)isEarlierThanTime:(NSString *)timeStr minutes:(int)mins {
    NSInteger oldTimeInteverl = [timeStr integerValue];
    NSInteger nowTimeInteverl = [[NSDate date] timeIntervalSince1970];
    
    if ((nowTimeInteverl - oldTimeInteverl) >= mins * 60) {
        return YES;
    }
    return NO;
}

@end
