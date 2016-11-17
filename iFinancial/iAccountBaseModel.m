//
//  iAccountModel.m
//  iFinancial
//
//  Created by Bean on 14-4-19.
//  Copyright (c) 2014年 iHakula. All rights reserved.
//

#import "iAccountBaseModel.h"

@implementation iAccountBaseModel
@synthesize getDate=_getDate,/*detailNum,typeNum,*/cost=_cost,description=_description;

-(id)init
{
    self = [super init];
    _cost = [[NSNumber alloc]init];
    //_typeNum = [[NSNumber alloc]init];
    //_detailNum = [[NSNumber alloc]init];

    _description = [[NSString alloc]init];

    return  self;
}

 
@end
