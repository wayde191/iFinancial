//
//  iHRegisterViewController.h
//  iFinancial
//
//  Created by Wayde Sun on 3/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseViewController.h"

@interface iHRegisterViewController : FBaseViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *cfmPwdTextField;

- (IBAction)onRegisterBtnClicked:(id)sender;
- (void)registerSuccess;
@end
