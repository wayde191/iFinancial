//
//  iHPubSub.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iHPubSub : NSObject

+ (void)subscribeWithSubject:(NSString *)subject byInstance:(id)instance;
+ (void)publishMsgWithSubject:(NSString *)subject andDataDic:(NSDictionary *)dic;
+ (void)unsubscribeWithSubject:(NSString *)subject ofInstance:(id)instance;

@end
