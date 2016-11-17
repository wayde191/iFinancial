//
//  iHRequest.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHRequest.h"
#import "iHSingletonCloud.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "iHPubSub.h"
#import "iHCommonMacros.h"
#import "iHLog.h"

@interface iHRequest()
- (NSMutableDictionary *)getJsonResponse: (ASIHTTPRequest *)request;
- (NSMutableDictionary *)getParsedResponse: (ASIHTTPRequest *)request;
- (NSString *)getNSUrlStr:(NSDictionary *)parameter;
- (void)showIndicator: (BOOL)isShow;
- (NSString *)getSpentTime;
- (NSString*)encodeURL:(NSString *)string;
- (void)removeUnusedRequestByServiceName:(NSString *)serviceName;
- (void)pushRequestWithServiceName:(NSString *)serviceName forRequest:(ASIHTTPRequest *)request withCustomerDelegate:(id)cusDelegate;
- (id)getCustomerDelegateByServiceName:(NSString *)serviceName;
- (NSString *)removeFloatSign:(NSString *)sourceStr;
- (NSString *)getStringFromValue: (id)value;
@end

@implementation iHRequest

@synthesize responseParseFormat, defaultOptions, commonOptions, extraHeaders, indicator, requestStackDic, requestStartTime, cancelNotificationSubject, requestMethod, responseEncoding, theDelegate;

- (void)dealloc
{
    [iHPubSub unsubscribeWithSubject:APP_DID_ENTER_BACKGROUND ofInstance:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        self.requestStackDic = [NSMutableDictionary dictionary];
        self.defaultOptions = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               @"YES",         @"async",
                               @"30",          @"timeout",
                               @"",            @"serviceRoot",
                               @"",            @"serviceUrl",
                               nil];
        [iHPubSub subscribeWithSubject:APP_DID_ENTER_BACKGROUND byInstance:self];
    }
    return self;
}

#pragma mark - Default setting
- (NSStringEncoding)getDefaultResponseEncoding
{
    return NSUTF8StringEncoding;
}

- (iHRequestMethod)getDefaultRequestMethod
{
    return iHRequestMethodGet;
}

- (iHResponseParseFormat)getDefaultResponseParseFormat
{
    return iHResponseParseFormatJSON;
}

#pragma mark - Setup configration parameters
- (void)setupDefaultOptions:(NSDictionary *)options
{
    
    NSAssert(options != nil, @"iHRequest, default options should not empty");
    
    for (NSString *key in options) {
        if ([self->defaultOptions valueForKey:key]) {
            
            if ([key isEqualToString:@"serviceRoot"] && [[options valueForKey:key] isEqualToString:@""]) {
                [theLog pushLog:@"ServiceRoot"
                        message:@"service root is not config"
                           type:iH_LOGS_EXCEPTION
                           file:__FILE__ function:__func__ line:__LINE__];
                
            }else if([key isEqualToString:@"serviceUrl"] && [[options valueForKey:key] isEqualToString:@""]) {
                [theLog pushLog:@"ServiceUrl"
                        message:@"service url is not config"
                           type:iH_LOGS_EXCEPTION
                           file:__FILE__ function:__func__ line:__LINE__];
            }
            
            [self->defaultOptions setValue:[options valueForKey:key] forKey:key];
        }
    }
}

- (void)setupCommonOptions:(NSDictionary *)options
{
    NSAssert(options != nil, @"iHRequest, common options should not empty");
    
    self.commonOptions = [NSMutableDictionary dictionaryWithDictionary:options];
}

- (void)removeCommonOption:(id)key
{
    if (self.commonOptions) {
        [self.commonOptions removeObjectForKey:key];
    }
}

- (void)setupExtraHeaders:(NSDictionary *)headers
{
    NSAssert(headers != nil, @"iHRequest, extra headers should not empty");
    
    self.extraHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
}

