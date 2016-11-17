//
//  iHFeedbackModel.m
//  iFinancial
//
//  Created by Wayde Sun on 3/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#define FEEDBACK_SERVICE            @"FeedbackService"

#import "iHFeedbackModel.h"
#import "JFeedbackViewController.h"

@implementation iHFeedbackModel

#pragma mark - Public Methods
- (void)doCallFeedbackService:(NSString *)feedback {
    theRequest.requestMethod = iHRequestMethodPost;
    NSString *uid = nil;
    if ([[User sharedInstance] isUserLoggedIn]) {
        uid = [[User sharedInstance] getUserId];
    } else {
        uid = @"0";
    }
    NSString *utoken = [USER_DEFAULT objectForKey:IH_DEVICE_TOKEN];
    if (!utoken) {
        utoken = @"no token";
    }
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:
                           uid, @"userId",
                           utoken, @"token",
                           @"iFinancialPro", @"appname",
                           @"1.0", @"appversion",
                           [UIDevice currentDevice].systemName, @"platform",
                           [UIDevice currentDevice].systemVersion, @"os",
                           [UIDevice currentDevice].localizedModel, @"device",
                           feedback, @"description",
                           nil];
    
    [self doCallService:FEEDBACK_SERVICE withParameters:paras andServiceUrl:SERVICE_FEEDBACK forDelegate:self];
}

#pragma mark - iHRequestDelegate
- (void)requestDidCanceld {
    [super requestDidCanceld];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response {
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:FEEDBACK_SERVICE]) {
        if (delegate && [delegate respondsToSelector:@selector(onFeedbackSuccess)]) {
            [delegate performSelector:@selector(onFeedbackSuccess)];
        }
    }
}
-(void)serviceCallFailed:(iHResponseSuccess *)response
{
    [super serviceCallFailed:response];
    if ([response.serviceName isEqualToString:FEEDBACK_SERVICE]) {
        if (delegate && [delegate respondsToSelector:@selector(onFeedbackFailure)]) {
            [delegate performSelector:@selector(onFeedbackFailure)];
        }
    }
    
}
@end
