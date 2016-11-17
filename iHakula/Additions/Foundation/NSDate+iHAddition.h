//
//  NSDate+iHAddition.h
//  iHakula
//
//  Created by Wayde Sun on 12/6/12.
//  Copyright (c) 2012 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

struct DateInformation {
	int day;
	int month;
	int year;
	
	int weekday;
	
	int minute;
	int hour;
	int second;
	
};
typedef struct DateInformation DateInformation;

typedef enum {
    
    NSDateSecondsType = 0,
    NSDateMinutesType = 1,
    NSDateHoursType   = 2,
    NSDateDaysType    = 3,
    NSDateWeekType    = 4,
    NSDateMonthsType  = 5,
    NSDateYearType    = 6
    
} NSDateTimeType;

@interface NSDate (iHAddition)

+ (NSString *)timeStringWithInterval:(NSTimeInterval) time;
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval;
+ (BOOL)isLaterThanToday:(NSString *)dateString withFormat:(NSString *)format;

- (NSString *)stringWithSeperator:(NSString *)seperator;
- (NSString *)stringWithFormat:(NSString*)format;
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear;
- (NSDate *)relativedDateWithInterval:(NSInteger)interval ;
- (BOOL)isTodayWeekend;
- (NSString *)weekday;
- (NSString *)getDayString;
- (NSString *)getMonthString;
- (NSString *)year;

// Section

+(int) unixTimestampFromDate:(NSDate *)aDate;
+(int) unixTimestampNow;
+ (NSDate *)date:(NSDate *)aDate add:(NSUInteger)increment of:(NSDateTimeType)type;

+ (NSDate *) yesterday;
+ (NSDate *) month;

- (NSDate *) monthDate;
//- (NSDate *) lastOfMonthDate;
- (int) getWeekday;

- (BOOL) isSameDay:(NSDate*)anotherDate;
- (int) monthsBetweenDate:(NSDate *)toDate;
- (NSInteger) daysBetweenDate:(NSDate*)d;
- (BOOL) isToday;


- (NSDate *) dateByAddingDays:(NSUInteger)days;
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime;

- (NSString *) monthString;
- (NSString *) yearString;


- (DateInformation) dateInformation;
- (DateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(DateInformation)info;
+ (NSDate*) dateFromDateInformation:(DateInformation)info timeZone:(NSTimeZone*)tz;
+ (NSString*) dateInformationDescriptionWithInformation:(DateInformation)info;

@end
