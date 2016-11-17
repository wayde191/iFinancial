//
//  LPLoginViewController.h
//  LocatePeople
//
//  Created by Wayde Sun on 7/9/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#define LP_APP_LAUNCH_FIRSTTIME     @"LPAppLaunchFirsttime"

#define LP_USERNAME                 @"LocatePeopleUsername"
#define LP_PASSWORD                 @"LocatePeoplePassword"
#define LP_REMEMBER                 @"LocatePeopleRemember"
#define LP_AUTO_LOGIN               @"LocatePeopleAutoLogin"

#import "FBaseViewController.h"

@class LPLoginModel;
@interface LPLoginViewController : FBaseViewController <UITextFieldDelegate> {
    BOOL _rememberCheckboxSelected;
    BOOL _autoLoginCheckboxSelected;
    
    LPLoginModel *_dm;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *automaticallyLoginBtn;

- (IBAction)onCancelBtnClicked:(id)sender;
- (IBAction)onLoginBtnClicked:(id)sender;
- (IBAction)onRememberPasswordBtnClicked:(id)sender;
- (IBAction)onAutoLoginBtnClicked:(id)sender;

- (void)loginSuccess;
@end
