//
//  iHAnalyseModel.m
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHAnalyseModel.h"
#import "iHYearTableViewController.h"

#define GET_ANALYSE_SERVICE          @"GetAnalyseService"

@implementation iHAnalyseModel
- (id)init{
    self = [super init];
    if (self) {
        self.yearAnalyDic = nil;
    }
    return self;
}

- (NSInteger)getMonthCount{
    if (!self.yearAnalyDic) {
        return 0;
    }
    
    return [[self.yearAnalyDic objectForKey:@"year"] count];
}

- (NSArray *)getTextForRow:(NSInteger)row {
    if (!self.yearAnalyDic) {
        return @[];
    }
    
    NSDictionary *rowDic = [[self.yearAnalyDic objectForKey:@"year"] objectAtIndex:row];
    NSString *text = rowDic[@"text"];
    NSRange firstBlankRange = [text rangeOfString:@" "];
    
    return @[[text substringToIndex:firstBlankRange.location], [text substringFromIndex:firstBlankRange.location + 1]];
}

- (NSArray *)getDetailsForSelectedIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *details = [NSMutableArray array];
    
    NSMutableDictionary *incomeFields = [NSMutableDictionary dictionary];
    NSMutableDictionary *outcomeFields = [NSMutableDictionary dictionary];
    
    NSMutableArray *incomeOutcomeArr = [NSMutableArray array];
    
    float earn = 0.0;
    float use = 0.0;
    
    if (0 == indexPath.row) { //Year
        NSArray *monthsArr = [[self.yearAnalyDic objectForKey:@"month"] allValues];
        for (int i = 0; i < monthsArr.count; i++) {
            NSDictionary *m = [monthsArr objectAtIndex:i];
            NSDictionary *statistic = [m objectForKey:@"statistic"];
            
            for (NSString *field in statistic) {
                NSRange incomeRange = [field rangeOfString:@"收入"];
                NSRange providentRange = [field rangeOfString:@"公积金款"];
                if (incomeRange.length > 0 || providentRange.length > 0) {
                    float fieldExistValue = [[incomeFields objectForKey:field] floatValue];
                    if (fieldExistValue) {
                        incomeFields[field] = [NSNumber numberWithFloat:(fieldExistValue + [statistic[field] floatValue])];
                    } else {
                        incomeFields[field] = statistic[field];
                    }
                } else {
                    float fieldExistValue = [[outcomeFields objectForKey:field] floatValue];
                    if (fieldExistValue) {
                        outcomeFields[field] = [NSNumber numberWithFloat:(fieldExistValue + [statistic[field] floatValue])];
                    } else {
                        outcomeFields[field] = statistic[field];
                    }
                }
            }
            
            [incomeOutcomeArr addObjectsFromArray:m[@"income"]];
            [incomeOutcomeArr addObjectsFromArray:m[@"outcome"]];
        }
        
        float yearIncome = [[self.yearAnalyDic objectForKey:@"yearIncome"] floatValue];
        float yearOutcome = [[self.yearAnalyDic objectForKey:@"yearOutcome"] floatValue];
        earn = yearIncome;
        use = yearOutcome;
        
        NSMutableDictionary *tempIncomeFields = [NSMutableDictionary dictionary];
        for (NSString *field in incomeFields) {
            float fieldValue = [incomeFields[field] floatValue];
            tempIncomeFields[field] = [NSString stringWithFormat:@"%@,%.02f@%.02f%@", field, fieldValue, (fieldValue / yearIncome) * 100, @"%"];
        }
        incomeFields = tempIncomeFields;
        
        NSMutableDictionary *tempOutcomeFields = [NSMutableDictionary dictionary];
        for (NSString *field in outcomeFields) {
            float fieldValue = [outcomeFields[field] floatValue];
            tempOutcomeFields[field] = [NSString stringWithFormat:@"%@,%.02f@%.02f%@", field, fieldValue, (fieldValue / yearOutcome) * 100, @"%"];
        }
        outcomeFields = tempOutcomeFields;
        
    } else { // Month
        
        NSString *monthId = [[[self.yearAnalyDic objectForKey:@"year"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        NSDictionary *m = [[self.yearAnalyDic objectForKey:@"month"] objectForKey:monthId];
        
        NSDictionary *statistic = m[@"statistic"];
        earn = [m[@"earn"] floatValue];
        use = [m[@"use"] floatValue];
        
        for (NSString *field in statistic) {
            NSRange incomeRange = [field rangeOfString:@"收入"];
            NSRange providentRange = [field rangeOfString:@"公积金款"];
            if (incomeRange.length > 0 || providentRange.length > 0) {
                float fieldValue = [statistic[field] floatValue];
                incomeFields[field] = [NSString stringWithFormat:@"%@,%.02f@%.02f%@", field, fieldValue, (fieldValue / earn) * 100, @"%"];
            } else {
                float fieldValue = [statistic[field] floatValue];
                outcomeFields[field] = [NSString stringWithFormat:@"%@,%.02f@%.02f%@", field, fieldValue, (fieldValue / use) * 100, @"%"];
            }
        }

        [incomeOutcomeArr addObjectsFromArray:m[@"income"]];
        [incomeOutcomeArr addObjectsFromArray:m[@"outcome"]];
        
    }
    
    if (incomeFields) {
        NSString *incomeStr = [NSString stringWithFormat:@"收入:%.02f", earn];
        for (NSString *field in incomeFields) {
            incomeStr = [NSString stringWithFormat:@"%@ || %@",incomeStr, incomeFields[field]];
        }
        [details addObject:@{@"text":incomeStr}];
    }
    
    if (outcomeFields) {
        NSString *incomeStr = [NSString stringWithFormat:@"支出:%.02f", use];
        for (NSString *field in outcomeFields) {
            incomeStr = [NSString stringWithFormat:@"%@ || %@", incomeStr, outcomeFields[field]];
        }
        [details addObject:@{@"text":incomeStr}];
    }
    
    [details addObjectsFromArray:incomeOutcomeArr];
    
    return [NSArray arrayWithArray:details];
}

- (void)doCallServiceGetAnalyseForYear:(NSString *)year {
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:
                           [User sharedInstance].getUserId, @"uid",
                           year, @"year",
                           nil];
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_ANALYSE_SERVICE  withParameters:paras andServiceUrl:SERVICE_GET_ANALYSES forDelegate:self];
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:GET_ANALYSE_SERVICE]) {
        self.yearAnalyDic = [response.userInfoDic objectForKey:@"data"];
        if (delegate && [delegate respondsToSelector:@selector(reloadTableView)]) {
            [delegate performSelector:@selector(reloadTableView) withObject:nil];
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
