//
//  iHLogCenter.m
//  Korpen
//
//  Created by Wayde Sun on 3/14/13.
//  Copyright (c) 2013 Symbio. All rights reserved.
//

#import "iHLogCenter.h"
#import "iHFileManager.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "iHLog.h"

@interface iHLogCenter ()
- (void)requestQueueDidFinishLoading:(ASINetworkQueue *)queue;
- (void)requestDidFinish:(ASIFormDataRequest *)request;
- (void)requestDidFailed:(ASIFormDataRequest *)request;

@end

@implementation iHLogCenter

- (id)init {
    self = [super init];
    if (self) {
        _requestQueue = [[ASINetworkQueue alloc] init];
        _requestQueue.delegate = self;
        _requestQueue.showAccurateProgress = YES;
        [_requestQueue setMaxConcurrentOperationCount:1];
        [_requestQueue setQueueDidFinishSelector:@selector(requestQueueDidFinishLoading:)];
        [_requestQueue setRequestDidFinishSelector:@selector(requestDidFinish:)];
        [_requestQueue setRequestDidFailSelector:@selector(requestDidFailed:)];
    }
    return self;
}

- (void)dealloc {
    [_requestQueue reset];
    _requestQueue = nil;
}

#pragma mark - ASINetworkQueue Delegate
- (void)requestQueueDidFinishLoading:(ASINetworkQueue *)queue {
    [USER_DEFAULT setValue:[NSString stringWithFormat:@"%ld", (long)_localOldestFileIndex] forKey:IH_OLDEST_LOG_VERSION_NUM];
    [USER_DEFAULT synchronize];
}

- (void)requestDidFinish:(ASIFormDataRequest *)request {
    
    // Means server processed the request, but not give response data
    if (204 == [request responseStatusCode]) {
        NSString *fileName = [request.requestHeaders objectForKey:@"fileName"];
        NSInteger fileIndex = [fileName integerValue];
        
        NSString *filePath = [[iHFileManager getDocumentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"logs/%@", [NSString stringWithFormat:@"%@.txt", fileName]]];
        [iHFileManager deleteFile:filePath];
        
        fileIndex++;
        _localOldestFileIndex = fileIndex;
    } else {
        [_requestQueue cancelAllOperations];
    }
    
}

- (void)requestDidFailed:(ASIFormDataRequest *)request {
    [_requestQueue cancelAllOperations];
}

#pragma mark - Public Methods
- (void)uploadLogs {
    
    NSString *oldestVersion = [USER_DEFAULT objectForKey:IH_OLDEST_LOG_VERSION_NUM];
    NSString *currentLogVersion = [USER_DEFAULT objectForKey:IH_ERROR_LOG_VERSION_NUM];
    _localOldestFileIndex = [oldestVersion integerValue];
    
    NSString *documentPath = [iHFileManager getDocumentPath];
    
    for (int i = [oldestVersion intValue]; i < [currentLogVersion intValue]; i++) {
        
        NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"logs/%d.txt", i]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSError *err = nil;
            NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
            if (err) {
                continue;
            }
            NSString *json = [NSString stringWithFormat:@"{'id':'%d','message':'%@'}", i, content];
            NSString *authValue = [NSString stringWithFormat:@"Basic %@",
                                   [NSString base64forData:
                                    [[NSString stringWithFormat:@"%@:%@", @"apps", @"3espe2ANAkaSwece"] dataUsingEncoding:NSUTF8StringEncoding]]];
            
            ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"https://korpenmobileservertest.cloudapp.net/api/clientlog"]];
            request.postFormat = ASIURLEncodedPostFormat;
            [request setRequestMethod:@"POST"];
            [request addRequestHeader:@"content-type" value:@"application/json"];
            [request addRequestHeader:@"Authorization" value:authValue];
            [request addRequestHeader:@"fileName" value:[NSString stringWithFormat:@"%d", i]];
            [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
            
            request.defaultResponseEncoding = NSUTF8StringEncoding;
            request.allowCompressedResponse = YES;
            request.shouldCompressRequestBody = NO;
            request.shouldAttemptPersistentConnection = NO;
            [request setValidatesSecureCertificate:NO];
            
            [_requestQueue addOperation:request];
        }
    }
    
    if (_requestQueue.requestsCount) {
        [_requestQueue go];
    }
}

@end
