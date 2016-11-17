//
//  iHImgCache.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#define iH_IMG_CACHE_MAX_OPERATIONS_COUNT      20

#import "iHImgCache.h"
#import "iHValidationKit.h"
#import "iHSingletonCloud.h"

@interface iHImgCache ()
- (UIImage *)getImgByUrl:(NSString *)imgUrlStr;
- (UIImage *)getImgFromNativeFile:(NSString *)imgUrl;
- (UIImage *)getImgFromMemory:(NSString *)key;
- (UIImage *)getimgFromFileSystem:(NSString *)imgUrl;
- (NSString *)getImgCacheFolder;
- (NSString *)getImgPathByFileName:(NSString *)fileName;
- (BOOL)createImgCacheFolder;
@end

@implementation iHImgCache
@synthesize cusDelegate;

#pragma mark - System

- (id)init
{
    self = [super init];
    if (self) {
        self->theQueue = [[NSOperationQueue alloc] init];
        [self->theQueue setMaxConcurrentOperationCount:iH_IMG_CACHE_MAX_OPERATIONS_COUNT];
        self->memoryCache = [[NSMutableDictionary alloc] init];
        
        theLog = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHLog"];
        [self createImgCacheFolder];
    }
    return self;
}

#pragma mark - Instance Methods
- (UIImage *)getImgByUrlString:(NSString *)urlStr withDelegate:(id<iHCacheDelegate>)delegate
{
    if ([iHValidationKit isValueEmpty:urlStr]) {
        [theLog pushLog:@"getImgByUrlString:withDelegate" message:@"Received url is empty" type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
        return nil;
    }
    
    UIImage *imgFindFor = [self getImgByUrl:urlStr];
    if (imgFindFor) {
        return imgFindFor;
    } else {
        // Load img from web
        iHImgOperation *operation = [[iHImgOperation alloc] initWithImgUrlStr:urlStr withImgCacheDelegate:self forCustomer:delegate];
        [self->theQueue addOperation:operation];
        
        return nil;
    }
    
    return imgFindFor;
}

- (void)cancelOperationByUrlString:(NSString *)urlStr {
    if ([iHValidationKit isValueEmpty:urlStr]) {
        [theLog pushLog:@"cancelOperationByUrlString:" message:@"Received url is empty" type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
        return;
    }
    
    __block iHImgOperation *cancelingOperation = nil;
    [[theQueue operations] enumerateObjectsUsingBlock:^(iHImgOperation *object, NSUInteger index, BOOL *stop) {
        if ([object.urlStr isEqualToString:urlStr]) {
            cancelingOperation = object;
            *stop = YES;
        }
    }];
    
    if (cancelingOperation && ([cancelingOperation isExecuting] || [cancelingOperation isReady])) {
        [cancelingOperation cancel];
    }
}

#pragma mark - Private Methods
- (UIImage *)getImgByUrl:(NSString *)imgUrlStr
{
    UIImage *imgFindFor;
    NSString *url = [NSString encodeURL:imgUrlStr];
    
    imgFindFor = [self getImgFromNativeFile:url];
    if (!imgFindFor) {
        imgFindFor = [self getImgFromMemory:url];
        if (!imgFindFor) {
            imgFindFor = [self getimgFromFileSystem:url];
        }
    }
    
    return imgFindFor;
}

- (UIImage *)getImgFromNativeFile:(NSString *)imgUrl {
    return ImageNamed(imgUrl);
}

- (UIImage *)getImgFromMemory:(NSString *)key
{
    return (UIImage *)[self->memoryCache objectForKey:key];
}

- (UIImage *)getimgFromFileSystem:(NSString *)imgUrl
{
    NSString *imgFilePath = [self getImgPathByFileName:imgUrl];
    UIImage *imgFindFor = [UIImage imageWithContentsOfFile:imgFilePath];
    if (imgFindFor) {
        [self->memoryCache setObject:imgFindFor forKey:imgUrl];
    }
    return imgFindFor;
}

- (NSString *)getImgPathByFileName:(NSString *)fileName
{
    NSRange rangeFound = [fileName rangeOfString:@"Documents"];
    if (rangeFound.length > 0) {
        return [NSString stringWithString:fileName];
    }
    
    return [NSString stringWithFormat:@"%@/%@", [self getImgCacheFolder], fileName];
}

- (NSString *)getImgCacheFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    // The first one
    NSString *cacheFolder = [paths objectAtIndex:0];
	return [NSString stringWithFormat:@"%@/images",cacheFolder];
}

- (BOOL)createImgCacheFolder
{
    NSString *imgCacheFolder = [self getImgCacheFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imgCacheFolder]) {
        @synchronized(self){
            NSFileManager* manager = [NSFileManager defaultManager];
            NSError *error = nil;
            if (![manager createDirectoryAtPath:imgCacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
                [theLog pushLog:@"Create Img cache folder error"
                        message:[error localizedDescription] type:iH_LOGS_EXCEPTION file:nil function:nil line:0];
                return NO;
            }
        }
    }
    return YES;
}

- (void)clearCachedData
{
    [self->memoryCache removeAllObjects];
}

#pragma mark - iHImgOperationDelegate
- (void)imgOperation:(iHImgOperation *)operation imgLoaded:(UIImage *)img byUrl:(NSString *)urlStr forCustomer:(id<iHCacheDelegate>)customerDelegate
{
    self.cusDelegate = customerDelegate;
    NSString *encodedUrlStr = [NSString encodeURL:urlStr];
    
    if (![self->memoryCache objectForKey:encodedUrlStr]) {
        // Cached in memeory
        [self->memoryCache setObject:img forKey:encodedUrlStr];
        
        // Cached in File system
        @autoreleasepool {
            NSData* imgData = UIImagePNGRepresentation(img);
            NSString *imgFilePath = [self getImgPathByFileName:encodedUrlStr];
            [imgData writeToFile:imgFilePath atomically:YES];
            [theLog pushLog:@"Write img to File" message:encodedUrlStr type:iH_LOGS_MESSAGE file:nil function:nil line:0];
        }
    }
    
    // Customer call back
    if (self.cusDelegate && [self.cusDelegate respondsToSelector:@selector(imgLoaded:byUrl:)]) {
        [self.cusDelegate imgLoaded:[self->memoryCache objectForKey:encodedUrlStr] byUrl:urlStr];
    }
}

@end
