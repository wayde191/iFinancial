//
//  iHAppDelegate.m
//  iFinancial
//
//  Created by Wayde Sun on 2/20/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHAppDelegate.h"
#import "iHMasterViewController.h"
#import "iHEngine.h"
#import "MobClick.h"

extern BOOL g_need_refresh;

@interface iHAppDelegate (){
    GADBannerView *bannerView_;
}
- (void)setupAds;
@end

@implementation iHAppDelegate

#pragma mark - UM
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    iHDINFO(@"online config has fininshed and note = %@", note.userInfo);
}

#pragma mark - Class Methods
+ (iHAppDelegate *)getSharedAppDelegate
{
    return (iHAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    iHDINFO(@"---===---- %@", userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
	NSString *str = [devToken description];
	str = [str substringWithRange:NSMakeRange(1, 71)];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    [USER_DEFAULT setObject:str forKey:IH_DEVICE_TOKEN];
	[USER_DEFAULT synchronize];
    iHDINFO(@"token ==== %@", str);
    [[User sharedInstance] doUploadToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    iHDINFO(@"%@", error);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Engine Start
    if (![iHEngine start]) {
        return NO;
    }
    
    // Register push
    if([[NSUserDefaults standardUserDefaults] stringForKey:IH_DEVICE_TOKEN] == nil)	{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    } else {
        [[User sharedInstance] doUploadToken];
    }
    
    // umeng
    [self umengTrack];
    
    if (IH_FREE) {
        [self setupAds];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[User sharedInstance] syncCachedData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[User sharedInstance] syncCachedData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    g_need_refresh = YES;
    iHMasterViewController *mvc = nil;
    if ([[(UINavigationController *)self.window.rootViewController viewControllers] count]) {
        mvc = [[(UINavigationController *)self.window.rootViewController viewControllers] firstObject];
        [mvc refreshFunds];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[User sharedInstance] syncCachedData];
}

- (void)setupAds {
    CGFloat y = self.window.height - 50;
    
    CGPoint origin = CGPointMake(10.0, y);
    bannerView_ = [[GADBannerView alloc]
                   initWithAdSize:kGADAdSizeBanner // 300 * 50
                   origin:origin];
    
    bannerView_.adUnitID = @"a15334ee543bda2";
    bannerView_.delegate = self;
    
    bannerView_.rootViewController = self.window.rootViewController;
    bannerView_.left = -1000;
    
    GADRequest *request = [GADRequest request];
    //    request.testing = YES;
    request.additionalParameters =  [NSMutableDictionary
                                     dictionaryWithObjectsAndKeys:
                                     @"F0F0F0", @"color_bg",
                                     @"696969", @"color_bg_top",
                                     @"000000", @"color_border",
                                     @"FF0000", @"color_link",
                                     @"232323", @"color_text",
                                     @"00FF00", @"color_url",
                                     nil];
    [bannerView_ loadRequest:request];
    
    [self.window addSubview:bannerView_];
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView animateWithDuration:0.3 animations:^(){
        bannerView_.left = 0;
    }];
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    bannerView_.left = -1000;
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {}
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {}
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {}

- (void)showAds {
    if (!IH_IS_IPHONE) {
        bannerView_.width=768;
    }
    [self.window bringSubviewToFront:bannerView_];
}

- (void)hideAds {
    [self.window sendSubviewToBack:bannerView_];
}

@end
