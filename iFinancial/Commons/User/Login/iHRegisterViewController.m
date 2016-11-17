//
//  iHRegisterViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 3/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHRegisterViewController.h"
#import "LPLoginModel.h"
#import "iHValidationKit.h"

@interface iHRegisterViewController (){
    LPLoginModel *_dm;
}

@end

@implementation iHRegisterViewController

- (void)awakeFromNib
{
    _dm = [[LPLoginModel alloc] init];
    _dm.delegate = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRegisterBtnClicked:(id)sender {
    NSString *username = _nickNameTextField.text;
    NSString *useremail = _emailTextField.text;
    NSString *password = _passwordTextField.text;
    NSString *cfmPwd = _cfmPwdTextField.text;
    
    if ([iHValidationKit isValueEmpty:username]) {
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = @"用户昵称不能为空！";
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = nil;
                [_nickNameTextField becomeFirstResponder];
            }];
        }];
        return;
    } else if ([iHValidationKit isValueEmpty:useremail]) {
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = @"邮箱不能为空！";
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = nil;
                [_emailTextField becomeFirstResponder];
            }];
        }];
        return;
    }else if (![iHValidationKit doCheckEmailFormat:useremail]) {
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = @"邮箱格式不正确！";
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = nil;
                _emailTextField.text = @"";
                [_emailTextField becomeFirstResponder];
            }];
        }];
        return;
    } else if ([iHValidationKit isValueEmpty:password]) {
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = @"密码不能为空";
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = nil;
                [_passwordTextField becomeFirstResponder];
            }];
        }];
        return;
    } else if ([iHValidationKit isValueEmpty:cfmPwd]) {
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = @"请再次输入密码";
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = nil;
                [_cfmPwdTextField becomeFirstResponder];
            }];
        }];
        return;
    } else if (![cfmPwd isEqualToString:password]) {
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = @"请确保输入相同密码";
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = nil;
                [_cfmPwdTextField becomeFirstResponder];
            }];
        }];
        return;
    }
    
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:
                           username, @"nickname",
                           useremail, @"ihakulaID",
                           password, @"password",
                           cfmPwd, @"confirmPwd",
                           nil];
    [_dm doCallRegisterService:paras];    
}

- (void)registerSuccess
{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"恭喜，注册成功，请登录！";
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _cfmPwdTextField) {
        [self onRegisterBtnClicked:nil];
    }
    return YES;
}
@end
