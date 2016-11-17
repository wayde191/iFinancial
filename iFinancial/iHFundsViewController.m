//
//  iHFundsViewController.m
//  iFinancial
//
//  Created by Wayde Sun on 3/13/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "iHFundsViewController.h"
#import "iHValidationKit.h"
#import "iHFundsModel.h"
#import "Fund.h"
#import "LPLoginViewController.h"

@interface iHFundsViewController (){
    NSIndexPath *_editingIndexPath;
    UITextField *_editingTextField;
    float _oldValue;
    NSMutableDictionary *_modifiedFunds;
}

@end

@implementation iHFundsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _dataModel = [[iHFundsModel alloc] init];
    _dataModel.delegate = self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    _modifiedFunds = [NSMutableDictionary dictionary];
    
    _saveBtn.enabled = NO;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods
- (void)gotoLoginViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LPLoginViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveModifiesSuccess
{
    [User sharedInstance].observedFundsNumberChanged = YES;
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = @"保存成功！";
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
        }];
    }];
    
    [self.tableView reloadData];
    [_modifiedFunds removeAllObjects];
    _saveBtn.enabled = NO;
        
}

- (void)saveModifiesFailued
{
    [UIView animateWithDuration:0.3 animations:^(){
        self.navigationItem.prompt = @"保存失败，请重试！";
        _saveBtn.enabled = YES;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.3 animations:^(){
            self.navigationItem.prompt = nil;
        }];
    }];
    [self.tableView reloadData];
}

- (IBAction)onSaveBtnClicked:(id)sender
{
    [_editingTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^(){
        self.navigationItem.prompt = @"正在保存数据...";
        _saveBtn.enabled = NO;
    }];
    [_dataModel doCallUpdatePurchasedUnitService:_modifiedFunds];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _editingTextField = textField;
    _oldValue = [textField.text floatValue];
    UITableViewCell *selCell = (UITableViewCell *)[[[textField superview] superview] superview];
    _editingIndexPath = [self.tableView indexPathForCell: selCell];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (!([iHValidationKit isValueEmpty:newValue] || [iHValidationKit doCheckFloatNumber:newValue])) {
        return NO;
    }
    
    // 0 is equal to [@"" floatValue]
    if (0 == _oldValue && [iHValidationKit isValueEmpty:newValue]) {
        [_modifiedFunds removeObjectForKey:_editingIndexPath];
    }
    
    if (_oldValue != [newValue floatValue]) {
        _saveBtn.enabled = YES;
        if (![iHValidationKit isValueEmpty:newValue] || [newValue isEqualToString:@""]) {
            if ([newValue isEqualToString:@""]) {
                newValue = @"0";
            }
            [_modifiedFunds setObject:newValue forKey:_editingIndexPath];
        }
    } else if(_modifiedFunds.count > 0) {
        _saveBtn.enabled = YES;
    } else {
        _saveBtn.enabled = NO;
    }
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataModel.allFundsDescendingArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Fund *f = [_dataModel.allFundsDescendingArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", f.code, f.name];
    UITextField *tf = (UITextField *)[cell viewWithTag:10];
    
    NSString *modifiedPurchasedUnit = [_modifiedFunds objectForKey:indexPath];
    if (modifiedPurchasedUnit) {
        tf.text = [NSString stringWithFormat:@"%@", modifiedPurchasedUnit];
    } else {
        tf.text = [NSString stringWithFormat:@"%.02f", f.money];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleNone) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
@end
