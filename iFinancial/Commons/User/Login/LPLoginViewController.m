//
//  LPLoginViewController.m
//  LocatePeople
//
//  Created by Wayde Sun on 7/9/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "LPLoginViewController.h"
#import "iHValidationKit.h"
#import "LPLoginModel.h"

#import "MobClick.h"

@interface LPLoginViewController ()
- (void)initFromUserDefault;
- (void)gobackToLastPage;
@end

@implementation LPLoginViewController

- (void)awakeFromNib
{
    _rememberCheckboxSelected = YES;
    _autoLoginCheckboxSelected = NO;
    
    _dm = [[LPLoginModel alloc] init];
    _dm.delegate = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _rememberCheckboxSelected = YES;
        _autoLoginCheckboxSelected = NO;
        
        _dm = [[LPLoginModel alloc] init];
        _dm.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initFromUserDefault];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setRememberPasswordBtn:nil];
    [self setAutomaticallyLoginBtn:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginViewPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [USER_DEFAULT synchronize];
    [MobClick endLogPageView:@"LoginViewPage"];
}

- (void)loginSuccess {
    [self showMessage:@"登录成功！"];
    [self performSelector:@selector(gobackToLastPage) withObject:nil afterDelay:1.3];
}

- (IBAction)onCancelBtnClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认要退出应用吗？" selectedBlock:^(NSInteger index){
        if (1 == index) {
            exit(0);
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    [alert show];
}

- (IBAction)onLoginBtnClicked:(id)sender {
    NSString *username = _nameTextField.text;
    NSString *password = _passwordTextField.text;
    
    if ([iHValidationKit isValueEmpty:username]) {
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = @"用户名称不能为空！";
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = nil;
                [_nameTextField becomeFirstResponder];
            }];
        }];
        return;
    } else if (![iHValidationKit doCheckEmailFormat:username]) {
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = @"请输入正确邮箱";
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = nil;
                [_nameTextField becomeFirstResponder];
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
    }
    
    if (_rememberCheckboxSelected) {
        [USER_DEFAULT setValue:username forKey:LP_USERNAME];
        [USER_DEFAULT setValue:password forKey:LP_PASSWORD];
    } else {
        [USER_DEFAULT removeObjectForKey:LP_USERNAME];
        [USER_DEFAULT removeObjectForKey:LP_PASSWORD];
    }
    
    NSString *deviceToken = [USER_DEFAULT valueForKey:IH_DEVICE_TOKEN];
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:
                           username, @"ihakulaID",
                           password, @"password",
                           deviceToken, @"deviceToken",
                           nil];
    
    [self showStaticMessage:@"正在登录..."];
    [_dm doCallLoginService:paras];
    
    [MobClick event:@"user_do_login" label:@"user_do_login"];
}

- (IBAction)onRememberPasswordBtnClicked:(id)sender {
    if (sender) {
        _rememberCheckboxSelected = !_rememberCheckboxSelected;
    }
    if (_rememberCheckboxSelected) {
        _rememberPasswordBtn.selected = YES;
        [USER_DEFAULT setValue:@"1" forKey:LP_REMEMBER];
    } else {
        _rememberPasswordBtn.selected = NO;
        [USER_DEFAULT setValue:@"0" forKey:LP_REMEMBER];
    }
}

- (IBAction)onAutoLoginBtnClicked:(id)sender {
    if (sender) {
        _autoLoginCheckboxSelected = !_autoLoginCheckboxSelected;
    }
    if (_autoLoginCheckboxSelected) {
        _automaticallyLoginBtn.selected = YES;
        [USER_DEFAULT setValue:@"1" forKey:LP_AUTO_LOGIN];
    } else {
        _automaticallyLoginBtn.selected = NO;
        [USER_DEFAULT setValue:@"0" forKey:LP_AUTO_LOGIN];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passwordTextField) {
        [self onLoginBtnClicked:nil];
    }
    return YES;
}

#pragma mark - Private Methods
- (void)initFromUserDefault {
    NSString *remember = [USER_DEFAULT valueForKey:LP_REMEMBER];
    NSString *autoLogin = [USER_DEFAULT valueForKey:LP_AUTO_LOGIN];
    NSString *username = [USER_DEFAULT valueForKey:LP_USERNAME];
    NSString *password = [USER_DEFAULT valueForKey:LP_PASSWORD];
    
    if (remember) {
        _rememberCheckboxSelected = [remember isEqualToString:@"1"] ? YES : NO;
    }
    if (autoLogin) {
        _autoLoginCheckboxSelected = [autoLogin isEqualToString:@"1"] ? YES : NO;
    }
    if (_rememberCheckboxSelected && username) {
        _nameTextField.text = username;
    }
    if (_rememberCheckboxSelected && password) {
        _passwordTextField.text = password;
    }
    
    [self onRememberPasswordBtnClicked:nil];
    [self onAutoLoginBtnClicked:nil];
    
    if (_autoLoginCheckboxSelected && username && password) {
        [self performSelector:@selector(onLoginBtnClicked:) withObject:nil afterDelay:1.0];
    }
}

- (void)gobackToLastPage {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