#pragma mark - Build up Service request
- (ASIHTTPRequest *)callHttpService:(NSString *)serviceName withParameters:(NSDictionary *)parameter forDelegate:(id<iHRequestDelegate>)delegate
{
    NSAssert(serviceName != nil, @"Service call service name is not empty");
    
    //Build up the url
    NSString *url = [self getNSUrlStr:parameter];
    [theLog pushLog:serviceName message:url type:iH_LOGS_MESSAGE file:nil function:nil line:0];
    NSURL *nsURL = [NSURL URLWithString:url];
    
    iHRequestMethod method = self->requestMethod ? self->requestMethod : [self getDefaultRequestMethod];
    ASIHTTPRequest *httpRequest = [[ASIHTTPRequest alloc] initWithURL:nsURL];
    
    //Setup header
    [httpRequest setTimeOutSeconds:[[self->defaultOptions valueForKey:@"timeout"] intValue]];
    [httpRequest addRequestHeader:@"serviceName" value:serviceName];
    if (self->extraHeaders && [self->extraHeaders count]) {
        for (NSString *key in self->extraHeaders) {
            [httpRequest addRequestHeader:key value:[self->extraHeaders objectForKey:key]];
        }
    }
    
    if (iHRequestMethodGet == method) {
        [httpRequest setRequestMethod:@"GET"];
    } else {
    }
    httpRequest.delegate = self;
    httpRequest.defaultResponseEncoding = self.responseEncoding ? self.responseEncoding : [self getDefaultResponseEncoding];
    httpRequest.allowCompressedResponse = YES;
    httpRequest.shouldCompressRequestBody = NO;
    httpRequest.shouldAttemptPersistentConnection = NO;
    [httpRequest setValidatesSecureCertificate:NO];
    [httpRequest setDidStartSelector:@selector(requestStarted:)];
    [httpRequest setDidFinishSelector:@selector(requestFinished:)];
    [httpRequest setDidFailSelector:@selector(requestFailed:)];
    
    [iHPubSub subscribeWithSubject:[NSString stringWithFormat:@"%@Canceld", serviceName] byInstance:self];
    
    BOOL bRequestType = 1; // 1: async 0:sync
    if ([parameter valueForKey:@"requesttype"]!=nil &&[[parameter valueForKey:@"requesttype"] isEqualToString:@"sync"] ) {
        bRequestType = 0;
    }else if([[self->defaultOptions valueForKey:@"sync"] isEqualToString:@"YES"]){
        bRequestType = 0;
    }
    
    iHDINFO(@"\n**************\niHRequest, request url:\n%@\n**************\n", url);
    
    // Do Call
    // Syn or asyn should be decided by parameter, no value pass, then use default
    
    [self pushRequestWithServiceName:serviceName forRequest:httpRequest withCustomerDelegate:delegate];
    if(bRequestType){
        [httpRequest startAsynchronous];
    } else {
        [httpRequest startSynchronous];
    }
    
    return  nil;
}

