//
//  iHPubSub.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHPubSub.h"
#import "iHLog.h"
#import "iHSingletonCloud.h"

#pragma mark - Category NSObject ( iHPubSubCategory )
@interface NSObject ( iHPubSubCategory )
- (void)iHMsgReceivedWithSender:(NSNotification *)sender;
@end

@implementation NSObject ( iHPubSubCategory )

- (void)iHMsgReceivedWithSender:(NSNotification *)sender
{
    iHLog *theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
    [theLog pushLog:@"iHPubSubCategory"
            message:@"Please rewrite method -(void) iHMsgReceivedWithSender: (NSNotification *)sender"
               type:iH_LOGS_MESSAGE
               file:nil
           function:nil
               line:0];
}

@end

#pragma mark - Class iHPubSub
@implementation iHPubSub

#pragma mark - Class Methods
+ (void)publishMsgWithSubject:(NSString *)subject andDataDic:(NSDictionary *)dic
{
    if (!subject) {
        iHLog *theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        [theLog pushLog:@"iHPubSub, Publish"
                message:@"Subject is nil"
                   type:iH_LOGS_EXCEPTION
                   file:nil function:nil line:0];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:nil userInfo:dic];
}

+ (void)subscribeWithSubject:(NSString *)subject byInstance:(id)instance
{
    if (!subject || !instance) {
        iHLog *theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        [theLog pushLog:@"iHPubSub, Subscribe"
                message:@"Subject or instance is nil"
                   type:iH_LOGS_EXCEPTION
                   file:nil function:nil line:0];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(iHMsgReceivedWithSender:) name:subject object:nil];
}

+ (void)unsubscribeWithSubject:(NSString *)subject ofInstance:(id)instance
{
    if (!subject || !instance) {
        iHLog *theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        [theLog pushLog:@"iHPubSub, unSubscribe"
                message:@"Subject or instance is nil"
                   type:iH_LOGS_EXCEPTION
                   file:nil function:nil line:0];
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:instance name:subject object:nil];
}

@end
