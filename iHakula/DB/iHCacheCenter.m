//
//  iHCacheCenter.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHCacheCenter.h"
#import "iHImgCache.h"
#import "iHDataArchiver.h"
#import "iHValidationKit.h"
#import "iHNetworkMonitor.h"
#import "iHFileManager.h"

@implementation iHCacheCenter
#pragma mark - System

- (id)init
{
    self = [super init];
    if (self) {
        cacheCenterDic = [[NSMutableDictionary alloc] initWithCapacity:1000];
        theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
    }
    return self;
}

#pragma mark - Instance Methods
- (void)setCacheData:(id)data forKey:(NSString *)key
{
    NSAssert(data != nil, @"Cached Data not nil");
    BOOL checkResult = [key isEqualToString:@""];
    if (checkResult) {
        NSAssert(key != nil && checkResult != YES, @"Cached Data key not nil");
    }
    
    [theLog pushLog:@"Cache Data" message:[NSString stringWithFormat:@"Key:%@ ,Value:%@", key, data]
               type:iH_LOGS_MESSAGE file:nil function:nil line:0];
    
    iHNetworkMonitor *network = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHNetworkMonitor"];
    // When network is not reachable and the value is empty, we do not rewrite current value
    if (!network.isReachable) {
        return;
    }
    
    [cacheCenterDic setValue:data forKey:key];
}

- (id)getCachedDataByKey:(NSString *)key
{
    BOOL checkResult = [key isEqualToString:@""];
    if (checkResult) {
        NSAssert(key != nil && checkResult != YES, @"Cached Data key not nil");
    }
    id cachedData = nil;
    cachedData = [cacheCenterDic valueForKey:key];
    
    return cachedData;
}

- (UIImage *)getImgFromUrlStr:(NSString *)urlStr byDelegate:(id<iHCacheDelegate>)delegate
{
    iHImgCache *imgCache = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHImgCache"];
    UIImage *imgFindFor = [imgCache getImgByUrlString:urlStr withDelegate:delegate];
    return imgFindFor;
}

- (void)cancelLoadingImgByUrlStr:(NSString *)urlStr {
    iHImgCache *imgCache = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHImgCache"];
    [imgCache cancelOperationByUrlString:urlStr];
}

// Local file cached data
- (NSDictionary *)getCachedDataFromLocalFile
{
    NSDictionary *cacheDic = [NSDictionary dictionaryWithDictionary: [iHDataArchiver getDataFromCacheFile]];
    if (!cacheDic) {
        // Return a empty dictionary
        cacheDic = [NSDictionary dictionary];
    } else {
        // Write pair's data to standardUserDefaults with key/value
        //        for (NSString *key in cacheDic) {
        //            [[NSUserDefaults standardUserDefaults] setObject:[cacheDic objectForKey:key] forKey:key];
        //        }
    }
    return cacheDic;
}

- (void)setDataToLocalFile:(NSDictionary *)dic
{
    if ([iHValidationKit isValueEmpty:dic]) {
        [theLog pushLog:@"iHCacheCenter:setDataToLocalFile" message:@"The dic set to file is empty" type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
        return;
    }
    
    iHNetworkMonitor *network = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHNetworkMonitor"];
    
    NSMutableDictionary *storedDic = [NSMutableDictionary dictionaryWithDictionary:[self getCachedDataFromLocalFile]];
    for (NSString *key in dic) {
        // When network is not reachable, we do not rewrite current value
        if (!network.isReachable) {
            continue;
        }
        [storedDic setValue:[dic objectForKey:key] forKey:key];
    }
    [iHDataArchiver writeDataToCacheFile:storedDic];
}

- (void)doSaveData
{
    if ([cacheCenterDic count]) {
        [self setDataToLocalFile:cacheCenterDic];
    }
}

- (void)clearCachedData
{
    [cacheCenterDic removeAllObjects];
    iHImgCache *imgCache = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHImgCache"];
    [imgCache clearCachedData];
}

- (void)removeCachedDataAndFile:(NSString *)key {
    if ([cacheCenterDic objectForKey:key]) {
        [cacheCenterDic removeObjectForKey:key];
        [self clearCachedFiles:[NSArray arrayWithObject:key]];
    }
}

- (void)loadCachedDataFromLocalFile
{
    // Load all cached data from local file
    NSDictionary *localFileDic = [self getCachedDataFromLocalFile];
    for (NSString *key in localFileDic) {
        [cacheCenterDic setValue:[localFileDic objectForKey:key] forKey:key];
    }
}

- (void)displayCaches {
    iHDINFO(@"====== All Cached Data : %@", cacheCenterDic);
}

#pragma mark - Save Multiple Files
- (void)doSaveData:(id)data byKey:(NSString *)fileName {
    if (![iHValidationKit isValueEmpty:data]) {
        [self setData:data toFile:fileName];
    }
}

- (void)setData:(id)data toFile:(NSString *)fileName
{
    if ([iHValidationKit isValueEmpty:fileName]) {
        [theLog pushLog:@"iHCacheCenter:setDataToFile" message:@"The file name is empty" type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
        return;
    }
        
    NSMutableDictionary *storedDic = [NSMutableDictionary dictionary];
    [storedDic setValue:data forKey:CACHED_DATA_KEY];
    [storedDic setValue:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:CACHED_DATA_TIME_INTERVAL];
    [cacheCenterDic setValue:storedDic forKey:fileName];
    
    [iHFileManager createFolder:CACHE_FILE_FOLDER];
    [iHDataArchiver writeData:storedDic toFile:fileName];
}

- (void)loadCachedDataFromFile:(NSString *)fileName
{
    NSDictionary *cacheDic = [iHDataArchiver getDataFromFile:fileName];
    if ([iHValidationKit isValueEmpty:cacheDic]) {
        // No data we can set to memory
        return;
    }

    [cacheCenterDic setValue:cacheDic forKey:fileName];
}

- (void)clearAllCachedFiles {
    [iHFileManager deleteDirectory:CACHE_FILE_FOLDER];
    [cacheCenterDic removeAllObjects];
}

- (void)clearCachedFiles:(NSArray *)fileNames {
    
    NSMutableArray *deletingFileNames = [NSMutableArray array];
    for (NSString *fileName in fileNames) {
        if ([cacheCenterDic objectForKey:fileName]) {
            [cacheCenterDic removeObjectForKey:fileName];
        }
        NSString *fullName = [NSString stringWithFormat:@"%@.plist", fileName];
        [deletingFileNames addObject:fullName];
    }
    
    [iHFileManager deleteFiles:deletingFileNames underFolder:CACHE_FILE_FOLDER];
}

- (void)clearOtherCachedFilesExcept:(NSArray *)fileNames {
    
    NSArray *filesInHardDisk = [iHFileManager contentsOfDirectoryUnderFolder:CACHE_FILE_FOLDER];
    NSMutableArray *deletingFileNames = [NSMutableArray array];
    
    for (NSString *fileName in filesInHardDisk) {
        NSString *file = [fileName stringByReplacingOccurrencesOfString:@".plist" withString:@""];
        
        if (![fileNames containsObject:file]) {
            if ([cacheCenterDic objectForKey:file]) {
                [cacheCenterDic removeObjectForKey:file];
            }
            [deletingFileNames addObject:fileName];
        }
    }
    
    iHDINFO(@"-- Not reused files: %@", deletingFileNames);
    
    [iHFileManager deleteFiles:deletingFileNames underFolder:CACHE_FILE_FOLDER];
}

@end
