//
//  CacheManagerTests.m
//  CacheManagerTests
//
//  Created by sxzw on 14-3-4.
//  Copyright (c) 2014年 YuenSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YSCacheManager.h"

@interface CacheManagerTests : XCTestCase

@end

@implementation CacheManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void)testAddCacheFilePath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSData *data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *docPath = [documentPath stringByAppendingPathComponent:@"test1.doc"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeDocument context:nil];
    
    data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    docPath = [documentPath stringByAppendingPathComponent:@"test2.doc"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeDocument context:nil];
    
    data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    docPath = [documentPath stringByAppendingPathComponent:@"test3.doc"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeDocument context:nil];
    
    data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    docPath = [documentPath stringByAppendingPathComponent:@"video1.mp4"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeVideo context:nil];
    
    data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    docPath = [documentPath stringByAppendingPathComponent:@"video2.mp4"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeVideo context:nil];
    
    data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    docPath = [documentPath stringByAppendingPathComponent:@"audio1.mp3"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeAudio context:nil];
    
    data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    docPath = [documentPath stringByAppendingPathComponent:@"audio2.mp3"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeAudio context:nil];
    
    data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    docPath = [documentPath stringByAppendingPathComponent:@"audio3.mp3"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeAudio context:nil];
    
    data = [@"TestDataString" dataUsingEncoding:NSUTF8StringEncoding];
    docPath = [documentPath stringByAppendingPathComponent:@"audio4.mp3"] ;
    [data writeToFile:docPath atomically:YES];
    [YSCacheManager addCacheFilePath:docPath type:YSCacheFileTypeAudio context:nil];
    
    NSLog(@"%@", [YSCacheManager dicFromCacheManagerArchiverFile]);
}

- (void)testBytesLengthForAllCacheFiles
{
    NSLog(@"BytesLengthForAllCacheFiles : %llu", [YSCacheManager bytesLengthForAllCacheFiles]);
}

- (void)testBytesLengthForAllCacheFileOfType
{
    NSLog(@"BytesLengthForAllCacheFileOfType-%d : %llu", YSCacheFileTypeDocument, [YSCacheManager bytesLengthForAllCacheFileOfType:YSCacheFileTypeDocument]);
    NSLog(@"BytesLengthForAllCacheFileOfType-%d : %llu", YSCacheFileTypeVideo, [YSCacheManager bytesLengthForAllCacheFileOfType:YSCacheFileTypeVideo]);
    NSLog(@"BytesLengthForAllCacheFileOfType-%d : %llu", YSCacheFileTypeAudio, [YSCacheManager bytesLengthForAllCacheFileOfType:YSCacheFileTypeAudio]);
}

- (void)testDeleteAllCacheFilesOfType
{
    [YSCacheManager deleteAllCacheFilesOfType:YSCacheFileTypeVideo];
    NSLog(@"%@", [YSCacheManager dicFromCacheManagerArchiverFile]);
}

- (void)testDeleteAllCacheFiles
{
    [YSCacheManager deleteAllCacheFiles];
    NSLog(@"%@", [YSCacheManager dicFromCacheManagerArchiverFile]);
}
@end
