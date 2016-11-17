//
//  IHArithmeticKit.h
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iHArithmeticKit : NSObject

+ (NSString *)getStrByBytesIndex:(NSUInteger)bytesIndex fromString:(NSString *)sourceStr;
+ (NSUInteger)lengthOfComplexStr: (NSString *)complexStr;

// Data Parse
//+ (NSDictionary *)getJsonData:(NSString *)jsonSourceStr;
//+ (NSString *)getStringFromDictionary:(NSDictionary *)dic;

// Date Format
+ (NSString *)getTimeWithMonthAndHourFromServerTimeStr:(NSString *)serverTimeStr;
+ (NSString *)getTimeSince1970:(NSString *)timeStr;
+ (NSString *)getTimeHintMessageWithTimestamp:(NSString *)timeStr;
+ (NSArray *)getYearMonthDayOfToday;

+ (CFGregorianDate)convertDateToCFGregorianDate:(NSDate *)date;
+ (NSDate *)convertCFGregorianDateToDate:(CFGregorianDate)cfgdate;
+ (CFGregorianDate)moveForwardMonthWithInt:(int)months sinceTheDay:(CFGregorianDate)today;
+ (CFGregorianDate) moveForwardDayWithInt:(int)days sinceTheDay:(CFGregorianDate)today;
+ (CFGregorianDate)moveBackwardDayWithInt:(int)days sinceTheDay:(CFGregorianDate)today;
+ (int)getMonthDays:(CFGregorianDate)date;

+ (BOOL)isOneMoredayEarlierThanToday:(NSString *)timeStr;
+ (BOOL)isEarlierThanTime:(NSString *)timeStr minutes:(int)mins;

// CGRect



@end
