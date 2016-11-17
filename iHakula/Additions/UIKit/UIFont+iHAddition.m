//
//  UIFont+iHAddition.m
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "UIFont+iHAddition.h"

@implementation UIFont (iHAddition)

- (CGFloat)ihLineHeight {
    return (self.ascender - self.descender) + 1;
}

@end
