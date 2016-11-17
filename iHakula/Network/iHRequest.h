//
//  iHRequest.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iHResponseSuccess.h"
#import "iHResponseFailure.h"
#import "ASIHTTPRequest.h"

#pragma mark - Service Configurations
#define SERVICE_OPERATION_SUCC      1
#define SERVICE_OPERATION_FAIL      0

typedef enum {
    iHServiceErrorSessionTimeout = 101,
    iHServiceErrorSystemBusy = 2001,
    iHServiceErrorFeedbackEmpty = 2010,
    iHServiceErrorCallTimesEmpty = 2011,
} iHServiceErrorCode;

typedef enum{
	iHRequestMethodGet = 1,
	iHRequestMethodPost = 2,           // content type = @"application/x-www-form-urlencoded"
	iHRequestMethodMultipartPost = 3   // content type = @"multipart/form-data"
} iHRequestMethod;

typedef enum{
    iHResponseParseFormatJSON = 1,
} iHResponseParseFormat;

#pragma mark - iHRequestDelegate
@protocol iHRequestDelegate <NSObject>
@optional
- (void)requestDidStarted;
- (void)requestDidCanceld;
- (void)requestDidFinished:(iHResponseSuccess *)response;
- (void)requestDidFailed:(iHResponseFailure *)response;
@end

@class iHLog;
@interface iHRequest : NSObject {
    
    iHRequestMethod requestMethod;
    NSStringEncoding responseEncoding;
    iHResponseParseFormat responseParseFormat;
    NSMutableDictionary *defaultOptions;
    NSMutableDictionary *commonOptions;
    NSMutableDictionary *extraHeaders;
    NSDate *requestStartTime;
    
    iHLog *theLog;
    
@private
    UIView *indicator;
    id<iHRequestDelegate> __weak theDelegate;
    NSMutableDictionary *requestStackDic;
    NSString *cancelNotificationSubject;
}

@property(nonatomic, assign) iHRequestMethod requestMethod;
@property(nonatomic, assign) NSStringEncoding responseEncoding;
@property(nonatomic, assign) iHResponseParseFormat responseParseFormat;
@property(nonatomic, strong) NSMutableDictionary *defaultOptions;
@property(nonatomic, strong) NSMutableDictionary *commonOptions;
@property(nonatomic, strong) NSMutableDictionary *extraHeaders;
@property(nonatomic, strong) NSDate *requestStartTime;

@property(nonatomic, strong) UIView *indicator;
@property(nonatomic, weak) id<iHRequestDelegate> theDelegate;
@property(nonatomic, strong) NSMutableDictionary *requestStackDic;
@property(nonatomic, strong) NSString *cancelNotificationSubject;

- (NSStringEncoding)getDefaultResponseEncoding;
- (iHRequestMethod)getDefaultRequestMethod;
- (iHResponseParseFormat)getDefaultResponseParseFormat;
- (void)setupDefaultOptions: (NSDictionary *)options;
- (void)setupCommonOptions: (NSDictionary *)options;
- (void)removeCommonOption:(id)key;
- (void)setupExtraHeaders: (NSDictionary *)headers;
- (void)removeUnusedRequestByServiceName:(NSString *)serviceName;
- (ASIHTTPRequest *)callService: (NSString *)serviceName withParameters: (NSDictionary *)parameter forDelegate: (id<iHRequestDelegate>)delegate;
- (ASIHTTPRequest *)callHttpService:(NSString *)serviceName withParameters:(NSDictionary *)parameter forDelegate:(id<iHRequestDelegate>)delegate;

@end
