//
//  iHAnnualRateModel.m
//  iFinancial
//
//  Created by Wayde Sun on 4/4/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#define GET_ANNUAL_RATE_SERVICE     @"GetAnnualRateService"

#import "iHAnnualRateModel.h"
#import "iHAnnualRateViewController.h"
#import "iHArithmeticKit.h"

@interface iHAnnualRateViewController (){
}

- (void)setupAnnualRates:(NSDictionary *)response;

@end

@implementation iHAnnualRateModel

- (float)getMinIncomeRate
{
    float minRate = 10.0;
    
    for (NSString *rate in self.annualRates) {
        float rateFloat = [rate floatValue];
        if (rateFloat < minRate) {
            minRate = rateFloat;
        }
    }
    
    return minRate - 0.2;
}

- (float)getMaxIncomeRate
{
    float maxRate = 0.0;
    
    for (NSString *rate in self.annualRates) {
        float rateFloat = [rate floatValue];
        if (rateFloat > maxRate) {
            maxRate = rateFloat;
        }
    }
    
    return maxRate + 0.2;
}

- (NSArray *)getDatesIntervalFromMindateToMaxdate
{
    NSMutableArray *dates = [NSMutableArray array];
    BOOL compareResult = TRUE;
    CFGregorianDate minDay = [iHArithmeticKit convertDateToCFGregorianDate: self.minDate];
    do {
        NSDate *mindate = [iHArithmeticKit convertCFGregorianDateToDate:minDay];
        [dates addObject:@([mindate timeIntervalSince1970])];
        
        minDay = [iHArithmeticKit moveForwardDayWithInt:1 sinceTheDay:minDay];
        NSDate *nextDate = [iHArithmeticKit convertCFGregorianDateToDate:minDay];
        
        compareResult = [nextDate compare:self.maxDate] <= NSOrderedSame;
    } while (compareResult);
    
    return [NSArray arrayWithArray:dates];
}

- (void)doCallGetAnnualRateServiceById:(NSString *)fundId
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:fundId forKeyPath:@"fund_id"];
    
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_ANNUAL_RATE_SERVICE  withParameters:para andServiceUrl:SERVICE_GET_ANNUAL_RATE forDelegate:self];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:GET_ANNUAL_RATE_SERVICE]) {
        [self setupAnnualRates:response.userInfoDic];
        if (delegate && [delegate respondsToSelector:@selector(drawChat)]) {
            [delegate performSelector:@selector(drawChat) withObject:nil];
        }
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response
{
    [super serviceCallFailed:response];
    if ([response.serviceName isEqualToString:GET_ANNUAL_RATE_SERVICE]) {
        if (delegate && [delegate respondsToSelector:@selector(serviceCallFailed)]) {
            [delegate performSelector:@selector(serviceCallFailed) withObject:nil];
        }
    }
}

#pragma mark - Private Methods
- (void)setupAnnualRates:(NSDictionary *)response
{
    self.minDate = [NSDate dateWithString:[response objectForKey:@"mindate"] formate:@"yyyy-MM-dd"];
    self.maxDate = [NSDate dateWithString:[response objectForKey:@"maxdate"] formate:@"yyyy-MM-dd"];
    iHDINFO(@"-- %@", self.minDate);
    iHDINFO(@"-- %@", self.maxDate);
    
    NSArray *resRates = [response objectForKey:@"rates"];
    NSMutableArray *rates = [NSMutableArray array];
    for (int i = 0; i < resRates.count; i++) {
        NSString *r = [resRates objectAtIndex:i];
        r = [r stringByReplacingOccurrencesOfString:@"%" withString:@""];
        [rates addObject:r];
    }
    
    self.annualRates = [NSArray arrayWithArray:rates];
}


@end
