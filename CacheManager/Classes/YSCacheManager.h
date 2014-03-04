//
//  YSCacheManager.h
//  CacheManager
//
//  Created by sxzw on 14-3-4.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#ifndef YSCacheManager_H
#define YSCacheManager_H
#if !__has_feature( objc_arc )
    #error This Class Need ARC.
#endif
#import <Foundation/Foundation.h>

//
//  CacheManager File Name & Saved Path
//
#define CACHE_MANAGER_FILE_NAME @"YSCacheManager.archiver"
#define CACHE_MANAGER_FILE_FULL_PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:CACHE_MANAGER_FILE_NAME]

//
//  Definition Cache Type Enum
//
typedef enum
{
    YSCacheFileTypeNone,
    YSCacheFileTypeVideo,
    YSCacheFileTypeAudio,
    YSCacheFileTypeImage,
    YSCacheFileTypeDocument
}YSCacheFileType;

@interface YSCacheManager : NSObject

+ (NSMutableDictionary *)dicFromCacheManagerArchiverFile;

#pragma mark - Add
+ (BOOL)addCacheFilePath:(NSString *)path type:(YSCacheFileType)type context:(id<NSCoding>)context;

#pragma mark - Calculate
+ (UInt64)bytesLengthForAllCacheFiles;
+ (UInt64)bytesLengthForAllCacheFileOfType:(YSCacheFileType)type;

#pragma mark - List

#pragma mark - Delete
+ (BOOL)deleteAllCacheFiles;
+ (BOOL)deleteAllCacheFilesOfType:(YSCacheFileType)type;
+ (BOOL)deleteCacheFileOfType:(YSCacheFileType)type withPath:(NSString *)path;

@end
#endif