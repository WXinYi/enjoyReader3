//
//  CacheSize.m
//  PersonalCenter
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "CacheSize.h"

@implementation CacheSize
//单利
+ (instancetype)defaultCalculateFileSize
{
    CacheSize *cache =nil;
    @synchronized(self)  {
        if (!cache) {
            cache   =  [[self alloc]init];;
        }
    }
    return cache;
}

//计算单个文件大小返回值是M

- (float)fileSizeAtPath:(NSString *)path
{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        // 返回值是字节 B K M
        return size/1024.0/1024.0;
    }
    return 0;
}

//计算目录大小

- (float)folderSizeAtPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 计算单个文件大小
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        // folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0.0;
}
//清理缓存文件

//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用。

- (void)clearCache:(NSString *)path clearBlock:(void(^)(NSString*))a
{
    self.onResult=a;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            if ([fileName isEqualToString:@".com.apple.mobile_container_manager.metadata.plist"]) {
            continue;
        }
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    self.onResult(@"清除缓存");
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
//    });
    // SDImageCache 自带缓存
    //[[SDImageCache sharedImageCache] cleanDisk];
}
@end
