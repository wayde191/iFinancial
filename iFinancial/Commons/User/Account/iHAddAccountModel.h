//
//  iHAddAccountModel.h
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface iHAddAccountModel : FBaseModel

@property (nonatomic, strong) NSDictionary *allFieldTypes;

- (BOOL)isRefreshedToday;
- (NSInteger)getDetailFieldsRowNumberInSelectedFirstComponent:(NSInteger)selectedRow;
- (NSString *)getCategoryTitleByRow:(NSInteger)row;
- (NSString *)getDetailTitleForComponent:(NSInteger)selectedComponent forRow:(NSInteger)row;
- (NSString *)getSelectedCategoryIdByComponentRow:(NSInteger)component;
- (NSString *)getSelectedDetailIdForComponent:(NSInteger)component forDetailRow:(NSInteger)row;

- (void)doCallServiceGetFields;
- (void)doCallServiceAddRecord:(NSDictionary *)paras;

@end
