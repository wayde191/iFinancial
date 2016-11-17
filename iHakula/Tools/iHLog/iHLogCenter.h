//
//  iHLogCenter.h
//  Korpen
//
//  Created by Wayde Sun on 3/14/13.
//  Copyright (c) 2013 Symbio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASINetworkQueue;
@interface iHLogCenter : NSObject {
    ASINetworkQueue *_requestQueue;
    NSInteger _localOldestFileIndex;
}

- (void)uploadLogs;

@end
