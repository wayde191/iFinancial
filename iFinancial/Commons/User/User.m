//
//  User.m
//  iFinancial
//
//  Created by Wayde Sun on 3/5/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "User.h"
#import "Fund.h"
#import "iHValidationKit.h"

#define IF_CACHED_DATA          @"IFinancialCachedData"
#define IF_REFRESHED_DAY        @"IFinancialRefreshedDay"
#define IF_USER_ID              @"IFinancialUserId"
#define IF_USER_EMAIL           @"IFinancialUserEmail"
#define IF_USER_NAME            @"IFinancialUserName"
#define IF_USER_FUNDS           @"IFinancialUserFunds"
#define IF_OBSERVED_FUNDS       @"IFinancialObservedFunds"
#define IF_ALL_FUNDS            @"IFinancialAllFunds"

#define UPDATE_SESSION_SERVICE      @"UpdateSessionService"
#define GET_ALL_FUNDS_SERVICE       @"GetAllFundsService"
#define UPLOAD_TOKEN_SERVICE        @"UploadTokenService"

//Singleton model
static User *singletonInstance = nil;

@interface User (){
    NSMutableDictionary *_cachedData;
    
    NSDateComponents *_refreshedDayComponents;
    NSString *_userId;
    NSString *_userEmail;
    NSString *_userName;
    NSArray *_allFunds;
    
    void(^ _getAllFundsWhenDone)(void) ;
}

- (void)restoreCachedData;
- (void)initCachedData;
- (void)setupAllFunds:(NSArray *)funds;
@end

@implementation User

- (id)init
{
    self = [super init];
    if (self) {
        if ([USER_DEFAULT objectForKey:IF_CACHED_DATA]) {
            [self initCachedData];
            
        } else {
            [self restoreCachedData];
        }
        
        self.allAccountTypes = nil;
    }
    return self;
}

#pragma mark - Public Methods
- (void)doUploadToken {
    theRequest.requestMethod = iHRequestMethodPost;
    NSString *token = [USER_DEFAULT objectForKey:IH_DEVICE_TOKEN];
    if (token) {
        NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"iFinanical", @"app",
                               @"1.0.0", @"version",
                               CURRENT_LANGUAGE, @"language",
                               [UIDevice currentDevice].systemName, @"platform",
                               [UIDevice currentDevice].systemVersion, @"os",
                               [UIDevice currentDevice].localizedModel, @"device",
                               token, @"token",
                               _userId, @"userId",
                               nil];
        
        [self doCallService:UPLOAD_TOKEN_SERVICE withParameters:paras andServiceUrl:SERVICE_UPLOAD_TOKEN forDelegate:nil];
    }
}

- (void)setPurchasedFunds:(NSArray *)funds
{
    _purchasedFundsArr = funds;
    [_cachedData setObject:_purchasedFundsArr forKey:IF_USER_FUNDS];
}

- (void)setObservedFunds:(NSDictionary *)funds
{
    _observedFundsDic = funds;
    [_cachedData setObject:_observedFundsDic forKey:IF_OBSERVED_FUNDS];
}

- (Fund *)getFundById:(NSString *)fundId
{
    Fund *res = Nil;
    for (int i = 0; i < _allFunds.count; i++) {
        Fund *f = [_allFunds objectAtIndex:i];
        if ([f.fid isEqualToString:fundId]) {
            res = f;
            break;
        }
    }
    return res;
}

- (float)getMyTotalAssests
{
    float assests = 00.00;
    for (int i = 0; i < self.purchasedFundsArr.count; i++) {
        NSDictionary *pfund = [self.purchasedFundsArr objectAtIndex:i];
        float spent = [[[pfund allValues] firstObject] floatValue];
        assests += spent;
    }
    
    return assests;
}

- (void)loginSuccess:(NSDictionary *)uinfo
{
    _userEmail = [uinfo objectForKey:@"email"];
    _userName = [uinfo objectForKey:@"name"];
    _userId = [uinfo objectForKey:@"id"];
    
    [_cachedData setObject:_userEmail forKey:IF_USER_EMAIL];
    [_cachedData setObject:_userName forKey:IF_USER_NAME];
    [_cachedData setObject:_userId forKey:IF_USER_ID];
    
    [self syncCachedData];
}

- (void)restoreUser
{
    _userId = Nil;
    _userEmail = Nil;
    _userName = Nil;
    _refreshedDayComponents = Nil;
    
    [self restoreCachedData];
    [self syncCachedData];
}

- (NSString *)getUserId
{
    return _userId;
}

- (NSString *)getUserName
{
    return _userName;
}

- (NSString *)getUserEmail
{
    return _userEmail;
}

- (BOOL)isUserLoggedIn
{
    return [iHValidationKit isValueEmpty:_userId] ? NO : YES;
}

