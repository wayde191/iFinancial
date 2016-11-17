//
//  User.h
//  iFinancial
//
//  Created by Wayde Sun on 3/5/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseModel.h"

@class Fund;
@interface User : FBaseModel

@property (strong, nonatomic) NSArray *cashFundsArr;
@property (strong, nonatomic, setter=setPurchasedFunds:) NSArray *purchasedFundsArr;
@property (strong, nonatomic, setter=setObservedFunds:) NSDictionary *observedFundsDic;
@property (assign, nonatomic) BOOL observedFundsNumberChanged;
@property (strong, nonatomic) NSDictionary *allAccountTypes;

// Class Methods
+ (User *)sharedInstance;

// Public Methods
- (BOOL)isUserRefreshedDataToday;
- (BOOL)isUserLoggedIn;

- (void)doUploadToken;
- (void)refreshAllFundsOnceADay:(void (^)(void))whenDone;
- (void)doUpdateTokenSessionOnceADay;
- (void)setPurchasedFunds:(NSArray *)funds;
- (void)setObservedFunds:(NSDictionary *)funds;

- (NSString *)getUserId;
- (NSString *)getUserName;
- (NSString *)getUserEmail;
- (Fund *)getFundById:(NSString *)fundId;
- (NSArray *)getAllFunds;
- (float)getMyTotalAssests;

- (void)updateRefreshedDay;
- (void)syncCachedData;
- (void)loginSuccess:(NSDictionary *)uinfo;
- (void)restoreUser;

@end
