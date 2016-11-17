//
//  iHBaseViewController.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHBaseViewController.h"
#import "iHLog.h"
#import "iHPubSub.h"
#import "iHSingletonCloud.h"

@interface iHBaseViewController ()

@end

@implementation iHBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sysLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        sysPubSub = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHPubSub"];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        sysLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        sysPubSub = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHPubSub"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Add Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Public Methods
-(void) keyboardWillShow: (NSNotification *)sender
{
    NSDictionary* info = [sender userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
}

-(void) keyboardWillHide: (NSNotification *)sender
{
}

@end
