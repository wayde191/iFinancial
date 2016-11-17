//
//  iHCommonFunctions.h
//  iHakula
//
//  Created by Wayde Sun on 6/28/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - CG Common Functions

CGPoint CGRectGetCenter(CGRect rect);
CGFloat distanceBetweenPoints(CGPoint p1,CGPoint p2);
CGFloat angleOfPointFromCenter(CGPoint p,CGPoint center);
BOOL ITTIsModalViewController(UIViewController* viewController);