- (ASIHTTPRequest *)callService:(NSString *)serviceName withParameters:(NSDictionary *)parameter forDelegate:(id<iHRequestDelegate>)delegate
{
    NSAssert(serviceName != nil, @"Service call service name is not empty");
    
    //Build up the url
    NSString *url = [self getNSUrlStr:parameter];
    [theLog pushLog:serviceName message:url type:iH_LOGS_MESSAGE file:nil function:nil line:0];
    NSURL *nsURL = [NSURL URLWithString:url];
    
    iHRequestMethod method = self->requestMethod ? self->requestMethod : [self getDefaultRequestMethod];
    ASIFormDataRequest *formRequest = [[ASIFormDataRequest alloc] initWithURL:nsURL];
    
    //Setup header
    [formRequest setTimeOutSeconds:[[self->defaultOptions valueForKey:@"timeout"] intValue]];
    [formRequest addRequestHeader:@"serviceName" value:serviceName];
    if (self->extraHeaders && [self->extraHeaders count]) {
        for (NSString *key in self->extraHeaders) {
            [formRequest addRequestHeader:key value:[self->extraHeaders objectForKey:key]];
        }
    }
    
    if (iHRequestMethodGet == method) {
        [formRequest setRequestMethod:@"GET"];
    } else {
        [formRequest setRequestMethod:@"POST"];
        
        //Post format
        ASIPostFormat postFormat = ASIURLEncodedPostFormat;
        
        //Add common parameters
        if (self->commonOptions || [self->commonOptions count]) {
            for (NSString *key in self->commonOptions) {
                if ([[self->commonOptions objectForKey:key] isKindOfClass:[UIImage class]]) {
                    postFormat = ASIMultipartFormDataPostFormat;
                    NSData *imgData = UIImageJPEGRepresentation((UIImage *)[self->commonOptions objectForKey:key], 0.8);
                    //@"image/jpeg", for the reason we set data as application/octet-stream
                    [formRequest addData:imgData withFileName:@"image.jpg" andContentType:nil forKey:key];
                } else{
                    [formRequest addPostValue:[self->commonOptions objectForKey:key] forKey:key];
                }
            }
        }
        //Add user parameters
        if (parameter || [parameter count]) {
            for (NSString *key in parameter) {
                if ([[parameter objectForKey:key] isKindOfClass:[UIImage class]]) {
                    postFormat = ASIMultipartFormDataPostFormat;
                    NSData *imgData = UIImageJPEGRepresentation((UIImage *)[parameter objectForKey:key], 0.8);
                    //@"image/jpeg", for the reason we set data as application/octet-stream
                    [formRequest addData:imgData withFileName:@"image.jpg" andContentType:nil forKey:key];
                    
                } else if ([key isEqualToString:@"voice_file"]) {
                    postFormat = ASIMultipartFormDataPostFormat;
                    [formRequest setShouldStreamPostDataFromDisk:YES];
                    iHDINFO(@"%@",[parameter objectForKey:key]);
                    [formRequest setFile:(NSString *)[parameter objectForKey:key] forKey:key];
                    //                    [formRequest setFile:[self->commonOptions objectForKey:key] withFileName:@"tttttt" andContentType:@"multipart/form-data" forKey:@"file"];
                } if ([key isEqualToString:@"json_body"]){
                    NSString *data = [parameter objectForKey:key];
                    [formRequest appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
                }
                else {
                    [formRequest addPostValue:[parameter objectForKey:key] forKey:key];
                }
            }
        }
        formRequest.postFormat = postFormat;
    }
    formRequest.delegate = self;
    formRequest.defaultResponseEncoding = self.responseEncoding ? self.responseEncoding : [self getDefaultResponseEncoding];
    formRequest.allowCompressedResponse = YES;
    formRequest.shouldCompressRequestBody = NO;
    formRequest.shouldAttemptPersistentConnection = NO;
    [formRequest setValidatesSecureCertificate:NO];
    [formRequest setDidStartSelector:@selector(requestStarted:)];
    [formRequest setDidFinishSelector:@selector(requestFinished:)];
    [formRequest setDidFailSelector:@selector(requestFailed:)];
    
    [iHPubSub subscribeWithSubject:[NSString stringWithFormat:@"%@Canceld", serviceName] byInstance:self];
    
    BOOL bRequestType = 1; // 1: async 0:sync
    if ([parameter valueForKey:@"requesttype"]!=nil &&[[parameter valueForKey:@"requesttype"] isEqualToString:@"sync"] ) {
        bRequestType = 0;
    }else if([[self->defaultOptions valueForKey:@"sync"] isEqualToString:@"YES"]){
        bRequestType = 0;
    }
    
    iHDINFO(@"\n**************\niHRequest, request url:\n%@\n**************\n", url);
    
    // Do Call
    // Syn or asyn should be decided by parameter, no value pass, then use default
    
    [self pushRequestWithServiceName:serviceName forRequest:formRequest withCustomerDelegate:delegate];
    if(bRequestType){
        [formRequest startAsynchronous];
    } else {
        [formRequest startSynchronous];
    }
    
    return  nil;
}

#pragma mark - iH PubSub
- (void)iHMsgReceivedWithSender:(NSNotification *)sender
{
    NSString *serviceName = @"";
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[sender userInfo]];
    if (!dic || ![dic count]) {
        [theLog pushLog:@"Do cancel service"
                message:@"the target is empty"
                   type:iH_LOGS_EXCEPTION
                   file:nil function:nil line:0];
        return;
    }
    
    // Remove all request
    NSString *action = [dic objectForKey:@"action"];
    if (action && [action isEqualToString:@"appDidEnterBackground"]) {
        for (NSString *key in self.requestStackDic) {
            ASIFormDataRequest *fr = [[self.requestStackDic objectForKey:key] objectAtIndex:0];
            [fr cancel];
        }
        [self.requestStackDic removeAllObjects];
        return;
    }
    
    serviceName = [dic objectForKey:@"serviceName"];
    
    NSArray *requestArr = [NSArray arrayWithArray:[self.requestStackDic objectForKey:[NSString stringWithFormat:@"%@Canceld", serviceName]]];
    ASIFormDataRequest *formRequest = [requestArr objectAtIndex:0];
    [formRequest cancel];
    
    id cusDelegate = [requestArr objectAtIndex:1];
    if (cusDelegate && [cusDelegate respondsToSelector:@selector(requestDidCanceld)]) {
        [cusDelegate requestDidCanceld];
    }
    
    //Remove request from request stack
    [self->requestStackDic removeObjectForKey:[NSString stringWithFormat:@"%@Canceld", serviceName]];
    [iHPubSub unsubscribeWithSubject:[NSString stringWithFormat:@"%@Canceld", serviceName] ofInstance:self];
}

