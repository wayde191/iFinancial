//
//  iHResponseFailure.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHResponseFailure.h"
#import "iHValidationKit.h"

@implementation iHResponseFailure
@synthesize serviceName, status, errorCode, errorInfo, reserve;


- (id)initWithDic: (NSDictionary *)dic
{
    NSAssert(dic != nil, @"iHResponseFailure' init data Dictionary is not empty");
    self = [super init];
    if (self) {
        self.serviceName = [dic objectForKey:@"serviceName"];
        self.status = [dic objectForKey:@"status"];
        self.errorCode = [dic objectForKey:@"errorCode"];
        self.errorInfo = [dic objectForKey:@"error_info"];
    }
    
    return self;
}

@end
