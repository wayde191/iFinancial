//
//  UIAlertView+iHAddition.m
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "UIAlertView+iHAddition.h"

@implementation UIAlertViewBlocks

- (id)initWithBlock:(void (^)(NSInteger buttonIndex))resultBlock
{
	self = [super init];
	if (self) {
		selectedBlock_ = [resultBlock copy];
	}
	
	return self;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	selectedBlock_(buttonIndex);
}
@end
/***********************************************************************************/


@implementation UIAlertView (iHAddition)

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];	
}

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ... {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                    delegate:delegate cancelButtonTitle:cancel otherButtonTitles:others, nil];
    [alert show];	
}

/***********************************************************************************/
@dynamic blocksDelegate_;

- (void)setBlocksDelegate_:(UIAlertViewBlocks *)blocksDelegate_
{
	objc_setAssociatedObject(self, @"blocksDelegate", blocksDelegate_, OBJC_ASSOCIATION_RETAIN);
}

- (id)delegate_
{
	return (id)objc_getAssociatedObject(self, @"blocksDelegate");
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message selectedBlock:(void (^)(NSInteger index))selectedBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [self initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
	if (self) {
        // Error in iOS 6
//		va_list args;
//		va_start(args, otherButtonTitles);
//		for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
//			[self addButtonWithTitle:arg];
//		}
//		va_end(args);
		
		UIAlertViewBlocks *blocksDelegate = [[UIAlertViewBlocks alloc] initWithBlock:selectedBlock];
		[self setBlocksDelegate_:blocksDelegate];
		
		self.delegate = blocksDelegate;
	}
	
	return self;
}


@end
