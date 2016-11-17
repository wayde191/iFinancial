//
//  NSArray+iHAddition.h
//  iHakula
//
//  Created by Wayde Sun on 12/6/12.
//  Copyright (c) 2012 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (iHAddition)

-(BOOL)containString:(NSString *)string;
-(NSInteger)indexOfString:(NSString *)string;
- (id)objectAtIndexSafe:(NSUInteger)index;

@end
