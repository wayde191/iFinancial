//
//  iHAccountViewController.m
//  iFinancial
//
//  Created by Bean on 14-4-19.
//  Copyright (c) 2014年 iHakula. All rights reserved.
//

#import "iHAccountViewController.h"

@interface iHAccountViewController ()

@end

@implementation iHAccountViewController
@synthesize CostText=_CostText;
@synthesize desText = _desText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    model = [[iAccountModel alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onAddBtnClicked:(id)sender
{
    iAccountBaseModel *account = [[iAccountBaseModel alloc]init];
    account.getDate =[NSDate date];
    account.cost = [NSNumber numberWithFloat:[_CostText.text integerValue]];
    account.description = _desText.text;
    [model.accountArr addObject:account];
    
    iAccountBaseModel *accountTest = [model.accountArr objectAtIndex:0];
    NSLog(@"********** %@   %2d",accountTest.description,[accountTest.cost integerValue]);
    [model save];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
  
    
    return YES;
}
@end
