//
//  iHBaseViewController.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iHLog, iHPubSub;
@interface iHBaseViewController : UIViewController {
@public
    CGSize keyboardSize;
    iHLog *sysLog;
    iHPubSub *sysPubSub;
}

//Keyboard observer
-(void) keyboardWillShow: (NSNotification *)sender;
-(void) keyboardWillHide: (NSNotification *)sender;

@end
