//
//  iHAlertView.m
//  Korpen
//
//  Created by Wayde Sun on 3/5/13.
//  Copyright (c) 2013 Symbio. All rights reserved.
//

#import "iHAlertView.h"

@implementation iHAlertView

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


@implementation UIAlertView (Blocks)

@dynamic blocksDelegate_;

- (void)setBlocksDelegate_:(iHAlertView *)blocksDelegate_
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
		
		iHAlertView *blocksDelegate = [[iHAlertView alloc] initWithBlock:selectedBlock];
		[self setBlocksDelegate_:blocksDelegate];
		
		self.delegate = blocksDelegate;
	}
	
	return self;
}

@end
