//
//  iHCacheCenter.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#define CACHED_DATA_KEY                 @"data"
#define CACHED_DATA_TIME_INTERVAL       @"time"


#import <Foundation/Foundation.h>
#import "iHSingletonCloud.h"
#import "iHCacheDelegate.h"

@class iHLog;
@interface iHCacheCenter : NSObject {
    
@private
    iHLog *theLog;
    
@public
    NSMutableDictionary *cacheCenterDic;
    
}

- (void)setCacheData:(id)data forKey:(NSString *)key;
- (id)getCachedDataByKey:(NSString *)key;
- (UIImage *)getImgFromUrlStr:(NSString *)urlStr byDelegate:(id<iHCacheDelegate>)delegate;
- (void)cancelLoadingImgByUrlStr:(NSString *)urlStr;
- (NSDictionary *)getCachedDataFromLocalFile;
- (void)setDataToLocalFile:(NSDictionary *)dic;
- (void)doSaveData;
- (void)clearCachedData;
- (void)removeCachedDataAndFile:(NSString *)key;
- (void)loadCachedDataFromLocalFile;

- (void)doSaveData:(id)data byKey:(NSString *)fileName;
- (void)setData:(id)data toFile:(NSString *)fileName;
- (void)loadCachedDataFromFile:(NSString *)fileName;
- (void)clearAllCachedFiles;
- (void)clearCachedFiles:(NSArray *)fileNames;
- (void)clearOtherCachedFilesExcept:(NSArray *)fileNames;

- (void)displayCaches;

@end


#pragma mark - Add method to Objects
@interface NSObject ( iHCacheCenterCategory )
- (id)cacheDataWithKey:(NSString *)key;
@end

@implementation NSObject ( iHCacheCenterCategory )

- (id)cacheDataWithKey:(NSString *)key
{
    iHCacheCenter *cacheCenter = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHCacheCenter"];
    [cacheCenter setCacheData:self forKey:key];
    
    return self;
}

@end
