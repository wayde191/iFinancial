//
//  Fund.h
//  iFinancial
//
//  Created by Wayde Sun on 3/7/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface Fund : FBaseModel

@property (strong, nonatomic) NSString *fid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *manager;
@property (strong, nonatomic) NSString *owner;
@property (assign, nonatomic) float money;

- (id)initWithDic:(NSDictionary *)dataDic;

@end