- (void)refreshAllFundsOnceADay:(void (^)(void))whenDone
{
    _getAllFundsWhenDone = whenDone;
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_ALL_FUNDS_SERVICE  withParameters:nil andServiceUrl:SERVICE_GET_ALL_FUNDS forDelegate:self];
}

- (BOOL)isUserRefreshedDataToday
{
    if(!_refreshedDayComponents) {
        return NO;
    }
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    iHDINFO(@"\n --- %@ \n ----%@", today, _refreshedDayComponents);
    if([today day] == [_refreshedDayComponents day] &&
       [today month] == [_refreshedDayComponents month] &&
       [today year] == [_refreshedDayComponents year] ){
        return YES;
    }
    
    return NO;
}

- (void)updateRefreshedDay
{
    _refreshedDayComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    [_cachedData setObject:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:IF_REFRESHED_DAY];
}

- (void)doUpdateTokenSessionOnceADay
{
    if(!([self isUserLoggedIn] && ![self isUserRefreshedDataToday])){
        return;
    }
    
    theRequest.requestMethod = iHRequestMethodPost;
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"session",
                          @"", @"userid",
                          nil];
    [self doCallService:UPDATE_SESSION_SERVICE  withParameters:para andServiceUrl:SERVICE_UPDATE_SESSION forDelegate:self];
}

- (void)syncCachedData
{
    iHDINFO(@"sync ---- %@", _cachedData);
    [USER_DEFAULT setObject:_cachedData forKey:IF_CACHED_DATA];
    [USER_DEFAULT synchronize];
}

#pragma mark - Class Methods
+ (User *)sharedInstance
{
    //The @synchronized()directive locks a section of code for use by a single thread
    @synchronized(self){
        if (!singletonInstance) {
            singletonInstance = [[User alloc] init];
        }
        
        return singletonInstance;
    }
    
    return nil;
}

#pragma mark - Private Methods
- (void)initCachedData
{
    _cachedData = [USER_DEFAULT objectForKey:IF_CACHED_DATA];
    
    _refreshedDayComponents = nil;
    NSString *day = [_cachedData objectForKey:IF_REFRESHED_DAY];
    if (![iHValidationKit isValueEmpty:day]) {
        _refreshedDayComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate dateWithString:[_cachedData objectForKey:IF_REFRESHED_DAY] formate:@"yyyy-MM-dd"]];
    }
    
    _userId = [_cachedData objectForKey:IF_USER_ID];
    _userEmail = [_cachedData objectForKey:IF_USER_EMAIL];
    _userName = [_cachedData objectForKey:IF_USER_NAME];
    _purchasedFundsArr = [_cachedData objectForKey:IF_USER_FUNDS];
    if ([iHValidationKit isValueEmpty:_purchasedFundsArr]) {
        _purchasedFundsArr = [NSArray array];
    }
    _observedFundsDic = [_cachedData objectForKey:IF_OBSERVED_FUNDS];
    
    _allFunds = [NSArray array];
    NSArray *funds = [_cachedData objectForKey:IF_ALL_FUNDS];
    if (![iHValidationKit isValueEmpty:funds]) {
        [self setupAllFunds:[_cachedData objectForKey:IF_ALL_FUNDS]];
    }
}

- (void)restoreCachedData
{
    _cachedData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   @"", IF_REFRESHED_DAY,
                   @"", IF_USER_ID,
                   @"", IF_USER_NAME,
                   @"", IF_USER_EMAIL,
                   @"", IF_USER_FUNDS,
                   @"", IF_OBSERVED_FUNDS,
                   @"", IF_ALL_FUNDS,
                   nil];
    _userId = nil;
    _purchasedFundsArr = [NSArray array];
}

- (void)setupAllFunds:(NSArray *)funds
{
    NSMutableArray *fundsArr = [NSMutableArray array];
    for (int i = 0; i < funds.count; i++) {
        NSDictionary *fund = [funds objectAtIndex:i];
        Fund *f = [[Fund alloc] initWithDic:fund];
        [fundsArr addObject:f];
    }
    if (fundsArr.count) {
        _allFunds = [NSArray arrayWithArray:fundsArr];
    }
}

- (NSArray *)getAllFunds
{
    return _allFunds;
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:UPDATE_SESSION_SERVICE]) {
        NSString *refreshResult = [response.userInfoDic objectForKey:@"refreshResult"];
        if([refreshResult isEqualToString:@"ok"]) {
            
        } else {
            [self restoreUser];
        }
    } else if ([response.serviceName isEqualToString:GET_ALL_FUNDS_SERVICE]) {
        NSArray *funds = nil;
        funds = [response.userInfoDic objectForKey:@"funds"];
        if (funds) {
            [self setupAllFunds:funds];
            [_cachedData setObject:funds forKey:IF_ALL_FUNDS];
        }
        _getAllFundsWhenDone();
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response
{
    [super serviceCallFailed:response];
    if ([response.serviceName isEqualToString:GET_ALL_FUNDS_SERVICE]) {
        _getAllFundsWhenDone();
    }
}


@end
