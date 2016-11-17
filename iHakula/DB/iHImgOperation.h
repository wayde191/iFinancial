//
//  iHImgOperation.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iHImgOperationDelegate, iHCacheDelegate;
@interface iHImgOperation : NSOperation {
    id<iHImgOperationDelegate> __weak imgCacheDelegate;
    id customerDelegate;
    NSString *urlStr;
}

@property (nonatomic, weak) id<iHImgOperationDelegate> imgCacheDelegate;
@property (nonatomic, strong) id customerDelegate;
@property (nonatomic, strong) NSString *urlStr;

- (id)initWithImgUrlStr:(NSString *)imgUrlStr withImgCacheDelegate:(id<iHImgOperationDelegate>)cacheDelegate forCustomer:(id)cusDelegate;
- (void)cancel;

@end


#pragma mark - Protocol iHImgOperationDelegate
@protocol iHImgOperationDelegate <NSObject>

@optional
-(void)imgOperation:(iHImgOperation*)operation imgLoaded:(UIImage *)img byUrl:(NSString *)urlStr forCustomer:(id<iHCacheDelegate>)customerDelegate;

@end
