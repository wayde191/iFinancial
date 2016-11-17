//
//  iHNetworkMonitor.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHNetworkMonitor.h"
#import "Reachability.h"
#import "iHLog.h"
#import "iHPubSub.h"
#import "iHSingletonCloud.h"

@implementation iHNetworkMonitor
@synthesize isReachable, isUsing3G, theReachability, hostUrl, networkTrafficInfo;

- (id)init{
    self = [super init];
    if (self) {
        self.networkTrafficInfo = @"";
    }
    return self;
}


- (void)restore
{
    self.isReachable = NO;
    self.isUsing3G = NO;
    self.networkTrafficInfo = @"";
    self.hostUrl = @"";
    self.theReachability = nil;
}

- (void)startNotifer
{
    NSAssert(hostUrl != nil, @"Network Monitor's host URL is not Empty");
    [iHPubSub subscribeWithSubject:kReachabilityChangedNotification byInstance:self];
    self.theReachability = [Reachability reachabilityWithHostName:self->hostUrl];
    NetworkStatus firstStatu = [self->theReachability currentReachabilityStatus];
    self.isReachable = firstStatu == NotReachable ? NO : YES;
    networkStatus = firstStatu;
    [self->theReachability startNotifer];
}

#pragma mark - iHPubSub Message
- (void)iHMsgReceivedWithSender:(NSNotification *)sender
{
    Reachability *curReach = [sender object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self buildNetworkTrafficInfo:curReach];
    
    //Record current network traffic
    networkStatus = [curReach currentReachabilityStatus];
    self.isReachable = networkStatus == NotReachable ? NO : YES;
    if (ReachableViaWWAN == networkStatus) {
        self.isUsing3G = YES;
    }else if (ReachableViaWiFi == networkStatus) {
        self.isUsing3G = NO;
    }
}

- (void)buildNetworkTrafficInfo:(Reachability *)currReach
{
    iHLog *theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
    if (currReach != self->theReachability) {
        [theLog pushLog:@"Info" message:@"Reveived unrelated message" type:iH_LOGS_MESSAGE file:nil function:nil line:0];
        return;
    }
    
    NetworkStatus currentNetworkStatus = [currReach currentReachabilityStatus];
    NSMutableString *msg = [NSMutableString stringWithString:@""];
    
    if (currentNetworkStatus == NotReachable) {
        //Current network status is off
        if (networkStatus != NotReachable) {
            [msg appendString:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CheckNetWork")];
        }else {
            [msg appendString:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CheckNetWork")];
        }
        
    }else {
        
        //Current network is on
        if (networkStatus == NotReachable) {
            [msg appendString:@"The network connection has been restored"];
            if (currentNetworkStatus == ReachableViaWWAN) {
                [msg appendString:@"，you are currently using a 3g network"];
            }
        } else {
            if (currentNetworkStatus == ReachableViaWWAN) {
                [msg appendString:@"you are currently using a 3g network"];
            }
        }
    }
    if (![msg isEqualToString:@""]) {
        self.networkTrafficInfo = [NSString stringWithString:msg];
        [theLog pushLog:@"Info" message:self->networkTrafficInfo type:iH_LOGS_MESSAGE file:nil function:nil line:0];
    }
    
}

@end
