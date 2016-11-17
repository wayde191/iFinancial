//
//  iHDataArchiver.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#define CACHE_DECODE_KEY    @"CacheDecodeKey"
#define CACHE_DATA_KEY      @"CacheDataKey"

#import "iHDataArchiver.h"
#import "iHFileManager.h"

@implementation iHDataArchiver
@synthesize cachedDataDic;


-(id) init{
    self = [super init];
    if (self) {
        self.cachedDataDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.cachedDataDic = [aDecoder decodeObjectForKey:CACHE_DECODE_KEY];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:cachedDataDic forKey:CACHE_DECODE_KEY];
}

-(id) copyWithZone:(NSZone *)zone
{
    iHDataArchiver *copy = [[[self class] allocWithZone:zone] init];
    cachedDataDic = [self.cachedDataDic copy];
    
    return copy;
}

#pragma mark - Class Methods
+ (NSString *)cacheDataFilePath{
    // Get document path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    
    return [cacheDirectory stringByAppendingPathComponent:CACHE_FILE_NAME];
}

+ (void)writeDataToCacheFile:(NSDictionary *)dic
{
    iHDataArchiver *archiver = [[iHDataArchiver alloc] init];
    archiver.cachedDataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [arch encodeObject:archiver forKey:CACHE_DATA_KEY];
    [arch finishEncoding];
    [data writeToFile:[self cacheDataFilePath] atomically:YES];
}

+ (NSDictionary *)getDataFromCacheFile
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self cacheDataFilePath]];
    if (!data) {
        return nil;
    }
    NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    iHDataArchiver *archiver = [unArch decodeObjectForKey:CACHE_DATA_KEY];
    
    [unArch finishDecoding];
    
    NSDictionary *cachedDataDic = [NSDictionary dictionaryWithDictionary:archiver.cachedDataDic];
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    for (NSString *key in cachedDataDic) {
        id value = [cachedDataDic objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [returnDic setObject:value forKey:key];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            [returnDic setObject:[NSString stringWithFormat:@"%d", [value intValue]] forKey:key];
        } else {
            [returnDic setObject:value forKey:key];
        }
    }
    
    return returnDic;
}

+ (void)writeData:(NSDictionary *)dic toFile:(NSString *)fileName
{
    iHDataArchiver *archiver = [[iHDataArchiver alloc] init];
    archiver.cachedDataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [arch encodeObject:archiver forKey:CACHE_DATA_KEY];
    [arch finishEncoding];
    [data writeToFile:[[iHFileManager getDocumentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.plist", CACHE_FILE_FOLDER, fileName]] atomically:YES];
}

+ (NSDictionary *)getDataFromFile:(NSString *)fileName
{
    NSString *filePath = [[iHFileManager getDocumentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.plist", CACHE_FILE_FOLDER, fileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    
    if (isExist) {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        if (!data) {
            return [NSMutableDictionary dictionary];
        }
        NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        iHDataArchiver *archiver = [unArch decodeObjectForKey:CACHE_DATA_KEY];
        
        [unArch finishDecoding];
        
        NSDictionary *cachedDataDic = [NSDictionary dictionaryWithDictionary:archiver.cachedDataDic];
        NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
        for (NSString *key in cachedDataDic) {
            id value = [cachedDataDic objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                [returnDic setObject:value forKey:key];
            } else if ([value isKindOfClass:[NSNumber class]]) {
                [returnDic setObject:[NSString stringWithFormat:@"%d", [value intValue]] forKey:key];
            } else {
                [returnDic setObject:value forKey:key];
            }
        }
        
        return returnDic;
    } else {
        return [NSMutableDictionary dictionary];
    }
}

@end
