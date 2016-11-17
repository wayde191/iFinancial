//
//  iHFundsViewController.h
//  iFinancial
//
//  Created by Wayde Sun on 3/13/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iHFundsModel;
@interface iHFundsViewController : UITableViewController <UITextFieldDelegate> {
    iHFundsModel *_dataModel;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;

- (void)saveModifiesSuccess;
- (void)saveModifiesFailued;
- (IBAction)onSaveBtnClicked:(id)sender;

- (void)gotoLoginViewController;
@end
