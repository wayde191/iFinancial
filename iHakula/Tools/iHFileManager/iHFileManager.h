//
//  iHFileManager.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iHFileManager : NSObject

+ (NSString *)getDocumentPath;
+ (void)createFolder:(NSString *)folderName;
+ (void)deleteFile:(NSString *)strFile withFolderName:(NSString *)strFolder;
+ (void)deleteFile:(NSString *)atPath;
+ (void)deleteFiles:(NSArray *)fileNames underFolder:(NSString *)folderName;
+ (void)deleteDirectory:(NSString *)directoryPath;
+ (void)copyFile:(NSString *)fromPath toDirectory:(NSString *)toPath;
+ (NSArray *)searchFile:(NSString *)strFolder withSuffix:(NSString *)strSuffix;
+ (NSArray *)contentsOfDirectoryUnderFolder:(NSString *)folerName;

@end
