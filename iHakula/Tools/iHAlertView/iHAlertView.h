//
//  iHAlertView.h
//  Korpen
//
//  Created by Wayde Sun on 3/5/13.
//  Copyright (c) 2013 Symbio. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <objc/runtime.h>

@interface iHAlertView : NSObject <UIAlertViewDelegate>
{
	void (^selectedBlock_)(NSInteger buttonIndex);
}

- (id)initWithBlock:(void (^)(NSInteger buttonIndex))resultBlock;

@end

@interface UIAlertView (Blocks)

@property (nonatomic, assign) iHAlertView *blocksDelegate_;

- (id)initWithTitle:(NSString *)title message:(NSString *)message selectedBlock:(void (^)(NSInteger index))selectedBlock  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;

@end
