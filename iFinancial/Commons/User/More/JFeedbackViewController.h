//
//  JFeedbackViewController.h
//  Journey
//
//  Created by Wayde Sun on 7/2/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "FBaseViewController.h"

@interface JFeedbackViewController : FBaseViewController

@property (weak, nonatomic) IBOutlet UITextView *theTextView;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;

@property (retain, nonatomic) id delegate;

- (IBAction)onBgClicked:(id)sender;
- (IBAction)sureFeedBtnClicked:(id)sender;

- (void)onFeedbackSuccess;
- (void)onFeedbackFailure;
@end
