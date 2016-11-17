//
//  iHMasterModel.m
//  iFinancial
//
//  Created by Wayde Sun on 2/27/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#define GET_FUNDS_SERVICE                @"GetFundsService"

#import "iHMasterModel.h"
#import "iHMasterViewController.h"
#import "iHArithmeticKit.h"
#import "iHValidationKit.h"

@interface iHMasterModel (){
}

@end

@implementation iHMasterModel

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - Public Methods
- (NSString *)getNextIncomDate
{
    NSDate *tomorrow = [[NSDate date] dateByAddingDays:1];
    while ([tomorrow isTodayWeekend]) {
        tomorrow = [tomorrow dateByAddingDays:1];
    }
    
    //下一笔收益02月26日到账
    return [NSString stringWithFormat:@"下一笔收益%02d月%02d日到账", [[tomorrow getMonthString] integerValue], [[tomorrow getDayString] integerValue]];
}

- (float)getMinIncomeRate
{
    float minRate = 10.0;
    
    for (NSString *fundName in self.fundsDic) {
        NSArray *fundRates = [self.fundsDic objectForKey:fundName];
        for (int i = 0; i < fundRates.count; i++) {
            float rate = [fundRates[i] floatValue];
            if (rate < minRate) {
                minRate = rate;
            }
        }
    }
    
    return minRate - 0.1;
}

- (float)getMaxIncomeRate
{
    float maxRate = 0.0;
    
    for (NSString *fundName in self.fundsDic) {
        NSArray *fundRates = [self.fundsDic objectForKey:fundName];
        for (int i = 0; i < fundRates.count; i++) {
            float rate = [fundRates[i] floatValue];
            if (rate > maxRate) {
                maxRate = rate;
            }
        }
    }
    
    return maxRate + 0.1;
}

- (float)getTodayIncome
{
    float income = 00.00;
    for (int i = 0; i < [User sharedInstance].cashFundsArr.count; i++) {
        NSDictionary *pfund = [[User sharedInstance].cashFundsArr objectAtIndex:i];
        NSString *fid = [[pfund allKeys] firstObject];
        float spent = [[[pfund allValues] firstObject] floatValue] / 10000.00;
        float todayMillionIncom = [[[self.fundsDic objectForKey:fid] lastObject] floatValue];
        
        income += spent * todayMillionIncom;
    }
    
    return income;
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

- (void)doCallServiceGetUserFunds
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if ([[User sharedInstance] isUserLoggedIn]) {
        [para setValue:[[User sharedInstance] getUserId] forKey:@"user_id"];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gotoLoginViewController)]) {
                [self.delegate performSelector:@selector(gotoLoginViewController) withObject:nil afterDelay:0.3];
        }
        return;
    }
    
    NSString *utoken = [USER_DEFAULT objectForKey:IH_DEVICE_TOKEN];
    if (utoken) {
        [para setValue:utoken forKey:@"user_token"];
    }

    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_FUNDS_SERVICE  withParameters:para andServiceUrl:SERVICE_GET_FUNDS forDelegate:self];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:GET_FUNDS_SERVICE]) {
        [self setupFunds:response.userInfoDic];
        if (delegate && [delegate respondsToSelector:@selector(updateTodayIncome)]) {
            [delegate performSelector:@selector(updateTodayIncome) withObject:nil];
        }
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response {
    
    [super serviceCallFailed:response];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRefreshAlert)]) {
        [self.delegate performSelector:@selector(showRefreshAlert) withObject:nil];
    }
}


- (void)setupFunds:(NSDictionary *)fundsDic
{
    [User sharedInstance].observedFundsDic = fundsDic;
    
    self.minDate = [NSDate dateWithString:[fundsDic objectForKey:@"mindate"] formate:@"yyyy-MM-dd"];
    self.maxDate = [NSDate dateWithString:[fundsDic objectForKey:@"maxdate"] formate:@"yyyy-MM-dd"];
    self.fundsDic = [fundsDic objectForKey:@"funds"];
    NSArray *purchasedFundsArr = [fundsDic objectForKey:@"purchasedFunds"];
    if (![iHValidationKit isValueEmpty:purchasedFundsArr]) {
        [User sharedInstance].purchasedFundsArr = purchasedFundsArr;
    } else {
        [User sharedInstance].purchasedFundsArr = [NSArray array];
    }
    
    NSArray *cashFundsArr = [fundsDic objectForKey:@"cash"];
    if (![iHValidationKit isValueEmpty:cashFundsArr]) {
        [User sharedInstance].cashFundsArr = cashFundsArr;
    } else {
        [User sharedInstance].cashFundsArr = [NSArray array];
    }
}

#pragma mark - Private Methods
@end
