//
//  iHSureGoldViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 4/2/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHSureGoldViewController.h"
#import "iHSureGoldModel.h"
#import "iHValidationKit.h"
#import "MobClick.h"
#import "LPLoginViewController.h"

@interface iHSureGoldViewController (){
    float _oldValue;
}

- (void)showServiceMessage;
- (void)hideServiceMessage;
@end

@implementation iHSureGoldViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _dataModel = [[iHSureGoldModel alloc] init];
    _dataModel.delegate = self;
    self.amountTextField = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ConfirmDepositViewPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ConfirmDepositViewPage"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _saveBtn.enabled = NO;
    
    [_dataModel doCallGetConfirmationDepositServiceById:self.fundId];
    [self showServiceMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoLoginViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LPLoginViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshTableView
{
    [self hideServiceMessage];
    [self.tableView reloadData];
}

- (void)serviceCallFailed
{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"请求失败，请稍后再试";
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
            [self.amountTextField resignFirstResponder];
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
    }
    
    return _dataModel.comingConfirmArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (0 == indexPath.section) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmCell" forIndexPath:indexPath];
        UITextField *tf = (UITextField *)[cell viewWithTag:10];
        tf.text = [NSString stringWithFormat:@"%.02f", [_dataModel.confirmDeposit floatValue]];
        _oldValue = [tf.text floatValue];
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *obj = [_dataModel.comingConfirmArr objectAtIndex:indexPath.row];
        NSString *amount = [obj objectForKey:@"amount"];
        cell.textLabel.text = [NSString stringWithFormat:@"%.02f", [amount floatValue]];
        cell.detailTextLabel.text = [[obj objectForKey:@"apply_date"] substringToIndex:10];
        UILabel *confirmDateLabel = (UILabel *)[cell viewWithTag:11];
        confirmDateLabel.text = [obj objectForKey:@"approve_date"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return 33;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return self.headerView;
    }
    return nil;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (IBAction)onSaveBtnClicked:(id)sender {
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认金是指当前已确认并实际收益的资金；修改已确认总金额意味着调整当前的确认金，并清除掉当前所有待确认资金，确认修改吗？" selectedBlock:^(NSInteger index) {
        if (1 == index) {
            [UIView animateWithDuration:0.8 animations:^(){
                self.navigationItem.prompt = @"正在更新数据...";
            } completion:^(BOOL finished){
            }];
            NSString *modifiedAmount = self.amountTextField.text;
            [_dataModel doCallUpdateAmount:modifiedAmount serviceById:self.fundId];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    [a show];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.amountTextField) {
        self.amountTextField = textField;
    }
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (!([iHValidationKit isValueEmpty:newValue] || [iHValidationKit doCheckFloatNumber:newValue])) {
        return NO;
    }
    
    if (_oldValue != [newValue floatValue]) {
        _saveBtn.enabled = YES;
        if (![iHValidationKit isValueEmpty:newValue] || [newValue isEqualToString:@""]) {
            if ([newValue isEqualToString:@""]) {
                newValue = @"0";
                _saveBtn.enabled = NO;
            }
        }
    } else {
        _saveBtn.enabled = NO;
    }
    
    return YES;
}

#pragma mark - Private Methods
- (void)showServiceMessage
{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"正在请求数据...";
    } completion:^(BOOL finished){
    }];
}

- (void)hideServiceMessage
{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"请求成功！";
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
            [self.amountTextField resignFirstResponder];
        }];
    }];
}

@end
