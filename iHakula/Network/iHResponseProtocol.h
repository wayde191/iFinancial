//
//  iHResponseProtocol.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iHResponseProtocol <NSObject>

@required
- (NSString *)serviceName;
- (NSString *)status;
- (NSString *)errorCode;

@optional
- (NSDictionary *)userInfoDic;

- (id)initWithDic:(NSDictionary *)dic;

@end
