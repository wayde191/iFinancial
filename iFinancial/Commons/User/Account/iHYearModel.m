//
//  iHYearModel.m
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHYearModel.h"
#import "iHYearTableViewController.h"

#define GET_ANALYSE_YEAR_SERVICE          @"GetAnalyseYearsService"

@implementation iHYearModel

- (id)init{
    self = [super init];
    if (self) {
        self.yearsArr = [NSArray array];
    }
    return self;
}

- (void)doCallServiceGetAnalyseYear {
    NSDictionary *paras = [NSDictionary dictionaryWithObject:[User sharedInstance].getUserId forKey:@"uid"];
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_ANALYSE_YEAR_SERVICE  withParameters:paras andServiceUrl:SERVICE_GET_ANALYSEYEARS forDelegate:self];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:GET_ANALYSE_YEAR_SERVICE]) {
        self.yearsArr = [response.userInfoDic objectForKey:@"data"];
        if (delegate && [delegate respondsToSelector:@selector(reloadTableView)]) {
            [delegate performSelector:@selector(reloadTableView) withObject:nil];
        }
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response {
    
    [super serviceCallFailed:response];
    NSString *msg = @"";
    switch ([response.errorCode intValue]) {
        case 1102:
            msg = @"用户信息不全，请重新登录";
            break;
        case 1110:
            msg = @"用户信息已过期，请重新登录";
            break;
        default:
            msg = @"服务器错误，请稍后重试";
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMessage:)]) {
        [self.delegate performSelector:@selector(showMessage:) withObject:msg];
        if ([response.errorCode intValue] == 1110) {
            [self.delegate performSelector:@selector(gotoLoginViewController) withObject:nil afterDelay:2.0];
        }
    }
}

@end
