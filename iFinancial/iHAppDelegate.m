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

extern BOOL g_need_refresh;

@interface iHAppDelegate (){
}
- (void)setupAds;
@end

@implementation iHAppDelegate

#pragma mark - UM
- (void)umengTrack {
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
}

- (void)showAds {
}

- (void)hideAds {
}

@end
