//
//  iHMasterViewController.h
//  iFinancial
//
//  Created by Wayde Sun on 2/20/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBaseViewController.h"

@class iHMasterModel;
@interface iHMasterViewController : FBaseViewController {
    iHMasterModel *_dataModel;
}

@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *financialLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextIncomDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *totalIncomeBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *maskIndicator;
@property (weak, nonatomic) IBOutlet UIButton *maskCloseBtn;
@property (weak, nonatomic) IBOutlet UILabel *financialTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *emptyBtn;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIButton *accountListBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;

- (IBAction)onEmptyBtnClicked:(id)sender;
- (IBAction)onMaskCloseBtnClicked:(id)sender;

// Call Back
- (void)updateTodayIncome;
- (void)showIndicator;
- (void)hideIndicator;
- (void)refreshFunds;
- (void)showRefreshAlert;
-(void)pushToAccount;
- (void)gotoLoginViewController;
@end
