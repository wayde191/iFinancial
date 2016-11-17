//
//  iHAccountViewController.h
//  iFinancial
//
//  Created by Bean on 14-4-19.
//  Copyright (c) 2014年 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAccountBaseModel.h"
#import "iAccountModel.h"

@interface iHAccountViewController : UIViewController<UITextFieldDelegate,UITextInputDelegate>
{
    iAccountModel *model;
}
@property (weak, nonatomic) IBOutlet UITextField *CostText;
//@property (weak, nonatomic) IBOutlet UITextField *typeText;
@property (weak, nonatomic) IBOutlet UITextField *desText;

- (IBAction)onAddBtnClicked:(id)sender;
@end
