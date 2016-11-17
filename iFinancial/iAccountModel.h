//
//  iAccountModel.h
//  iFinancial
//
//  Created by Bean on 14-4-19.
//  Copyright (c) 2014年 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAccountModel.h"
#import "iAccountBaseModel.h"
@interface iAccountModel : NSObject
{
}
@property(retain,nonatomic)NSNumber *sum;
@property(retain,nonatomic)NSMutableArray *accountArr;

-(NSInteger)getSum;
-(void)save;
@end
