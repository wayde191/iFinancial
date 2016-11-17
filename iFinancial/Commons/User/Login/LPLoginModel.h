//
//  LPLoginModel.h
//  LocatePeople
//
//  Created by Wayde Sun on 7/10/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@interface LPLoginModel : FBaseModel

- (void)doCallRegisterService:(NSDictionary *)paras;
- (void)doCallLoginService:(NSDictionary *)paras;
- (void)doCallLogoutService;

@end
