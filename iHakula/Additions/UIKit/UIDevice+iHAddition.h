//
//  UIDevice+iHAddition.h
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (iHAddition)

+ (BOOL)isHighResolutionDevice;
+ (UIInterfaceOrientation)currentOrientation;
- (NSString *)getMacAddress;
// For release
//- (NSString *)uniqueDeviceIdentifier;
//- (NSString *)uniqueGlobalDeviceIdentifier;

@end
