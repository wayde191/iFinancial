//
//  JProudModel.m
//  Journey
//
//  Created by Bean on 13-8-14.
//  Copyright (c) 2013年 iHakula. All rights reserved.
//

#import "JProudModel.h"
#import "JProudViewController.h"

#define GET_PROUD_SERVICE     @"GetProudService"

@implementation JProudModel

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)doCallGetProudService
{
    theRequest.requestMethod = iHRequestMethodPost;
    NSDictionary *paras = nil;
    if ([CURRENT_LANGUAGE isEqualToString:@"en"]) {
        paras = [NSDictionary dictionaryWithObject:@"en" forKey:@"lan"];
    }
    [self doCallService:GET_PROUD_SERVICE withParameters:paras andServiceUrl:SERVICE_GET_PROUD forDelegate:self];
}

//添加网络请求成功方法
#pragma mark - iHRequestDelegate
- (void)requestDidCanceld {
    [super requestDidCanceld];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response {
    [super serviceCallSuccess:response];
    _servicesArr=[NSArray arrayWithArray:[response.userInfoDic objectForKey:@"data"]];
    
    if (delegate  && [delegate respondsToSelector:@selector(setProud)]) {
        [delegate performSelector:@selector(setProud)];
    }
}
@end
