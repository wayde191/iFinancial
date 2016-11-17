//
//  iHResponseSuccess.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHResponseSuccess.h"
#import "iHValidationKit.h"

@implementation iHResponseSuccess

@synthesize serviceName, status, errorCode, userInfoDic, reserve;


- (id)initWithDic: (NSDictionary *)dic
{
    NSAssert(dic != nil, @"iHResponseSuccess' init data Dictionary is not empty");
    self = [super init];
    if (self) {
        self.serviceName = [dic objectForKey:@"serviceName"];
        self.status = [dic objectForKey:@"status"];
        self.errorCode = [dic objectForKey:@"errorCode"];
        self.userInfoDic = [NSDictionary dictionaryWithDictionary:dic];
    }
    return self;
}

@end
