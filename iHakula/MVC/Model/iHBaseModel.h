//
//  iHBaseModel.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

/*************************** SERVER DEBUG ****************************/
#define IH_SERVER_DEBUG_SWITCH           0
#define IH_DUMMY_DATA_SWITCH             0

#import <Foundation/Foundation.h>
#import "iHRequest.h"
#import "iHCacheCenter.h"
#import "iHNetworkMonitor.h"

@interface iHBaseModel : NSObject <iHRequestDelegate> {
@public
    id __weak delegate;
    iHRequest *theRequest;
}

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) iHRequest *theRequest;
@property (weak, nonatomic) iHNetworkMonitor *sysNetworkMonitor;

- (void)serviceCallSuccess:(iHResponseSuccess *)response;
- (void)serviceCallFailed:(iHResponseSuccess *)response;

- (BOOL)doCallService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate;
- (BOOL)doCallHttpService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate;

- (NSDictionary *)getPlistDicByName:(NSString *)plistName;

@end
