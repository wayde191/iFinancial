//
//  iHSingletonCloud.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iHSingletonCloud : NSObject {

@private
    NSMutableDictionary *singletonInstancesDic;
    
}

@property(nonatomic, strong) NSMutableDictionary *singletonInstancesDic;

#pragma mark - Class interface
+ (id)getSharedInstanceByClassNameString: (NSString *)className;
+ (BOOL)releaseSharedInstanceByClassNameString: (NSString *)className;

+ (id)sharedInstance;

@end
