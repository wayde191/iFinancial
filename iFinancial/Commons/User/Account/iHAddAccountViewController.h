//
//  iHAddAccountViewController.h
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseViewController.h"

@class iHAddAccountModel;
@interface iHAddAccountViewController : FBaseViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate> {
    iHAddAccountModel *_dataModel;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)onSaveBtnClicked:(id)sender;

- (void)addRecordSuccess;
- (void)fieldsUpdated;
- (void)showMessage:(NSString *)msg;
- (void)gotoLoginViewController;
@end
