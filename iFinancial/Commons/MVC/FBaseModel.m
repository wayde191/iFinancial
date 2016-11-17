//
//  JBaseModel.m
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "FBaseModel.h"
#import "iHAppDelegate.h"
#import "iHMasterViewController.h"

@implementation FBaseModel

#pragma mark - Rewrite super methods
- (BOOL)doCallService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate {
    if ([super doCallService:serviceName withParameters:paraDic andServiceUrl:serviceUrl forDelegate:theDelegate]) {
       // [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"RequestSending")];
    } else {
      //  [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CheckNetWork")];
       // [self performSelector:@selector(hideMessage) withObject:nil afterDelay:1.3];
    }
    return YES;
}

- (BOOL)doCallHttpService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate {
    if ([super doCallHttpService:serviceName withParameters:paraDic andServiceUrl:serviceUrl forDelegate:theDelegate]) {
        [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"RequestSending")];
    } else {
        [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CheckNetWork")];
        [self performSelector:@selector(hideMessage) withObject:nil afterDelay:1.3];
    }
    
    return YES;
}

- (void)showMessage:(NSString *)msg {
//    UCAppDelegate *appDelegate = [UCAppDelegate getSharedAppDelegate];
//    [appDelegate.customerMessageStatusBar showMessage:msg];
}

- (void)hideMessage {
//    UCAppDelegate *appDelegate = [UCAppDelegate getSharedAppDelegate];
//    [appDelegate.customerMessageStatusBar hide];
}

#pragma mark - iHRequestDelegate
- (void)requestDidStarted {
    // Should be rewritten by subclass
}

- (void)requestDidCanceld {
    [super requestDidCanceld];
    [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"RequestCanceled")];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:1.3];
}

- (void)requestDidFinished:(iHResponseSuccess *)response {
    switch ([response.status intValue]) {
        case SERVICE_OPERATION_SUCC:
            [self serviceCallSuccess:response];
            break;
        default:
            [self serviceCallFailed:response];
            break;
    }
}

- (void)requestDidFailed:(iHResponseFailure *)response {
    [self showMessage:response.errorInfo];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:1.3];
}

#pragma mark - Service call finished result handler
- (void)serviceCallFailed:(iHResponseSuccess *)response {
    
    NSString *msg = @"";
    switch ([response.errorCode intValue]) {
        case iHServiceErrorSystemBusy:
            msg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"iHServiceErrorSystemBusy");
            break;
        case iHServiceErrorFeedbackEmpty:
            msg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"iHServiceErrorFeedbackEmpty");
            break;
        case 1102:
            msg = @"用户信息不全，请重新登录";
            break;
        case 1110:
            msg = @"用户信息已过期，请重新登录";
            break;
        case 900:
            msg = @"不能为空";
            break;
        case 910:
            msg = @"账号不存在";
            break;
        case 909:
            msg = @"密码错误";
            break;
        case 901:
            msg = @"密码不相等";
            break;
        case 902:
            msg = @"邮箱已经存在";
            break;
        case 903:
            msg = @"服务器错误，请稍后重试";
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

// "errorCode" => 909));//password not exist
// "errorCode" => 900));//not empty
// "errorCode" => 910));//not exist
// "errorCode" => 901));//not equal
// "errorCode" => 902));//email exist
// "errorCode" => 903));//insert error

- (void)serviceCallSuccess:(iHResponseSuccess *)response {
    return;
    [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"submitSuccess")];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:1.3];
}



@end
