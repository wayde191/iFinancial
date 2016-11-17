//
//  iHDataArchiver.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#define CACHE_FILE_NAME         @"ITTCacheData.plist"
#define CACHE_FILE_FOLDER       @"CacheFiles"

#import <Foundation/Foundation.h>

@interface iHDataArchiver : NSObject <NSCoding, NSCopying>{
    
    NSMutableDictionary *cachedDataDic;
    
}

@property (nonatomic, strong) NSMutableDictionary *cachedDataDic;

+ (NSString *)cacheDataFilePath;
+ (void)writeDataToCacheFile: (NSDictionary *)dic;
+ (NSDictionary *)getDataFromCacheFile;

+ (void)writeData:(NSDictionary *)dic toFile:(NSString *)fileName;
+ (NSDictionary *)getDataFromFile:(NSString *)fileName;

@end
