//
//  iHLog.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHLog.h"
#import "iHSingletonCloud.h"
#import "iHMemory.h"
#import "iHValidationKit.h"
#import "iHFileManager.h"
#import "iHCommonMacros.h"
#import "iHDebug.h"

@interface iHLog ()
- (NSString *)getDocumentPath;
- (NSString *)getLogString;
- (NSString *)getTxtFormatStr;
- (NSString *)getHtmlFormatStr;
@end

@implementation iHLog
@synthesize elogs, mlogs, isLogMessage, fileName, filePostfix;

- (id)init
{
    self = [super init];
    if (self) {
        self.elogs = [NSMutableArray array];
        self.mlogs = [NSMutableArray array];
        if ([iHValidationKit isValueEmpty:[USER_DEFAULT objectForKey:IH_ERROR_LOG_VERSION_NUM]]) {
            [USER_DEFAULT setValue:@"1" forKey:IH_ERROR_LOG_VERSION_NUM];
            [USER_DEFAULT setValue:@"0" forKey:IH_OLDEST_LOG_VERSION_NUM];
            [USER_DEFAULT synchronize];
        }
    }
    
    return self;
}


#pragma mark - Methods
- (BOOL)pushLog:(NSString *)title message:(NSString *)msg type:(iHEnumLogs)type file:(char *)file function:(const char *)func line:(NSInteger)line
{
    NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    NSString *detailInfo = @"";
    
    if (file && func && line) {
        detailInfo = [NSString stringWithFormat:@"<br/><b>FILE:</b>%@ **** <b>FUNCTION:</b>%@ **** <b>LINE:</b>%ld",
                      [NSString stringWithUTF8String:file],
                      [NSString stringWithUTF8String:func],
                      (long)line];
    }
    
    [msgDic setValue:title forKey:@"title"];
    msg = [msg stringByAppendingString:detailInfo];
    [msgDic setValue:msg forKey:@"message"];
    
    if (type == iH_LOGS_MESSAGE) {
        [self->mlogs addObject:msgDic];
    }else if(type == iH_LOGS_EXCEPTION){
        [self->elogs addObject:msgDic];
    }else{
        return NO;
    }
    
    return YES;
}

- (void)clearLogs
{
    [elogs removeAllObjects];
    [mlogs removeAllObjects];
}

- (void)showLogs
{
    for (NSDictionary *dataDic in self->elogs) {
        iHDINFO(@"%@ : %@--%@", @"EXCEPTION", [dataDic valueForKey:@"title"], [dataDic valueForKey:@"message"]);
    }
    for (NSDictionary *dataDic in self->mlogs) {
        iHDINFO(@"%@ : %@--%@", @"LOG", [dataDic valueForKey:@"title"], [dataDic valueForKey:@"message"]);
    }
    
    return;
}

#pragma mark - Private Methods
- (NSString *)getLogString {
    NSString *logString = nil;
    if ([filePostfix isEqualToString:@"txt"]) {
        logString = [self getTxtFormatStr];
    } else if ([filePostfix isEqualToString:@"html"]) {
        logString = [self getHtmlFormatStr];
    }
    return logString;
}

- (NSString *)getTxtFormatStr {
    NSString *txt = @"";
    
    for (NSDictionary *dataDic in self->elogs) {
        NSString *exceptionMsg = [NSString stringWithFormat:@"%@:%@\n\r", [dataDic valueForKey:@"title"], [dataDic valueForKey:@"message"]];
        txt = [txt stringByAppendingString:exceptionMsg];
    }
    
    for (NSDictionary *dataDic in self->mlogs) {
        NSString *exceptionMsg = [NSString stringWithFormat:@"%@:%@\r\n", [dataDic valueForKey:@"title"], [dataDic valueForKey:@"message"]];
        txt = [txt stringByAppendingString:exceptionMsg];
    }
    
    return txt;
}

- (NSString *)getHtmlFormatStr
{
    NSString *htmlStr = @"<html><head><meta http-equiv='Content-Type' content='text/html;charset=UTF-8'><title>iHakula Logs</title><style>body{ margin: 20px; } #type{ background-color: #32CD32; color: #FOFFFF; font-size: 20px;} .title{ color: #00BFFF; } </style></head><body><p id='type'>Exceptions<p>";
    
    for (NSDictionary *dataDic in self->elogs) {
        NSString *exceptionMsg = [NSString stringWithFormat:@"<p><span class='title'>%@:    </span><span>%@</span></p>", [dataDic valueForKey:@"title"], [dataDic valueForKey:@"message"]];
        htmlStr = [htmlStr stringByAppendingString:exceptionMsg];
    }
    
    htmlStr = [htmlStr stringByAppendingString:@"<p id='type'>Logs<p>"];
    for (NSDictionary *dataDic in self->mlogs) {
        NSString *exceptionMsg = [NSString stringWithFormat:@"<p><span class='title'>%@:    </span><span>%@</span></p>", [dataDic valueForKey:@"title"], [dataDic valueForKey:@"message"]];
        htmlStr = [htmlStr stringByAppendingString:exceptionMsg];
    }
    
    htmlStr = [htmlStr stringByAppendingString:@"</body></html>"];
    return htmlStr;
}

- (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (void)logMessageToFile{
    if (isLogMessage) {
        [self pushLog:@"Exception Memory" message:[iHMemory getCurrentMemoryStatus] type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
        [self pushLog:@"Exception Date" message:[[NSDate date] description] type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
        [iHFileManager createFolder:@"logs"];
        
        NSError *error = nil;
        NSString *logName = [USER_DEFAULT objectForKey:IH_ERROR_LOG_VERSION_NUM];
        NSString *file = [NSString stringWithFormat:@"logs/%@.%@", logName, filePostfix];
        NSAssert(file != nil, @"Logs  file name is not empay");
        NSString *path = [[self getDocumentPath] stringByAppendingPathComponent:file];
        NSString *htmlStr = [self getLogString];
        if (IH_DEBUG_SWITCH) {
            iHDINFO(@"%@", htmlStr);
        }
        
        if (![htmlStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
            NSString *file = [NSString stringWithUTF8String:__FILE__];
            NSString *functionName = [NSString stringWithUTF8String:__func__];
            if (file && functionName) {
                ;
            }
            iHDINFO(@"%@", [NSString stringWithFormat:@"%@:%@:%d **** %@", file, functionName, __LINE__, [error localizedDescription]]);
            
        } else {
            
            NSInteger logVersion = [logName integerValue];
            logVersion++;
            [USER_DEFAULT setValue:[NSString stringWithFormat:@"%ld", (long)logVersion] forKey:IH_ERROR_LOG_VERSION_NUM];
            [USER_DEFAULT synchronize];
        }
    }
}


@end
