//
//  iHYearTableViewController.h
//  iFinancial
//
//  Created by Wayde Sun on 4/16/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iHYearModel;
@interface iHYearTableViewController : UITableViewController {
    iHYearModel *_dataModel;
}

- (void)reloadTableView;
- (void)showMessage:(NSString *)msg;
- (void)gotoLoginViewController;
@end
