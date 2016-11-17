//
//  iHImgCache.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iHImgOperation.h"
#import "iHCacheDelegate.h"
#import "iHLog.h"

@interface iHImgCache : NSObject <iHImgOperationDelegate>
{
    NSOperationQueue *theQueue;
    NSMutableDictionary *memoryCache;
    
    @private
    iHLog *theLog;
    id cusDelegate;
}

@property (nonatomic, strong) id cusDelegate;

- (UIImage *)getImgByUrlString:(NSString *)urlStr withDelegate:(id<iHCacheDelegate>)delegate;
- (void)clearCachedData;
- (void)cancelOperationByUrlString:(NSString *)urlStr;

@end
