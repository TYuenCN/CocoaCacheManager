//
//  YSCacheManager.m
//  CacheManager
//
//  Created by sxzw on 14-3-4.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

//
//  缓存信息字典内用到的Key
//
//#define KEY_4_PATH @"CacheFilePath"
//#define KEY_4_TYPE @"CacheFileType"
//#define KEY_4_CONTEXT @"CacheFileContext"

#import "YSCacheManager.h"

@interface YSCacheManager ()
+ (NSMutableDictionary *)dicFromCacheManagerArchiverFile;
@end

@implementation YSCacheManager

//
//  检查路径与文件是否存在，不存在则全部创建，并创建空的归档文件
//
+ (NSMutableDictionary *)dicFromCacheManagerArchiverFile
{
    NSError *err;
    NSMutableDictionary *cmDic;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //
    //  路径存在与否
    //
    if (![fm fileExistsAtPath:[CACHE_MANAGER_FILE_FULL_PATH stringByDeletingLastPathComponent] isDirectory:nil]) {
        BOOL mkDir = [fm createDirectoryAtPath:[CACHE_MANAGER_FILE_FULL_PATH stringByDeletingLastPathComponent]
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:&err];
        if (!mkDir) {
            NSLog(@"Create \"%@\" Was Wrong.", CACHE_MANAGER_FILE_FULL_PATH);
            return cmDic;
        }
    }
    
    //
    //  缓存管理字典的归档文件是否存在
    //
    if( ![fm fileExistsAtPath:CACHE_MANAGER_FILE_FULL_PATH] )
    {
        cmDic = [NSMutableDictionary dictionary];
        NSData *cmDicData = [NSKeyedArchiver archivedDataWithRootObject:cmDic];
        BOOL mkFl = [fm createFileAtPath:CACHE_MANAGER_FILE_FULL_PATH contents:cmDicData attributes:nil];
        if (!mkFl) {
            NSLog(@"Create \"%@\" Was Wrong.", CACHE_MANAGER_FILE_FULL_PATH);
            return cmDic;
        }
    }else{
        cmDic = [NSKeyedUnarchiver unarchiveObjectWithFile:CACHE_MANAGER_FILE_FULL_PATH];
    }
    
    return cmDic;
}

+ (BOOL)saveCacheManagerFileArchiver:(NSDictionary *)cacheManagerDic
{
    if ([NSKeyedArchiver archiveRootObject:cacheManagerDic toFile:CACHE_MANAGER_FILE_FULL_PATH]) {
        return YES;
    }else{
        NSLog(@"Save Cache File, To Archiver File \"%@\" Was Wrong.", CACHE_MANAGER_FILE_FULL_PATH);
    }
    
    return NO;
}

//
//          {
//              YSCacheFileType:    {
//                                                  CacheFilePath(Key)  :  Context(Value),
//                                              },
//              YSCacheFileType:    {
//                                                  CacheFilePath:(Key), Context:(Value)
//                                              }
//          }
//
#pragma mark - Add
+ (BOOL)addCacheFilePath:(NSString *)path type:(YSCacheFileType)type context:(id<NSCoding>)context
{
    NSMutableDictionary *cmDic = [YSCacheManager dicFromCacheManagerArchiverFile];
    NSMutableDictionary *subTypeDic = [cmDic objectForKey:[NSNumber numberWithInt:type]];
    if (!subTypeDic) {
        subTypeDic = [NSMutableDictionary dictionary];
        [cmDic setObject:subTypeDic forKey:[NSNumber numberWithInt:type]];
    }
    
    //已经记录
    if ([subTypeDic objectForKey:path] != nil) {
        return FALSE;
    }else{
        if (context != nil) {
            [subTypeDic setObject:context forKey:path];
        }else{
            [subTypeDic setObject:@"" forKey:path];
        }
    }
    
    return [YSCacheManager saveCacheManagerFileArchiver:cmDic];
}

