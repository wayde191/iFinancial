//
//  iHAddAccountModel.m
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHAddAccountModel.h"
#import "iHAddAccountViewController.h"

#define GET_FIELDS_SERVICE          @"GetFieldsService"
#define ADD_RECORD_SERVICE          @"AddRecordService"

@interface iHAddAccountModel (){
}

@end

@implementation iHAddAccountModel

- (id)init{
    self = [super init];
    if (self) {
        self.allFieldTypes = [[User sharedInstance].allAccountTypes objectForKey:@"data"];
    }
    return self;
}

- (BOOL)isRefreshedToday {
    NSDictionary *allTypes = [User sharedInstance].allAccountTypes;
    NSDateComponents *refreshedDay = [allTypes objectForKey:@"timetamp"];
    if (!allTypes) {
        return NO;
    }
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    if([today day] != [refreshedDay day] ||
       [today month] != [refreshedDay month] ||
       [today year] != [refreshedDay year] ){
        return NO;
    }
    
    return YES;
}

- (NSInteger)getDetailFieldsRowNumberInSelectedFirstComponent:(NSInteger)selectedRow {
    if (!self.allFieldTypes) {
        return 0;
    }
    
    NSArray *allCategorys = [self.allFieldTypes allKeys];
    NSString *caId = [allCategorys objectAtIndex:selectedRow];
    NSArray *details = [[self.allFieldTypes objectForKey:caId] objectForKey:@"details"];
    
    return details.count;
}

- (NSString *)getCategoryTitleByRow:(NSInteger)row {
    if (!self.allFieldTypes) {
        return @"";
    }
    
    NSArray *allCategorys = [self.allFieldTypes allKeys];
    NSString *caId = [allCategorys objectAtIndex:row];
    NSString *category = [[[self.allFieldTypes objectForKey:caId] objectForKey:@"fields"] objectForKey:@"field"];
    
    return category;
}

- (NSString *)getDetailTitleForComponent:(NSInteger)selectedComponent forRow:(NSInteger)row {
    if (!self.allFieldTypes) {
        return @"";
    }
    
    NSArray *allCategorys = [self.allFieldTypes allKeys];
    NSString *caId = [allCategorys objectAtIndex:selectedComponent];
    NSString *detail = [[[[self.allFieldTypes objectForKey:caId] objectForKey:@"details"] objectAtIndex:row] objectForKey:@"name"];
    
    return detail;
}

- (NSString *)getSelectedCategoryIdByComponentRow:(NSInteger)component {
    NSArray *allCategorys = [self.allFieldTypes allKeys];
    NSString *caId = [allCategorys objectAtIndex:component];
    
    return caId;
}

- (NSString *)getSelectedDetailIdForComponent:(NSInteger)component forDetailRow:(NSInteger)row {
    NSArray *allCategorys = [self.allFieldTypes allKeys];
    NSString *caId = [allCategorys objectAtIndex:component];
    NSString *detailId = [[[[self.allFieldTypes objectForKey:caId] objectForKey:@"details"] objectAtIndex:row] objectForKey:@"ID"];
    
    return detailId;
}

- (void)doCallServiceGetFields {
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_FIELDS_SERVICE  withParameters:nil andServiceUrl:SERVICE_GET_FIELDS forDelegate:self];

}

- (void)doCallServiceAddRecord:(NSDictionary *)paras {
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:ADD_RECORD_SERVICE  withParameters:paras andServiceUrl:SERVICE_ADD_RECORD forDelegate:self];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:GET_FIELDS_SERVICE]) {
        
        NSMutableDictionary *allTypes = [NSMutableDictionary dictionary];
        [allTypes setObject:[response.userInfoDic objectForKey:@"data"] forKey:@"data"];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        [allTypes setObject:today forKey:@"timetamp"];
        
        self.allFieldTypes = [NSDictionary dictionaryWithDictionary:[response.userInfoDic objectForKey:@"data"]];
        [User sharedInstance].allAccountTypes = allTypes;
        
        if (delegate && [delegate respondsToSelector:@selector(fieldsUpdated)]) {
            [delegate performSelector:@selector(fieldsUpdated) withObject:nil];
        }
    } else if([response.serviceName isEqualToString:ADD_RECORD_SERVICE]) {
        if (delegate && [delegate respondsToSelector:@selector(addRecordSuccess)]) {
            [delegate performSelector:@selector(addRecordSuccess) withObject:nil];
        }
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response {
    
    [super serviceCallFailed:response];
    NSString *msg = @"";
    switch ([response.errorCode intValue]) {
        case 1102:
            msg = @"用户信息不全，请重新登录";
            break;
        case 1110:
            msg = @"用户信息已过期，请重新登录";
            break;
        default:
            msg = @"服务器错误，请稍后重试";
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMessage:)]) {
        [self.delegate performSelector:@selector(showMessage:) withObject:msg];
        if ([response.errorCode intValue] == 1110) {
            [self.delegate performSelector:@selector(gotoLoginViewController) withObject:nil afterDelay:2.0];
        }
    }
}


@end
