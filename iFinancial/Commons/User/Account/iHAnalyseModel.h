//
//  iHAnalyseModel.h
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface iHAnalyseModel : FBaseModel

@property (nonatomic, strong) NSDictionary *yearAnalyDic;

- (void)doCallServiceGetAnalyseForYear:(NSString *)year;

- (NSInteger)getMonthCount;
- (NSArray *)getTextForRow:(NSInteger)row;
- (NSArray *)getDetailsForSelectedIndexPath:(NSIndexPath *)indexPath;

@end
