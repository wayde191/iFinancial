//
//  Fund.m
//  iFinancial
//
//  Created by Wayde Sun on 3/7/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "Fund.h"

@implementation Fund

- (id)initWithDic:(NSDictionary *)dataDic
{
    self = [super init];
    if (self) {
        self.fid = [dataDic objectForKey:@"id"];
        self.name = [dataDic objectForKey:@"name"];
        self.code = [dataDic objectForKey:@"code"];
        self.owner = [dataDic objectForKey:@"owner"];
        self.manager = [dataDic objectForKey:@"manager"];
        self.type = [dataDic objectForKey:@"type"];
        self.money = 0.0;
        
        // 25:25:25 color
        NSArray *rgb = [[dataDic objectForKey:@"color"] componentsSeparatedByString:@":"];
        self.color = RGBCOLOR([rgb[0] floatValue], [rgb[1] floatValue], [rgb[2] floatValue]);
    }
    return self;
}

@end
