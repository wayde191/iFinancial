//
//  iHSureGoldModel.m
//  iFinancial
//
//  Created by Wayde Sun on 4/2/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#define GET_CONFIRM_DEPOSIT_SERVICE     @"GetConfirmDepositService"
#define UPDATE_AMOUNT_SERVICE           @"UpdateAmountService"

#import "iHSureGoldModel.h"
#import "iHSureGoldViewController.h"

@interface iHSureGoldModel () {
}

- (void)setupConfirmDepositRecords:(NSDictionary *)response;

@end

@implementation iHSureGoldModel
- (id)init
{
    self = [super init];
    if(self){
        self.confirmDeposit = @"0.0";
        self.comingConfirmArr = [NSArray array];
    }
    
    return self;
}

- (void)doCallGetConfirmationDepositServiceById:(NSString *)fundId
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
    
    [para setValue:fundId forKey:@"fund_id"];
    
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_CONFIRM_DEPOSIT_SERVICE  withParameters:para andServiceUrl:SERVICE_GET_CONFIRM_DEPOSIT forDelegate:self];
}

- (void)doCallUpdateAmount:(NSString *)amount serviceById:(NSString *)fundId
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
    
    [para setValue:fundId forKey:@"fund_id"];
    [para setValue:amount forKey:@"amount"];
    
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:UPDATE_AMOUNT_SERVICE  withParameters:para andServiceUrl:SERVICE_UPDATE_AMOUNT forDelegate:self];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:GET_CONFIRM_DEPOSIT_SERVICE]) {
        [self setupConfirmDepositRecords:response.userInfoDic];
        if (delegate && [delegate respondsToSelector:@selector(refreshTableView)]) {
            [delegate performSelector:@selector(refreshTableView) withObject:nil];
        }
    } else if ([response.serviceName isEqualToString:UPDATE_AMOUNT_SERVICE]) {
        self.confirmDeposit = [response.userInfoDic objectForKey:@"amount"];
        self.comingConfirmArr = [NSArray array];
        
        if (delegate && [delegate respondsToSelector:@selector(refreshTableView)]) {
            [delegate performSelector:@selector(refreshTableView) withObject:nil];
        }
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response
{
    [super serviceCallFailed:response];
    if ([response.serviceName isEqualToString:GET_CONFIRM_DEPOSIT_SERVICE]) {
        if (delegate && [delegate respondsToSelector:@selector(serviceCallFailed)]) {
            [delegate performSelector:@selector(serviceCallFailed) withObject:nil];
        }
    } else if ([response.serviceName isEqualToString:UPDATE_AMOUNT_SERVICE]) {
        if (delegate && [delegate respondsToSelector:@selector(serviceCallFailed)]) {
            [delegate performSelector:@selector(serviceCallFailed) withObject:nil];
        }
    }
}

#pragma mark - Private Methods
- (void)setupConfirmDepositRecords:(NSDictionary *)response
{
    self.confirmDeposit = [response objectForKey:@"confirmed"];
    self.comingConfirmArr = [response objectForKey:@"records"];    
}

@end
