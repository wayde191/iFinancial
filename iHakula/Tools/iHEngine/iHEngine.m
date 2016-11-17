//
//  iHEngine.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHEngine.h"
#import "iHSingletonCloud.h"
#import "iHNetworkMonitor.h"
#import "iHRequest.h"
#import "iHValidationKit.h"
#import "iHCacheCenter.h"
#import "iHLog.h"
#import "iHCommonMacros.h"

@interface iHEngine ()
- (BOOL)setupLogSystem:(NSDictionary *)dic;
- (BOOL)setupNetworkMonitor:(NSString *)hostName;
- (BOOL)setupRequestEnv:(NSString *)rootUrl;
@end

//Singleton model
static iHEngine *singletonInstance = nil;

@implementation iHEngine
@synthesize howEngineDoing;

void uncaughtExceptionHandler(NSException *e){
    iHLog *log = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
    [log pushLog:[NSString stringWithFormat:@"%@ ------- version: %@ \r\n<br/ ><br/ >Uncaught Exception", @"iHakula", @"LOCAL_APP_VERSION"]
         message:[NSString stringWithFormat:@"Name:%@ <br/> *** Reason:%@ \r\n<br/> *** UserInfo:%@ \r\n<br/> CallStackReturnAddresses:%@ \r\n<br/> CallStackSymbols:%@", e.name, e.reason, e.userInfo, e.callStackReturnAddresses, [e.callStackSymbols componentsJoinedByString:@"\r\n<br/>"]]
            type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
    [log logMessageToFile];
}

#pragma mark - Singleton Instance
+ (id)sharedInstance
{
    //The @synchronized()directive locks a section of code for use by a single thread
    @synchronized(self){
        if (!singletonInstance) {
            singletonInstance = [[iHEngine alloc] init];
        }
        
        return singletonInstance;
    }
    
    return nil;
}

#pragma mark - Engine switch
+ (BOOL)start
{
    //Set up uncaught exception handler
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //Build up singleton instance firstly
    iHEngine *engine = [iHEngine sharedInstance];
    
    //Get configuration
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"conf" ofType:@"plist"];
    NSDictionary *confDic = [NSDictionary dictionaryWithContentsOfFile:confPath];
    
    //Setup log system
    if (![engine setupLogSystem:[confDic objectForKey:@"logInfo"]]) {
        engine.howEngineDoing = iH_FAILURE;
    }
    
    //Setup network monitor
    //    NSString *hostName = [[confDic objectForKey:@"serviceInfo"] objectForKey:@"hostName"];
    if (![engine setupNetworkMonitor:HOST_NAME]) {
        engine.howEngineDoing = iH_FAILURE;
    }
    
    //Setup Request environment
    //    NSString *rootUrl = [[confDic objectForKey:@"serviceInfo"] objectForKey:@"rootUrl"];
    if (![engine setupRequestEnv:SERVICE_ROOT_URL]) {
        engine.howEngineDoing = iH_FAILURE;
    }
    
    return engine.howEngineDoing;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.howEngineDoing = iH_SUCCESS;
    }
    return self;
}

- (BOOL)setupLogSystem:(NSDictionary *)dic
{
    NSAssert(dic != nil, @"Log info dictionary is not empty");
    iHLog *log = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
    log.isLogMessage = [(NSNumber *)[dic valueForKey:@"isLogMessage"] boolValue];
    log.fileName = [dic valueForKey:@"logFileName"];
    log.filePostfix = [dic valueForKey:@"logFilePostfix"];
    
    return YES;
}

- (BOOL)setupNetworkMonitor:(NSString *)hostName
{
    NSAssert(hostName != nil, @"Network monitor host name is not empty");
    iHNetworkMonitor *monitor = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHNetworkMonitor"];
    monitor.hostUrl = hostName;
    [monitor startNotifer];
    
    return YES;
}

- (BOOL)setupRequestEnv:(NSString *)rootUrl
{
    NSAssert(rootUrl != nil, @"Request servie root url is not empty");
    iHRequest *request = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHRequest"];
    
    //Default options
    [request setupDefaultOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  rootUrl, @"serviceRoot",
                                  nil]];
    
    // Header
//    NSString *authValue = [NSString stringWithFormat:@"Basic %@",
//                           [NSString base64forData:
//                            [[NSString stringWithFormat:@"%@:%@", @"apps", @"3espe2ANAkaSwece"] dataUsingEncoding:NSUTF8StringEncoding]]];
//    [request setupExtraHeaders:[NSDictionary dictionaryWithObjectsAndKeys:
//                                authValue, @"Authorization",
//                                nil]];
    
    // Common options
        [request setupCommonOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                     SECURITY_CODE, @"sCode",
                                     nil]];
    
    
    return YES;
}


@end
