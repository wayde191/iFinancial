//
//  iHIncomeHisModel.m
//  iFinancial
//
//  Created by Wayde Sun on 4/1/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#define GET_ALL_INCOME_SERVICE       @"GetAllIncomeService"

#import "iHIncomeHisModel.h"
#import "iHIncomeHistoryTableViewController.h"

@interface iHIncomeHisModel (){
    NSInteger _curPageIndex;
    NSInteger _totalPage;
}

- (void)updateHistoryIncomes:(NSDictionary *)incomes;
@end

@implementation iHIncomeHisModel
- (id)init
{
    self = [super init];
    if(self){
        _curPageIndex = 0;
        _totalPage = 1;
        self.totalIncome = [NSNumber numberWithFloat:00.00];
        self.incomeSortedDate = [NSArray array];
        self.incomesDic = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)isLastPage
{
    return _curPageIndex == _totalPage;
}

#pragma mark - Public Methods
- (void)doCallGetAllIncome
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    NSString *uid = nil;
    if ([[User sharedInstance] isUserLoggedIn]) {
        uid = [[User sharedInstance] getUserId];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gotoLoginViewController)]) {
            [self.delegate performSelector:@selector(gotoLoginViewController) withObject:nil afterDelay:0.3];
        }
        return;
    }
    [para setValue:uid forKeyPath:@"user_id"];
    
    NSString *utoken = [USER_DEFAULT objectForKey:IH_DEVICE_TOKEN];
    if (utoken) {
        [para setValue:utoken forKeyPath:@"user_token"];
    }
    [para setValue:[NSString stringWithFormat:@"%d", (_curPageIndex + 1)] forKey:@"page_index"];
    
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_ALL_INCOME_SERVICE  withParameters:para andServiceUrl:SERVICE_GET_HIS_INCOME forDelegate:self];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:GET_ALL_INCOME_SERVICE]) {
        [self updateHistoryIncomes:response.userInfoDic];
        if (delegate && [delegate respondsToSelector:@selector(refreshTableView)]) {
            [delegate performSelector:@selector(refreshTableView) withObject:nil];
        }
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response
{
    [super serviceCallFailed:response];
    if ([response.serviceName isEqualToString:GET_ALL_INCOME_SERVICE]) {
        if (delegate && [delegate respondsToSelector:@selector(serviceCallFailed)]) {
            [delegate performSelector:@selector(serviceCallFailed) withObject:nil];
        }
    }
}

#pragma mark - Private Methods
- (void)updateHistoryIncomes:(NSDictionary *)incomes
{
    _curPageIndex = [[incomes objectForKey:@"pageIndex"] integerValue];
    _totalPage = [[incomes objectForKey:@"totalPageNum"] integerValue];
    self.totalIncome = [incomes objectForKey:@"totalIncome"];
    
    NSDictionary *curIncomeDic = [incomes objectForKey:@"incomes"];
    [self.incomesDic addEntriesFromDictionary:curIncomeDic];
    
    NSMutableArray *curIncomeKeys = [NSMutableArray arrayWithArray:self.incomeSortedDate];
    [curIncomeKeys addObjectsFromArray:[self.incomesDic allKeys]];
    
    self.incomeSortedDate = [curIncomeKeys sortedArrayUsingComparator:
                                         ^NSComparisonResult(id obj1, id obj2){
                                             NSComparisonResult result = NSOrderedSame;
                                             
                                             NSString *dateObj1 = [obj1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                             NSString *dateObj2 = [obj2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                             
                                             if ([dateObj1 integerValue] > [dateObj2 integerValue]) {
                                                 result = NSOrderedAscending;
                                             } else {
                                                 result = NSOrderedDescending;
                                             }
                                             return result;
                                         }];
}


@end
