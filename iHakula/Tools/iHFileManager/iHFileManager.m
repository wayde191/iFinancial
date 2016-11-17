//
//  iHFileManager.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHFileManager.h"
#import "iHDebug.h"

@implementation iHFileManager

+(NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(void)createFolder:(NSString *)folderName
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    NSString *createPath=[NSString stringWithFormat:@"%@/%@",pathDocuments,folderName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        iHDINFO(@"Have");
    }
}

+(void)deleteFile:(NSString *)strFile withFolderName:(NSString *)strFolder
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString *strBasePath = [NSString stringWithFormat:@"%@/%@",[iHFileManager getDocumentPath],strFolder];
    NSString *strPath = [strBasePath stringByAppendingPathComponent:strFile];
    BOOL blHave=[fileManager fileExistsAtPath:strPath];
    if (!blHave) {
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:strPath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

+ (void)deleteFile:(NSString *)atPath {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[fileManager fileExistsAtPath:atPath];
    if (!blHave) {
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:atPath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}

+ (void)deleteFiles:(NSArray *)fileNames underFolder:(NSString *)folderName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strBasePath = [NSString stringWithFormat:@"%@/%@",[iHFileManager getDocumentPath],folderName];
    
    NSArray *filesInHardDisk = [fileManager contentsOfDirectoryAtPath:strBasePath error:nil];
    if (filesInHardDisk) {
        for (int i = 0; i < [filesInHardDisk count]; i++) {
            NSString *name = [filesInHardDisk objectAtIndex:i];
            if ([fileNames containsObject:name]) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", strBasePath, name];
                [iHFileManager deleteFile:filePath];
            }
        }
    }
    
    return;
}

+ (void)deleteDirectory:(NSString *)directoryPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@", [iHFileManager getDocumentPath], directoryPath];
    
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (!isExist) {
        return;
    } else {
        BOOL isDeleted = [fileManager removeItemAtPath:path error:nil];
        isDeleted ? iHDINFO(@"delete directory %@ successful", directoryPath) : iHDINFO(@"delete directory failed");
    }
}

+ (void)copyFile:(NSString *)fromPath toDirectory:(NSString *)toPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fpath = fromPath;
    NSString *tpath = toPath;
    
    BOOL isExist = [fileManager fileExistsAtPath:fpath];
    if (!isExist) {
        return;
    } else {
        BOOL copySuccessed = [fileManager copyItemAtPath:fpath toPath:tpath error:nil];
        copySuccessed ? iHDINFO(@"copy file successful") : iHDINFO(@"copy file failed");
    }
}

+(NSArray *)searchFile:(NSString *)strFolder withSuffix:(NSString *)strSuffix
{
    NSString *strPath = [NSString stringWithFormat:@"%@/%@",[iHFileManager getDocumentPath],strFolder];
    NSError *err;
    NSArray *arrSearchFile = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strPath error:&err];
    NSMutableArray *muArrSearchFile = [NSMutableArray array];
    for (NSString * content in arrSearchFile) {
        if([[content componentsSeparatedByString:strSuffix] count]>1)
            [muArrSearchFile addObject:content];
    }
    return (NSArray *)muArrSearchFile;
}

+ (NSArray *)contentsOfDirectoryUnderFolder:(NSString *)folerName {
    NSString *strPath = [NSString stringWithFormat:@"%@/%@",[iHFileManager getDocumentPath],folerName];
    NSError *err;
    NSArray *arrSearchFile = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strPath error:&err];
    return arrSearchFile;
}


@end