#pragma mark - ASIRequest Delegate
- (void)requestStarted:(ASIFormDataRequest*)request
{
    [self showIndicator:YES];
    self.requestStartTime = [NSDate date];
    NSString *serviceName = [[request requestHeaders] objectForKey:@"serviceName"];
    [theLog pushLog:serviceName
            message:@"Request Start"
               type:iH_LOGS_MESSAGE
               file:nil function:nil line:0];
    id cusDelegate = [self getCustomerDelegateByServiceName:serviceName];
    if (cusDelegate && [cusDelegate respondsToSelector:@selector(requestDidStarted)]) {
        [cusDelegate requestDidStarted];
    }
}

- (void)requestFinished:(ASIFormDataRequest*)request
{
    [self showIndicator:NO];
    NSString *serviceName = [[request requestHeaders] objectForKey:@"serviceName"];
    
    [theLog pushLog:serviceName
            message:[NSString stringWithFormat:@"Finished, Service spend time:%@", [self getSpentTime]]
               type:iH_LOGS_MESSAGE
               file:nil function:nil line:0];
    iHDINFO(@"--- %@", request.responseString);
    NSMutableDictionary *responseDic = [NSMutableDictionary dictionary];
    if (request.responseStatusCode == 401 || request.responseStatusCode == 500) {
        [responseDic setObject:[NSString stringWithFormat:@"%d", request.responseStatusCode] forKey:@"error"];
        if (401 == request.responseStatusCode) {
            [responseDic setObject:@"System Error" forKey:@"message"];
        } else {
            [responseDic setObject:@"System Error" forKey:@"message"];
        }
    } else {
        //Parse the response data
        responseDic = [self getParsedResponse:request];
        
        if (!responseDic || ![responseDic count]) {
            [theLog pushLog:serviceName
                    message:[NSString stringWithFormat:@"The response dic is empty"]
                       type:iH_LOGS_MESSAGE
                       file:nil function:nil line:0];
            
            NSMutableDictionary *errorInfoDic = [NSMutableDictionary dictionary];
            [errorInfoDic setValue:serviceName forKey:@"serviceName"];
            [errorInfoDic setValue:@"606" forKey:@"status"];
            [errorInfoDic setValue:@"606" forKey:@"errorCode"];
            [errorInfoDic setValue:LOCALIZED_STRING(@"iHServiceErrorNoDataReturn") forKey:@"errmsg"];
            
            id cusDelegate = [self getCustomerDelegateByServiceName:serviceName];
            if (cusDelegate && [cusDelegate respondsToSelector:@selector(requestDidFinished:)]) {
                iHResponseSuccess *successResponse = [[iHResponseSuccess alloc] initWithDic:errorInfoDic];
                [cusDelegate requestDidFinished:successResponse];
            }
            
            //Remove request from request stack
            [self removeUnusedRequestByServiceName:serviceName];
            
            return;
        }
        
        [responseDic setValue:@"0" forKey:@"error"];
    }
    
    [responseDic setValue:serviceName forKey:@"serviceName"];
    
    id cusDelegate = [self getCustomerDelegateByServiceName:serviceName];
    if (cusDelegate && [cusDelegate respondsToSelector:@selector(requestDidFinished:)]) {
        iHResponseSuccess *successResponse = [[iHResponseSuccess alloc] initWithDic:responseDic];
        [cusDelegate requestDidFinished:successResponse];
    }
    
    //Remove request from request stack
    [self removeUnusedRequestByServiceName:serviceName];
}

