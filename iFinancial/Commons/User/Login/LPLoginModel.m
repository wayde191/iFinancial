//
//  LPLoginModel.m
//  LocatePeople
//
//  Created by Wayde Sun on 7/10/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#define REGISTER_SERVICE        @"LPRegisterService"
#define LOGIN_SERVICE           @"LPLoginService"
#define LOGOUT_SERVICE          @"LPLogoutService"

#import "LPLoginModel.h"
#import "LPLoginViewController.h"
#import "iHDetailViewController.h"
#import "iHRegisterViewController.h"

@implementation LPLoginModel

- (void)doCallLogoutService
{
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:LOGOUT_SERVICE withParameters:nil andServiceUrl:SERVICE_LOGOUT forDelegate:self];
}

- (void)doCallLoginService:(NSDictionary *)paras {
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:LOGIN_SERVICE withParameters:paras andServiceUrl:SERVICE_LOGIN forDelegate:self];
}

- (void)doCallRegisterService:(NSDictionary *)paras
{
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:REGISTER_SERVICE withParameters:paras andServiceUrl:SERVICE_REGISTER forDelegate:self];
}

#pragma mark - iHRequestDelegate
- (void)serviceCallSuccess:(iHResponseSuccess *)response {
    
    if ([response.serviceName isEqualToString:LOGIN_SERVICE]) {
        // Setup user info
        NSDictionary *user = [response.userInfoDic objectForKey:@"user"];
        [[User sharedInstance] loginSuccess:user];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccess)]) {
            [self.delegate performSelector:@selector(loginSuccess)];
        }
    } else if ([response.serviceName isEqualToString:LOGOUT_SERVICE]) {
        [[User sharedInstance] restoreUser];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(logoutSuccess)]) {
            [self.delegate performSelector:@selector(logoutSuccess)];
        }
    } else if ([response.serviceName isEqualToString:REGISTER_SERVICE]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(registerSuccess)]) {
            [self.delegate performSelector:@selector(registerSuccess)];
        }
    }
}
@end
