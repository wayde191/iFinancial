//
//  iHYearModel.h
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface iHYearModel : FBaseModel

@property (nonatomic, strong) NSArray *yearsArr;

- (void)doCallServiceGetAnalyseYear;

@end
