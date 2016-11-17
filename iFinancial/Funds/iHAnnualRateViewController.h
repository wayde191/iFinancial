//
//  iHAnnualRateViewController.h
//  iFinancial
//
//  Created by Wayde Sun on 4/4/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "FBaseViewController.h"

@class iHAnnualRateModel;
@interface iHAnnualRateViewController : FBaseViewController {
    iHAnnualRateModel *_dataModel;
}

@property (nonatomic, strong) NSString *fundId;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *watchBtn;
@property (weak, nonatomic) IBOutlet UILabel *fundNameLabel;

- (IBAction)onWatchBtnClicked:(UIBarButtonItem *)sender;
- (IBAction)onSegmentClicked:(UISegmentedControl *)sender;

- (void)drawChat;
- (void)serviceCallFailed;

@end
