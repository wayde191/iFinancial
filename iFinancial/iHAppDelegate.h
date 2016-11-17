//
//  iHAppDelegate.h
//  iFinancial
//
//  Created by Wayde Sun on 2/20/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

BOOL g_need_refresh;

@interface iHAppDelegate : UIResponder <UIApplicationDelegate , GADBannerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (iHAppDelegate *)getSharedAppDelegate;

- (void)showAds;
- (void)hideAds;

@end
