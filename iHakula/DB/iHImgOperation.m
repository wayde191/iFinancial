//
//  iHImgOperation.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHImgOperation.h"

@implementation iHImgOperation
@synthesize imgCacheDelegate, customerDelegate, urlStr;

#pragma mark - System

- (id)initWithImgUrlStr:(NSString *)imgUrlStr 
   withImgCacheDelegate:(id<iHImgOperationDelegate>)cacheDelegate 
            forCustomer:(id)cusDelegate
{
    self = [self init];
    if (self) {
        self.urlStr = imgUrlStr;
        self.imgCacheDelegate = cacheDelegate;
        self.customerDelegate = cusDelegate;
    }
    return self;
}

- (void)cancel {
    [super cancel];
    imgCacheDelegate = nil;
}

#pragma mark - Operation Callback
- (void)main
{
    NSURL *imgUrl = [NSURL URLWithString:self.urlStr];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    if( imgData ){
        UIImage *image = [UIImage imageWithData:imgData];
        if (image && imgCacheDelegate && [imgCacheDelegate respondsToSelector:@selector(imgOperation:imgLoaded:byUrl:forCustomer:)]) {
            [imgCacheDelegate imgOperation:self imgLoaded:image byUrl:self.urlStr forCustomer:customerDelegate];
        }
    }
    
    return;
}

@end
