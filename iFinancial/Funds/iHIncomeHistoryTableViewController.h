//
//  iHIncomeHistoryTableViewController.h
//  iFinancial
//
//  Created by Wayde Sun on 3/31/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iHIncomeHisModel;
@interface iHIncomeHistoryTableViewController : UITableViewController {
    iHIncomeHisModel *_dataModel;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (void)refreshTableView;
- (void)serviceCallFailed;

- (void)gotoLoginViewController;
@end