#pragma mark - Calculate
+ (UInt64)bytesLengthForAllCacheFiles
{
    UInt64 bytesLength = 0;
    NSMutableDictionary *cmDic = [YSCacheManager dicFromCacheManagerArchiverFile];
    
    NSError *attrErr;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for (NSString *key in cmDic) {
        NSDictionary *subTypeDic = [cmDic objectForKey:key];
        if (subTypeDic != nil) {
            for (NSString *subDicKey in subTypeDic) {
                if ([fm fileExistsAtPath:subDicKey]) {
                    NSDictionary *attr = [fm attributesOfItemAtPath:subDicKey error:&attrErr];
                    bytesLength += (UInt64)[[attr objectForKey:NSFileSize] unsignedLongLongValue];
                }
            }
        }
    }
    
    return bytesLength;
}
+ (UInt64)bytesLengthForAllCacheFileOfType:(YSCacheFileType)type
{
    UInt64 bytesLength = 0;
    NSMutableDictionary *cmDic = [YSCacheManager dicFromCacheManagerArchiverFile];
    NSMutableDictionary *subTypeDic = [cmDic objectForKey:[NSNumber numberWithInt:type]];
    if (subTypeDic == nil) {
        return 0;
    }
    
    //遍历
    NSError *attrErr;
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *key in subTypeDic) {
        if ([fm fileExistsAtPath:key]) {
            NSDictionary *attr = [fm attributesOfItemAtPath:key error:&attrErr];
            bytesLength += (UInt64)[[attr objectForKey:NSFileSize] unsignedLongLongValue];
        }
    }
    
    return bytesLength;
}

#pragma mark - List

#pragma mark - Delete
+ (BOOL)deleteAllCacheFiles
{
    NSMutableDictionary *cmDic = [YSCacheManager dicFromCacheManagerArchiverFile];
    for (id typeKey in cmDic) {
        NSMutableDictionary *subTypeDic = [cmDic objectForKey:typeKey];
        if (subTypeDic != nil) {
            NSMutableArray *files = [NSMutableArray array];
            for (NSString *key in subTypeDic) {
                [files addObject:key];
            }
            
            NSError *delErr;
            NSFileManager *fm = [NSFileManager defaultManager];
            for (int i = [files count] -1 ; i >= 0; i--) {
                if ([fm removeItemAtPath:[files objectAtIndex:i] error:&delErr]) {
                    [subTypeDic removeObjectForKey:[files objectAtIndex:i]];
                }else{
                    [subTypeDic removeObjectForKey:[files objectAtIndex:i]];
                    NSLog(@"Remove Item - %@, Has Wrong.", [files objectAtIndex:i]);
                }
            }
        }
    }
    
    return [YSCacheManager saveCacheManagerFileArchiver:cmDic];
}
+ (BOOL)deleteAllCacheFilesOfType:(YSCacheFileType)type
{
    NSMutableDictionary *cmDic = [YSCacheManager dicFromCacheManagerArchiverFile];
    NSMutableDictionary *subTypeDic = [cmDic objectForKey:[NSNumber numberWithInt:type]];
    
    if (subTypeDic == nil) {
        NSLog(@"None Type-%d's Cache File.", type);
        return FALSE;
    }
    
    NSMutableArray *files = [NSMutableArray array];
    for (NSString *key in subTypeDic) {
        [files addObject:key];
    }
    
    NSError *delErr;
    NSFileManager *fm = [NSFileManager defaultManager];
    for (int i = [files count] -1 ; i >= 0; i--) {
        if ([fm removeItemAtPath:[files objectAtIndex:i] error:&delErr]) {
            [subTypeDic removeObjectForKey:[files objectAtIndex:i]];
        }else{
            [subTypeDic removeObjectForKey:[files objectAtIndex:i]];
            NSLog(@"Remove Item - %@, Has Wrong.", [files objectAtIndex:i]);
        }
    }
    
    return [YSCacheManager saveCacheManagerFileArchiver:cmDic];
}
+ (BOOL)deleteCacheFileOfType:(YSCacheFileType)type withPath:(NSString *)path
{
    NSMutableDictionary *cmDic = [YSCacheManager dicFromCacheManagerArchiverFile];
    NSMutableDictionary *subTypeDic = [cmDic objectForKey:[NSNumber numberWithInt:type]];
    
    if (subTypeDic == nil) {
        NSLog(@"None Type-%d's Cache File.", type);
        return FALSE;
    }
    
    NSError *delErr;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([subTypeDic objectForKey:path]) {
        if ([fm removeItemAtPath:path error:&delErr]) {
            [subTypeDic removeObjectForKey:path];
        }else{
            [subTypeDic removeObjectForKey:path];
            NSLog(@"Remove Item - %@, Has Wrong.", path);
        }
    }
    
    return [YSCacheManager saveCacheManagerFileArchiver:cmDic];
}
@end
