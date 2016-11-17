//
//  iHDummyData.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHDummyData.h"
#import "CJSONDeserializer.h"

@implementation iHDummyData
+ (NSDictionary *)getDicFromDummyData:(NSString *)fileName
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSError *error;
    NSString *responseString = [NSString stringWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding error:&error];
    if (!responseString) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:
                                 [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error]];
    
    return responseDic;
}
@end
