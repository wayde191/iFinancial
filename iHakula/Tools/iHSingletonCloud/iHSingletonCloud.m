//
//  iHSingletonCloud.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHSingletonCloud.h"
#import "iHDebug.h"

static iHSingletonCloud *singletonInstance = nil;
@implementation iHSingletonCloud

@synthesize singletonInstancesDic;

+ (id)sharedInstance
{
    @synchronized(self){
        if (!singletonInstance) {
            singletonInstance = [[iHSingletonCloud alloc] init];
        }
        
        return singletonInstance;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.singletonInstancesDic = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - class methods
+ (id)getSharedInstanceByClassNameString:(NSString *)className
{
    iHSingletonCloud *singletonCloud = [iHSingletonCloud sharedInstance];
    id classInstance = [singletonCloud.singletonInstancesDic objectForKey:className];
    
    if (!classInstance) {
        Class classStr = NSClassFromString(className);
        classInstance = [[classStr alloc] init];
        if (classInstance) {
            [singletonCloud.singletonInstancesDic setObject:classInstance forKey:className];
            iHDINFO(@"%@ is not in the cloud", className);
        }
    }
    
    return classInstance;
}

+ (BOOL)releaseSharedInstanceByClassNameString:(NSString *)className
{
    iHSingletonCloud *singletonCloud = [iHSingletonCloud sharedInstance];
    id classInstance = [singletonCloud.singletonInstancesDic objectForKey:className];
    [singletonCloud.singletonInstancesDic removeObjectForKey:className];
    
    return !classInstance ? NO : YES;
}

@end
