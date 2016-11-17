//
//  IHValidationKit.m
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHValidationKit.h"

@implementation iHValidationKit

/*
 * Functionality: check NSString, NSArray, NSDictionary is empty or not
 * @"", [], {}, are empty objects
 */
+ (BOOL)isValueEmpty:(id)value
{
    BOOL checkResult = NO;
    if (!value) {
        checkResult = YES;
        return checkResult;
    }
    if ([value isKindOfClass:[NSString class]] && ([value isEqualToString:@""] || [value isEqualToString:@"<null>"])) {
        checkResult = YES;
    } else if (([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) && ![value count]) {
        checkResult = YES;
    } else if ([value isKindOfClass:[NSNull class]]) {
        checkResult = YES;
    }
    
    return checkResult;
}

+ (BOOL)doCheckEmailFormat:(NSString *)email
{
    BOOL checkResult = YES;
    
    checkResult = ![self isValueEmpty:email];
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    if (![emailTest evaluateWithObject:email]) {
        checkResult = NO;
    }
    
    return checkResult;
}

+ (BOOL)doCheckMobilePhoneNumber:(NSString *)phoneNumber {
    BOOL checkResult = YES;
    BOOL checkResult2 = YES;
    checkResult = ![self isValueEmpty:phoneNumber];
    checkResult2 = checkResult;
    
    if (checkResult) {
        NSString *mobilePhoneRegex = @"^((0[0-9]{2,3})-)([0-9]{7,8})(-([0-9]{3,}))?$";
        NSPredicate *mobilePhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobilePhoneRegex];
        if (![mobilePhoneTest evaluateWithObject:phoneNumber]) {
            checkResult = NO;
        }
    }
    
    if (checkResult2) {
        NSString *mobilePhoneRegex = @"(^[0-9]{7,8}$)|(^1[358][0-9]{9}$)";
        NSPredicate *mobilePhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobilePhoneRegex];
        if (![mobilePhoneTest evaluateWithObject:phoneNumber]) {
            checkResult2 = NO;
        }
    }
    
    return checkResult || checkResult2;
    
    // /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/  // home phone
    // /^1[35]\d{9}$/  // mobile phone
}

+ (BOOL)doCheckPassportNumber:(NSString *)passportNumber {
    BOOL checkResult = YES;
    checkResult = ![self isValueEmpty:passportNumber];
    
    if (checkResult) {
        NSString *idRegex = @"(P[0-9]{7})|(G[0-9]{8})";
        NSPredicate *idTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idRegex];
        if (![idTest evaluateWithObject:passportNumber]) {
            checkResult = NO;
        }
    }
    
    return checkResult;
}

+ (BOOL)doCheckIdNumber:(NSString *)idNumber {
    BOOL checkResult = YES;
    checkResult = ![self isValueEmpty:idNumber];
    
    if (checkResult) {
        NSString *idRegex = @"[0-9xX]{18}";
        NSPredicate *idTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idRegex];
        if (![idTest evaluateWithObject:idNumber]) {
            checkResult = NO;
        }
    }
    
    return checkResult;
}

+ (BOOL)doPassport:(NSString *)passport{
    BOOL checkResult = YES;
    checkResult = ![self isValueEmpty:passport];
    
    if (checkResult) {
        NSString *idRegex = @"^(P\\d{7})|(G\\d{8})$";
        NSPredicate *idTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idRegex];
        if (![idTest evaluateWithObject:passport]) {
            checkResult = NO;
        }
    }
    
    return checkResult;
}
+ (BOOL)doCheckURL:(NSString *)url
{
    BOOL checkResult = YES;
    checkResult = ![self isValueEmpty:url];
    
    if (checkResult) {
//        NSString *urlRegex = @"((https|http|ftp|rtsp|mms)?://)?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?(([0-9]{1,3}/.){3}[0-9]{1,3}|([0-9a-z_!~*'()-]+/.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]/.[a-z]{2,6})(:[0-9]{1,4})?((/?)|(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)";
        
//        (:[0-9]{1,4})?[A-Za-z0-9/.-]*
        NSString *urlRegex = @"(http|HTTP|ftp|FTP){1}(://){1}[0-9a-zA-Z/.-_]+(:[0-9]{1,4})?[0-9a-zA-Z/.-_]*";
        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
        if (![urlTest evaluateWithObject:url]) {
            checkResult = NO;
        }
    }
    
    return checkResult;
}

+ (BOOL)doCheckFloatNumber:(NSString *)strNumber
{
    BOOL checkResult = YES;
    
    if (checkResult) {
        NSString *idRegex = @"^([0-9]+)(.{0,1}[0-9]*)$";
        NSPredicate *idTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idRegex];
        if (![idTest evaluateWithObject:strNumber]) {
            checkResult = NO;
        }
    }
    
    return checkResult;
    
    
}


@end
