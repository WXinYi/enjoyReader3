//
//  draftSingle.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/16.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "draftSingle.h"
#import "MyFMDB.h"
@implementation draftSingle
+ (draftSingle *)shareInstance{
    
    static draftSingle *draftSing;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        draftSing = [[draftSingle alloc] init];
    
    });
    return draftSing;
}

//创建草稿文件夹
-(void)creatDraftFile{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/draft", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    } else {
        
        NSLog(@"FileDir is exists.");
        
    }

    

}
-(NSString *)getDraftPath{
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/draft", pathDocuments];
    
    return createPath;
}



//得到所有信息

-(NSArray *)getAllDraftInfo{
   
    NSArray *files = [[MyFMDB instance] getAllBrandwithTestType:draftlist];
    
    return files;
}


/**
 *  通过标题获取草稿内容
 *
 *  @param fileName 文章标题
 *
 *  @return 内容
 */
-(NSString *)getDraftContentwithmd5str:(NSString *)md5string{
   
    NSString *path = [self getDraftPath];
    
    NSString *fileString =  [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",md5string]];
    
    NSString *htmlParam = [NSString stringWithContentsOfFile:fileString encoding:NSUTF8StringEncoding error:nil];
    
    return htmlParam;

}


//获取创建时间
-(NSString *)getnowdata{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

/**
 *  保存新建的草稿
 *
 *  @param titleName title的标题
 *  @param content   内容
 */
-(void)saveDraftContentWithTitleName:(NSString *)titleName withcontent:(NSString *)content{

    
    //沙河保存内容
    NSString *timestr = [self getnowdata];

    NSString * titlestr = [NSString stringWithFormat:@"%@%@",titleName,timestr];
    
    NSString *md5str = [WXYClassMethodsViewController md5:titlestr];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *createPath = [NSString stringWithFormat:@"%@",[[draftSingle shareInstance] getDraftPath]];
    
    NSString *path =  [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",md5str]];

    
    [fileManager createFileAtPath:path contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];

    //数据库新建一条数据

    NSDictionary *dic  = @{@"title":titleName,@"md5string":md5str};
    
    [[MyFMDB instance] insertTableWithTestType:draftlist andDict:dic andcreatetime:timestr];
    
}
/**
 *更新草稿
 *
 *  @param md5Str    已有的MD5
 *  @param titleName 标题
 *  @param content   内容
 */
-(void)updataDraftContentWithmd5Str:(NSString *)md5Str WithTitleName:(NSString *)titleName withcontent:(NSString *)content{
   
    //更新沙河内容
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    NSString *createPath = [NSString stringWithFormat:@"%@",[[draftSingle shareInstance] getDraftPath]];
    
    NSString *path =  [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",md5Str]];
    
    
    [fileManager createFileAtPath:path contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
   //更新数据库
    
    NSDictionary *dic =  [[MyFMDB instance] selectAllWithTestType:draftlist withmd5string:md5Str];
    
    NSString *title = [dic objectForKey:@"title"];
    
    if (![titleName isEqualToString:title]) {
        
        [[MyFMDB instance] updataTableWithTestType:draftlist updatatitle:titleName withmd5string:md5Str];
    }
    
}


/**
 *  删除草稿
 *
 *  @param md5String   传入MD5String
 */
-(void)deleteDraftWithMd5:(NSString *)md5String{

    //删除沙河内容
    NSString *createPath = [NSString stringWithFormat:@"%@",[[draftSingle shareInstance] getDraftPath]];
    
    if ([FileOperation fileExists:[NSString stringWithFormat:@"%@.txt",md5String] AtPath:createPath]) {
        
        [FileOperation  removeFile:[NSString stringWithFormat:@"%@.txt",md5String] AtPath:createPath];
        
    }

    //删除数据库响应内容

    [[MyFMDB instance] deleteTableWithTestType:draftlist withtitle:nil orWithmd5string:md5String];

}



@end
