//
//  iHFundsModel.h
//  iFinancial
//
//  Created by sun wayde on 3/13/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface iHFundsModel : FBaseModel

@property (nonatomic, strong) NSArray *allFundsDescendingArr;

- (void)doCallUpdatePurchasedUnitService:(NSDictionary *)modifiedFunds;

@end
