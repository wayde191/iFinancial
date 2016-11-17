//
//  iHLog.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IH_ERROR_LOG_VERSION_NUM    @"IHErrorLogVersionNumber"
#define IH_OLDEST_LOG_VERSION_NUM   @"IHOldestLogVersionNumber"
#define IH_DEBUG_SWITCH             1

typedef enum{
    iH_LOGS_EXCEPTION = 1,
    iH_LOGS_MESSAGE,
}iHEnumLogs;

@interface iHLog : NSObject {
    
@public
    BOOL isLogMessage;
    NSString *fileName;
    NSString *filePostfix;
    
@private
    NSMutableArray *elogs;
    NSMutableArray *mlogs;
}

@property(nonatomic, strong) NSMutableArray *elogs;
@property(nonatomic, strong) NSMutableArray *mlogs;
@property(nonatomic, assign) BOOL isLogMessage;
@property(nonatomic, strong) NSString *fileName;
@property(nonatomic, strong) NSString *filePostfix;

- (BOOL)pushLog:(NSString *)title message:(NSString *)msg type:(iHEnumLogs)type file:(char *)file function:(const char *)func line:(NSInteger)line;
- (void)clearLogs;
- (void)showLogs;
- (void)logMessageToFile;


@end
