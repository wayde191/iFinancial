//
//  UIAlertView+iHAddition.h
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <objc/runtime.h>

@interface UIAlertViewBlocks : NSObject <UIAlertViewDelegate>
{
	void (^selectedBlock_)(NSInteger buttonIndex);
}

- (id)initWithBlock:(void (^)(NSInteger buttonIndex))resultBlock;

@end
/***********************************************************************************/

@interface UIAlertView (iHAddition)

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg;
+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ...;

/******** Block Alertview *********/
@property (nonatomic, assign) UIAlertViewBlocks *blocksDelegate_;
- (id)initWithTitle:(NSString *)title message:(NSString *)message selectedBlock:(void (^)(NSInteger index))selectedBlock  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;
@end
