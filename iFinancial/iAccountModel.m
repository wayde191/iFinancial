//
//  iAccountModel.m
//  iFinancial
//
//  Created by Bean on 14-4-19.
//  Copyright (c) 2014年 iHakula. All rights reserved.
//

#import "iAccountModel.h"

@implementation iAccountModel


- (id)init
{
    self = [super init];
    
    _accountArr =(NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"iAccountArr"];
    if (!_accountArr) {
        _accountArr = [[NSMutableArray alloc]init];
    }
    return  self;
}

-(void)save
{
    iAccountBaseModel *test = [_accountArr objectAtIndex:0];
    NSLog(@"shuzi:%d    %@",[test.cost intValue],test.description);
    [[NSUserDefaults standardUserDefaults] setObject:_accountArr forKey:@"iAccountArr"];
    
}
@end
