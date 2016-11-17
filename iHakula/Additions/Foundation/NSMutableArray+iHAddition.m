//
//  NSMutableArray+iHAddition.m
//  iHakula
//
//  Created by Wayde Sun on 12/6/12.
//  Copyright (c) 2012 iHakula. All rights reserved.
//

#import "NSMutableArray+iHAddition.h"

@implementation NSMutableArray (iHAddition)

- (void)addObjectSafe:(id)anObject
{
    if(anObject == nil)
        return;
    [self addObject:anObject];
}

@end
