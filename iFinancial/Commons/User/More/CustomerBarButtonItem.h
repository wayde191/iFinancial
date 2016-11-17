//
//  CustomerBarButtonItem.h
//  UnderCover
//
//  Created by Wayde Sun on 7/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerBarButtonItem : UIBarButtonItem

+ (UIBarButtonItem *)createRectBarButtonItemWithImageUrl:(NSString *)url target:(id)delegate action:(SEL)action;
+ (UIBarButtonItem *)createRectBarButtonItemWithTitle:(NSString *)title;
+ (UIBarButtonItem *)createGoBackItemWithTitle:(NSString *)title;
@end
