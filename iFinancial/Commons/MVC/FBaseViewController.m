//
//  JBaseViewController.m
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "FBaseViewController.h"
#import "LPLoginViewController.h"

@interface FBaseViewController ()
- (void)callBtnClicked;
@end

@implementation FBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDelegate = [iHAppDelegate getSharedAppDelegate];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        appDelegate = [iHAppDelegate getSharedAppDelegate];
    }
    return self;
}

- (void)viewDidLoad
{
    appDelegate = [iHAppDelegate getSharedAppDelegate];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods
- (void)showAlertMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showMessage:(NSString *)msg {
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = msg;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8 animations:^(){
            self.navigationItem.prompt = nil;
        }];
    }];
}

- (void)showStaticMessage:(NSString *)msg{
    [UIView animateWithDuration:0.8 animations:^(){
        self.navigationItem.prompt = msg;
    } completion:^(BOOL finished){
    }];
}

- (void)hideMessage {
}

- (void)gotoLoginViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LPLoginViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Methods
- (void)setupRightCallItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CallMe") style:UIBarButtonItemStylePlain target:self action:@selector(callBtnClicked)];
}

- (void)callBtnClicked {
    // MKReverseGeocoder
    // CLGeocoder
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CallMeTitle")
                                                             delegate:self
                                                    cancelButtonTitle:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ABiao"), LOCALIZED_DEFAULT_SYSTEM_TABLE(@"AHui"), nil];
    
    self.view.clipsToBounds = YES;
    [actionSheet showInView:appDelegate.window];
}
@end
