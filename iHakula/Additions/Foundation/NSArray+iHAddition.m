//
//  NSArray+iHAddition.m
//  iHakula
//
//  Created by Wayde Sun on 12/6/12.
//  Copyright (c) 2012 iHakula. All rights reserved.
//

#import "NSArray+iHAddition.h"

@implementation NSArray (iHAddition)

-(BOOL)containString:(NSString *)string{
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

-(NSInteger)indexOfString:(NSString *)string{
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string]) {
            return [self indexOfObject:object];
        }
    }
    return NSNotFound;
}

- (id)objectAtIndexSafe:(NSUInteger)index
{
    if(index >= [self count])
        return nil;
    return [self objectAtIndex:index];
}


@end
