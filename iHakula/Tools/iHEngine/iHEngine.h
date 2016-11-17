//
//  iHEngine.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

#define iH_SUCCESS YES
#define iH_FAILURE NO
//#define HOST_NAME           @"www.ihakula.com"
//#define SERVICE_ROOT_URL    @"http://www.ihakula.com/api/index.php/ifinancial/"

@interface iHEngine : NSObject {
    @public
        BOOL howEngineDoing;
}
    
@property (nonatomic, assign) BOOL howEngineDoing;
    
+ (id)sharedInstance;
+ (BOOL)start;

@end