- (void)requestFailed:(ASIFormDataRequest*)request
{
    [self showIndicator:NO];
    NSString *serviceName = [[request requestHeaders] objectForKey:@"serviceName"];
    [theLog pushLog:serviceName
            message:[NSString stringWithFormat:@"Failed, Service spend time:%@ **** Error detail:%@ **** Error Code:%ld", [self getSpentTime], request.error.userInfo, (long)[request.error code]]
               type:iH_LOGS_MESSAGE file:nil function:nil line:0];
    
    NSString *errorMsg = nil;
    if (request.error.domain == NetworkRequestErrorDomain) {
		switch ([request.error code]) {
			case ASIConnectionFailureErrorType:
                errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIConnectionFailureErrorType");
				break;
			case ASIRequestTimedOutErrorType:
                errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIRequestTimedOutErrorType");
				break;
			case ASIAuthenticationErrorType:
                errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIAuthenticationErrorType");
				break;
			case ASIRequestCancelledErrorType:
				errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIRequestCancelledErrorType");
				break;
			case ASIUnableToCreateRequestErrorType:
				errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIUnableToCreateRequestErrorType");
				break;
			case ASIInternalErrorWhileBuildingRequestType:
				errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIInternalErrorWhileBuildingRequestType");
				break;
			case ASIInternalErrorWhileApplyingCredentialsType:
				errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIInternalErrorWhileApplyingCredentialsType");
				break;
			case ASIFileManagementError:
				errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIFileManagementError");
				break;
			case ASIUnhandledExceptionError:
				errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ASIUnhandledExceptionError");
				break;
			default:
				errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"iHServiceErrorSystemBusy");
				break;
		}
        if ([request.error code] != ASIAuthenticationErrorType) {
            errorMsg = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"iHServiceErrorSystemBusy");
        }
	}
    
    NSMutableDictionary *errorInfoDic = [NSMutableDictionary dictionary];
    [errorInfoDic setValue:serviceName forKey:@"serviceName"];
    [errorInfoDic setValue:@"-5" forKey:@"status"];
    [errorInfoDic setValue:[NSString stringWithFormat:@"%ld", (long)[request.error code]] forKey:@"errorCode"];
    [errorInfoDic setValue:errorMsg forKey:@"error_info"];
    
    id cusDelegate = [self getCustomerDelegateByServiceName:serviceName];
    if (cusDelegate && [cusDelegate respondsToSelector:@selector(requestDidFailed:)]) {
        iHResponseFailure *failResponse = [[iHResponseFailure alloc] initWithDic:errorInfoDic];
        [cusDelegate requestDidFailed:failResponse];
    }
    
    //Remove request from request stack
    [self removeUnusedRequestByServiceName:serviceName];
    
}

#pragma mark - Private methods
- (id)getCustomerDelegateByServiceName:(NSString *)serviceName
{
    NSArray *requestInfoArr = [self.requestStackDic objectForKey:[NSString stringWithFormat:@"%@Canceld", serviceName]];
    if (requestInfoArr.count > 1) {
        return [requestInfoArr objectAtIndex:1];
    }
    return nil;
}

- (void)removeUnusedRequestByServiceName:(NSString *)serviceName
{
    [self->requestStackDic removeObjectForKey:[NSString stringWithFormat:@"%@Canceld", serviceName]];
    [iHPubSub unsubscribeWithSubject:[NSString stringWithFormat:@"%@Canceld", serviceName] ofInstance:self];
    
}

- (void)pushRequestWithServiceName:(NSString *)serviceName forRequest:(ASIHTTPRequest *)request withCustomerDelegate:(id)cusDelegate
{
    NSMutableArray *requestInfoArr = [NSMutableArray array];
    [requestInfoArr insertObject:request atIndex:0];
    if (cusDelegate) {
        [requestInfoArr insertObject:cusDelegate atIndex:1];
    }
    
    [self.requestStackDic setObject:requestInfoArr forKey:[NSString stringWithFormat:@"%@Canceld", serviceName]];
    
}

