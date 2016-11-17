//
//  iHAddAccountViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHAddAccountViewController.h"
#import "iHAddAccountModel.h"
#import "iHValidationKit.h"
#import "LPLoginViewController.h"

@interface iHAddAccountViewController ()

@end

@implementation iHAddAccountViewController

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
    _dataModel = [[iHAddAccountModel alloc] init];
    _dataModel.delegate = self;
    
    if (![_dataModel isRefreshedToday]) {
        _scrollView.hidden = YES;
        _indicator.hidden = NO;
        [_indicator startAnimating];
        
        [_dataModel doCallServiceGetFields];
    } else {
        [_indicator stopAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSaveBtnClicked:(id)sender {
    if ([[User sharedInstance] isUserLoggedIn]) {
        NSString *money = self.moneyTextField.text;
        NSString *description = self.descriptionTextView.text;
        
        if ([iHValidationKit isValueEmpty:money]) {
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = @"金额不能为空！";
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.8 animations:^(){
                    self.navigationItem.prompt = nil;
                    [self.moneyTextField becomeFirstResponder];
                }];
            }];
            return;
        } else if (![iHValidationKit doCheckFloatNumber:money]) {
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = @"请输入正确的金额";
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.8 animations:^(){
                    self.navigationItem.prompt = nil;
                    [self.moneyTextField becomeFirstResponder];
                }];
            }];
            return;
        } else if ([iHValidationKit isValueEmpty:description]) {
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = @"描述不能为空！";
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.8 animations:^(){
                    self.navigationItem.prompt = nil;
                    [self.descriptionTextView becomeFirstResponder];
                }];
            }];
            return;
        }
        
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        [paras setObject:money forKey:@"money"];
        [paras setObject:description forKey:@"description"];
        [paras setObject:[_dataModel getSelectedCategoryIdByComponentRow:[_pickerView selectedRowInComponent:0]] forKey:@"fieldId"];
        [paras setObject:[_dataModel getSelectedDetailIdForComponent:[_pickerView selectedRowInComponent:0] forDetailRow:[_pickerView selectedRowInComponent:1]] forKey:@"detailId"];
        [paras setObject:[[User sharedInstance] getUserId] forKey:@"userId"];
        [self showStaticMessage:@"正在保存..."];
        [_dataModel doCallServiceAddRecord:paras];
        
    } else {
        UIAlertView *aalert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有登录，请先登录" selectedBlock:^(NSInteger index) {
            if (1 == index) {
                [self gotoLoginViewController];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        [aalert show];
    }
}

- (void)fieldsUpdated {
    [_indicator stopAnimating];
    _scrollView.hidden = NO;
    [_pickerView reloadAllComponents];
}

- (void)addRecordSuccess {
    self.descriptionTextView.text = @"";
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"添加成功！";
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
        }];
    }];
}

- (void)showMessage:(NSString *)msg {
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = msg;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
        }];
    }];
}

- (void)gotoLoginViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LPLoginViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (!_dataModel.allFieldTypes) {
        return 0;
    }
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (0 == component) {
        return [[_dataModel.allFieldTypes allKeys] count];
    } else {
        NSInteger selectedComponent = [pickerView selectedRowInComponent:0];
        return [_dataModel getDetailFieldsRowNumberInSelectedFirstComponent:selectedComponent];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        return [_dataModel getCategoryTitleByRow:row];
    } else {
        NSInteger selectedComponent = [pickerView selectedRowInComponent:0];
        return [_dataModel getDetailTitleForComponent:selectedComponent forRow:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0 == component) {
        [pickerView reloadComponent:1];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.scrollView setContentOffset:CGPointMake(0, self.pickerView.top + self.pickerView.height) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    [textField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.returnKeyType = UIReturnKeyDone;
    return YES;
}

-(BOOL) textView :(UITextView *) textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *) text {
    
    if ([text isEqualToString:@"\n"]) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [textView resignFirstResponder];
    }
    return YES;
}

@end
