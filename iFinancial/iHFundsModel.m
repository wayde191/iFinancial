//
//  iHFundsModel.m
//  iFinancial
//
//  Created by sun wayde on 3/13/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#define UPDATE_PURCHASED_UNIT_SERVICE       @"UpdatePurchasedUnitService"

#import "iHFundsModel.h"
#import "iHFundsViewController.h"
#import "Fund.h"

@interface iHFundsModel (){
    NSString *_modifiedPurchasedFundsStr;
}

- (NSArray *)getDecendingFundsArr;
- (void)updatePurchasedFundsArr;
@end

@implementation iHFundsModel

- (id)init
{
    self = [super init];
    if (self) {
        _allFundsDescendingArr = [self getDecendingFundsArr];
    }
    return self;
}

#pragma mark - Public Methods
- (void)doCallUpdatePurchasedUnitService:(NSDictionary *)modifiedFunds
{
    NSString *combinedModifiyStr = nil;
    
    if ([User sharedInstance].purchasedFundsArr.count > 0) {
        
        NSMutableArray *foundedIds = [NSMutableArray array];
        for (int i = 0; i < [User sharedInstance].purchasedFundsArr.count; i++) {
            NSDictionary *purchasedFunds = [[User sharedInstance].purchasedFundsArr objectAtIndex:i];
            NSString *fid = [[purchasedFunds allKeys] firstObject];
            
            BOOL notFound = YES;
            for (NSIndexPath *fundPath in modifiedFunds) {
                Fund *f = [_allFundsDescendingArr objectAtIndex:fundPath.row];
                if ([fid isEqualToString:f.fid]) {
                    notFound = NO;
                    [foundedIds addObject:fundPath];
                    
                    if (combinedModifiyStr) {
                        combinedModifiyStr = [NSString stringWithFormat:@"%@,%@:%@", combinedModifiyStr, f.fid, [modifiedFunds objectForKey:fundPath]];
                    } else {
                        combinedModifiyStr = [NSString stringWithFormat:@"%@:%@", f.fid, [modifiedFunds objectForKey:fundPath]];
                    }
                    break;
                }
            }
            
            if (notFound) {
                NSString *value = [[purchasedFunds allValues] firstObject];
                if (combinedModifiyStr) {
                    combinedModifiyStr = [NSString stringWithFormat:@"%@,%@:%@", combinedModifiyStr, fid, value];
                } else {
                    combinedModifiyStr = [NSString stringWithFormat:@"%@:%@", fid, value];
                }
            }
        }
        
        if (foundedIds.count < modifiedFunds.count) {
            for (NSIndexPath *fundPath in modifiedFunds) {
                if (![foundedIds containsObject:fundPath]) {
                    Fund *f = [_allFundsDescendingArr objectAtIndex:fundPath.row];
                    if (combinedModifiyStr) {
                        combinedModifiyStr = [NSString stringWithFormat:@"%@,%@:%@", combinedModifiyStr, f.fid, [modifiedFunds objectForKey:fundPath]];
                    } else {
                        combinedModifiyStr = [NSString stringWithFormat:@"%@:%@", f.fid, [modifiedFunds objectForKey:fundPath]];
                    }
                }
            }
        }
    } else {
        for (NSIndexPath *fundPath in modifiedFunds) {
            Fund *f = [_allFundsDescendingArr objectAtIndex:fundPath.row];
            if (combinedModifiyStr) {
                combinedModifiyStr = [NSString stringWithFormat:@"%@,%@:%@", combinedModifiyStr, f.fid, [modifiedFunds objectForKey:fundPath]];
            } else {
                combinedModifiyStr = [NSString stringWithFormat:@"%@:%@", f.fid, [modifiedFunds objectForKey:fundPath]];
            }
        }

    }
    
    NSString *changes = nil;
    for (NSIndexPath *fundPath in modifiedFunds) {
        Fund *f = [_allFundsDescendingArr objectAtIndex:fundPath.row];
        if (changes) {
            changes = [NSString stringWithFormat:@"%@,%@:%@", changes, f.fid, [modifiedFunds objectForKey:fundPath]];
        } else {
            changes = [NSString stringWithFormat:@"%@:%@", f.fid, [modifiedFunds objectForKey:fundPath]];
        }
    }
    
    NSString *uid = nil;
    if ([[User sharedInstance] isUserLoggedIn]) {
        uid = [[User sharedInstance] getUserId];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gotoLoginViewController)]) {
            [self.delegate performSelector:@selector(gotoLoginViewController) withObject:nil afterDelay:0.3];
        }
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          combinedModifiyStr, @"all",
                          changes, @"purchased",
                          uid, @"user_id",
                          @"free", @"type",
                          nil];
    
    NSString *utoken = [USER_DEFAULT objectForKey:IH_DEVICE_TOKEN];
    if (utoken) {
        [para setValue:utoken forKeyPath:@"user_token"];
    }
    if (!IH_FREE) {
        [para setValue:@"nonfree" forKey:@"type"];
    }
    
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:UPDATE_PURCHASED_UNIT_SERVICE  withParameters:para andServiceUrl:SERVICE_UPDATE_PURCHASED_UNIT forDelegate:self];
    
    // All funds
    _modifiedPurchasedFundsStr = combinedModifiyStr;
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:UPDATE_PURCHASED_UNIT_SERVICE]) {
        [self updatePurchasedFundsArr];
        _allFundsDescendingArr = [self getDecendingFundsArr];
        if (delegate && [delegate respondsToSelector:@selector(saveModifiesSuccess)]) {
            [delegate performSelector:@selector(saveModifiesSuccess) withObject:nil];
        }
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response
{
    [super serviceCallFailed:response];
    if ([response.serviceName isEqualToString:UPDATE_PURCHASED_UNIT_SERVICE]) {
        if (delegate && [delegate respondsToSelector:@selector(saveModifiesFailued)]) {
            [delegate performSelector:@selector(saveModifiesFailued) withObject:nil];
        }
    }
}

#pragma mark - Private Methods
- (void)updatePurchasedFundsArr
{
    NSArray *purchasedFunds = [_modifiedPurchasedFundsStr componentsSeparatedByString:@","];
    NSMutableArray *pfarr = [NSMutableArray array];
    for (NSString *f in purchasedFunds) {
        NSArray *keyvalue = [f componentsSeparatedByString:@":"];
        [pfarr addObject:[NSDictionary dictionaryWithObject:keyvalue[1] forKey:keyvalue[0]]];
    }
    
    [User sharedInstance].purchasedFundsArr = [NSArray arrayWithArray:pfarr];
}

- (NSArray *)getDecendingFundsArr
{
    NSArray *allFunds = [[User sharedInstance] getAllFunds];
    NSArray *purchasedFunds = [User sharedInstance].purchasedFundsArr;
    NSMutableArray *pids = [NSMutableArray array];
    NSMutableArray *pvals = [NSMutableArray array];
    for (NSDictionary *f in purchasedFunds) {
        [pids addObject:[[f allKeys] firstObject]];
        [pvals addObject:[[f allValues] firstObject]];
    }
    
    NSMutableArray *fundsWithMoney = [NSMutableArray array];
    for (int i = 0; i < allFunds.count; i++) {
        Fund *f = [allFunds objectAtIndex:i];
        if ([pids containsObject:f.fid]) {
            f.money = [[pvals objectAtIndex:[pids indexOfObject:f.fid]] floatValue];
        }
        [fundsWithMoney addObject:f];
    }
    
    NSArray *sortedArr = [NSArray array];
    sortedArr = [fundsWithMoney sortedArrayUsingComparator:
            ^NSComparisonResult(id obj1, id obj2){
                NSComparisonResult result = NSOrderedSame;
                Fund *f1 = obj1;
                Fund *f2 = obj2;
                
                if (f1.money > f2.money) {
                    result = NSOrderedAscending;
                } else {
                    result = NSOrderedDescending;
                }
                return result;
            }];
    
    return sortedArr;
}
@end