- (NSString *)getNSUrlStr:(NSDictionary *)parameter
{
    NSString *serviceRoot = [self->defaultOptions objectForKey:@"serviceRoot"];
    NSString *serviceUrl = [self->defaultOptions objectForKey:@"serviceUrl"];
    
    if ([serviceRoot isEqualToString:@""] || [serviceUrl isEqualToString:@""]) {
        [theLog pushLog:@"Service root or url is not config right"
                message:[NSString stringWithFormat:@"ServiceRoot: %@, ServiceUrl: %@", serviceRoot, serviceUrl]
                   type:iH_LOGS_EXCEPTION
                   file:__FILE__ function:__func__ line:__LINE__];
        NSAssert(1 == 0, @"Service root or url is not config right");
    }
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@", serviceRoot, serviceUrl];
    
    iHRequestMethod method = self->requestMethod ? self->requestMethod : [self getDefaultRequestMethod];
    if (iHRequestMethodGet == method) {
        BOOL firstPara = YES;
        if (self->commonOptions && [self->commonOptions count]) {
            for (NSString *key in self->commonOptions) {
                [urlStr appendString:(firstPara ?
                                      [NSString stringWithFormat:@"?%@=%@", key, [self encodeURL:[self->commonOptions objectForKey:key]]] :
                                      [NSString stringWithFormat:@"&%@=%@", key, [self encodeURL:[self->commonOptions objectForKey:key]]])];
                firstPara = NO;
            }
        }
        if (parameter && [parameter count]) {
            for (NSString *key in parameter) {
                NSString *value = [self getStringFromValue: [parameter objectForKey:key]];
                [urlStr appendString:(firstPara ?
                                      [NSString stringWithFormat:@"?%@=%@", key, [self encodeURL:value]] :
                                      [NSString stringWithFormat:@"&%@=%@", key, [self encodeURL:value]])];
                firstPara = NO;
            }
        }
    }
    
    return urlStr;
}

- (NSMutableDictionary *)getParsedResponse:(ASIHTTPRequest *)request
{
    NSMutableDictionary *dic = nil;
    iHResponseParseFormat parseFormat = self->responseParseFormat ? self->responseParseFormat : [self getDefaultResponseParseFormat];
    if (iHResponseParseFormatJSON == parseFormat) {
        dic = [self getJsonResponse:request];
    }
    
    return dic;
}

- (NSString *)removeFloatSign:(NSString *)sourceStr
{
    return [sourceStr stringByReplacingOccurrencesOfString:@"e+1" withString:@""];
}

- (NSMutableDictionary *)getJsonResponse:(ASIHTTPRequest *)request
{
//    NSString *responseString = [NSString stringWithFormat:@"{\"data\":%@}",[request responseString]];
    NSString *responseString = [request responseString];
    iHDINFO(@"\n**************\niHRequest, response string:\n%@\n**************\n", responseString);
    [theLog pushLog:[[request requestHeaders] objectForKey:@"serviceName"] message:responseString type:iH_LOGS_MESSAGE file:nil function:nil line:0];
    
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSMutableDictionary *responseDic = [NSMutableDictionary dictionaryWithDictionary:
                                        [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&e]];
    
    if (e) {
        [theLog pushLog:[[request requestHeaders] objectForKey:@"serviceName"]
                message:[NSString stringWithFormat:@"Code:%ld *** Domain:%@ *** UserInfo:%@", (long)e.code, e.domain, e.userInfo]
                   type:iH_LOGS_EXCEPTION
                   file:__FILE__ function:__func__ line:__LINE__];
    }
    
    return responseDic;
}

- (void)showIndicator:(BOOL)isShow
{
    return;
}

- (NSString *)getSpentTime
{
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.requestStartTime];
    NSString *timeStr = [[NSDate date] description];
    return [NSString stringWithFormat:@"%@ : %02li:%02li:%02li", timeStr,
            lround(floor(time / 3600.)) % 100,
            lround(floor(time / 60.)) % 60,
            lround(floor(time)) % 60];
}

- (NSString*)encodeURL:(NSString *)string
{
	NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

- (NSString *)getStringFromValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%d", [(NSNumber *)value intValue]];
    }
    
    return @"";
}
@end
