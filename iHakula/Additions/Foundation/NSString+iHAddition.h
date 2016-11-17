//
//  NSString+iHAddition.h
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (iHAddition)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth;
- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth;
- (NSString *)md5;
- (NSString *)stringFromMD5;
+ (NSString*)encodeURL:(NSString *)string;
+ (NSString*)base64forData:(NSData*)theData;

@end
