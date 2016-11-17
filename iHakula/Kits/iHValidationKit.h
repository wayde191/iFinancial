//
//  IHValidationKit.h
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iHValidationKit : NSObject

+ (BOOL)isValueEmpty:(id)value;
+ (BOOL)doCheckEmailFormat:(NSString *)email;
+ (BOOL)doCheckMobilePhoneNumber:(NSString *)phoneNumber;
+ (BOOL)doCheckIdNumber:(NSString *)idNumber;
+ (BOOL)doCheckPassportNumber:(NSString *)passportNumber;
+ (BOOL)doCheckURL:(NSString *)url;
+ (BOOL)doPassport:(NSString *)passport;
+ (BOOL)doCheckFloatNumber:(NSString *)strNumber;

@end
