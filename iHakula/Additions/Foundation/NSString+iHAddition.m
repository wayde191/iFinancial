//
//  NSString+iHAddition.m
//  iHakula
//
//  Created by Wayde Sun on 1/17/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "NSString+iHAddition.h"
#import "UIFont+iHAddition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (iHAddition)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:dic context:nil].size;
    
    //[self sizeWithFont:font constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    
	NSInteger lines = size.height / [font ihLineHeight];
	return lines;
}
- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth{
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:dic context:nil].size;
    
//    CGSize size = [self sizeWithFont:font
//                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
//                       lineBreakMode:NSLineBreakByTruncatingTail];
	return size.height;
	
}

- (NSString *)md5 {
	const char *concat_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
	
}

- (NSString *)stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString*)encodeURL:(NSString *)string
{
	NSString *newString =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         (CFStringRef)string,
                                                         NULL,
                                                         CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                         CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

+ (NSString*)base64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
			
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
