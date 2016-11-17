//
//  iHStatusBarWindow.m
//  iHakula
//
//  Created by Wayde Sun on 7/3/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#define IH_STATUS_BAR_GRAY      @"grayStatusBar.png"

#import "iHStatusBarWindow.h"
#import "iHStatusBarActivitiesView.h"
//#import "UCAppDelegate.h"

@interface iHStatusBarWindow ()
- (NSString *)getStatusBarImage:(iHStatusBarColor)barColor;
@end

@implementation iHStatusBarWindow

- (id)initWithColor:(iHStatusBarColor)barColor {
    CGFloat deviceWidth = IH_IS_IPHONE ? IPHONE_SCREEN_WIDTH : IPAD_SCREEN_WIDTH;
    self = [super initWithFrame:CGRectMake(0, 0, deviceWidth, 20)];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 0.1f;
        self.frame = [[UIApplication sharedApplication] statusBarFrame];
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0;
        
        _activitiesView = [iHStatusBarActivitiesView viewFromNib];
        if (barColor == iHStatusBarColorBlack) {
            _activitiesView.messageLabel.backgroundColor = [UIColor blackColor];
        } else {
            NSString *barImage = [self getStatusBarImage:barColor];
            _activitiesView.colorImageView.image = ImageNamed(barImage);
        }
        
        _activitiesView.left = self.width - _activitiesView.width;
        
        [self addSubview:_activitiesView];
    }
    return self;
}


#pragma mark - Public Methods
- (void)showMessage:(NSString *)msg {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1.0;
        _activitiesView.messageLabel.text = msg;
        [self makeKeyAndVisible];
    }];
    
    // restore default window
//    [[UCAppDelegate getSharedAppDelegate].window makeKeyWindow];
}

- (void)hide {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        _activitiesView.messageLabel.text = @"";
    }];
}

#pragma mark - Private Methods
- (NSString *)getStatusBarImage:(iHStatusBarColor)barColor {
    NSString *name = @"";
    switch (barColor) {
        case iHStatusBarColorGray:
            name = IH_STATUS_BAR_GRAY;
            break;
            
        default:
            break;
    }
    
    return name;
}

@end
