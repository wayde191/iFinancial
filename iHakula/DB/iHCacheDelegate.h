//
//  iHCacheDelegate.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol iHCacheDelegate <NSObject>
-(void)imgLoaded:(UIImage *)img byUrl:(NSString *)urlStr;
@end
