//
//  iHAnnualRateModel.h
//  iFinancial
//
//  Created by Wayde Sun on 4/4/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface iHAnnualRateModel : FBaseModel

@property (nonatomic, strong) NSArray *annualRates;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;

- (void)doCallGetAnnualRateServiceById:(NSString *)fundId;
- (NSArray *)getDatesIntervalFromMindateToMaxdate;
- (float)getMinIncomeRate;
- (float)getMaxIncomeRate;

@end
