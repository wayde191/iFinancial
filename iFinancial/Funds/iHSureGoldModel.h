//
//  iHSureGoldModel.h
//  iFinancial
//
//  Created by Wayde Sun on 4/2/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface iHSureGoldModel : FBaseModel

@property (nonatomic, strong) NSString *confirmDeposit;
@property (nonatomic, strong) NSArray *comingConfirmArr;

- (void)doCallGetConfirmationDepositServiceById:(NSString *)fundId;
- (void)doCallUpdateAmount:(NSString *)amount serviceById:(NSString *)fundId;

@end
