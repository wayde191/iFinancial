//
//  iHIncomeHisModel.h
//  iFinancial
//
//  Created by Wayde Sun on 4/1/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface iHIncomeHisModel : FBaseModel

@property (strong, nonatomic) NSArray* incomeSortedDate;
@property (strong, nonatomic) NSMutableDictionary *incomesDic;
@property (strong, nonatomic) NSNumber *totalIncome;

- (BOOL)isLastPage;
- (void)doCallGetAllIncome;

@end
