//
//  iHMasterModel.h
//  iFinancial
//
//  Created by Wayde Sun on 2/27/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface iHMasterModel : FBaseModel {
}

@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;
@property (strong, nonatomic) NSDictionary *fundsDic;

// Public Methods
- (NSArray *)getDatesIntervalFromMindateToMaxdate;
- (float)getMinIncomeRate;
- (float)getMaxIncomeRate;
- (float)getTodayIncome;
- (NSString *)getNextIncomDate;
- (void)setupFunds:(NSDictionary *)fundsDic;

// Service Call
- (void)doCallServiceGetUserFunds;

@end
