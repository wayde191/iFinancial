//
//  iHStatusBarWindow.h
//  iHakula
//
//  Created by Wayde Sun on 7/3/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    iHStatusBarColorGray = 3001,
    iHStatusBarColorBlack,
} iHStatusBarColor;

@class iHStatusBarActivitiesView;
@interface iHStatusBarWindow : UIWindow {
    iHStatusBarActivitiesView *_activitiesView;
}

- (id)initWithColor:(iHStatusBarColor)barColor;

- (void)showMessage:(NSString *)msg;
- (void)hide;

@end
