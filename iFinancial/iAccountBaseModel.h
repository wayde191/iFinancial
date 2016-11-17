//
//  iAccountModel.h
//  iFinancial
//
//  Created by Bean on 14-4-19.
//  Copyright (c) 2014年 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iAccountBaseModel : NSObject
{
}
@property (strong, nonatomic) NSDate *getDate;
@property (strong,nonatomic) NSNumber *cost;
//@property (strong,nonatomic) NSNumber *typeNum;
//@property (strong,nonatomic) NSNumber *detailNum;
@property (retain,nonatomic) NSString *description;

@end
