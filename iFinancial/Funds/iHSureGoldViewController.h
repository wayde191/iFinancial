//
//  iHSureGoldViewController.h
//  iFinancial
//
//  Created by Wayde Sun on 4/2/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iHSureGoldModel;
@interface iHSureGoldViewController : UITableViewController <UITextFieldDelegate> {
    iHSureGoldModel *_dataModel;
}

@property (nonatomic, strong) NSString *fundId;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

- (IBAction)onSaveBtnClicked:(id)sender;

- (void)refreshTableView;
- (void)serviceCallFailed;

- (void)gotoLoginViewController;
@end
