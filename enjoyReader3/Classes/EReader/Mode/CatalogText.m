//
//  CatalogText.m
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "CatalogText.h"
#import "ReaderDataSource.h"
static CatalogText *cata;
static NSString *TextStr;
static NSString *bookName;
static NSArray * chapterArr;//目录数组
//static int bookNumber;
@implementation CatalogText
+(id)siged{
    if (cata==nil) {
        cata = [[CatalogText alloc] init];
    }
    return cata;
}


-(void)loadTextWithBookID:(NSString *)bookID{
    
    
    bookName = bookID;
}
-(NSString *)bookPath{
    NSArray *cacesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [cacesPath objectAtIndex:0];
    NSString *bookPath = [documentsDirectory stringByAppendingPathComponent:@"book"];
    return bookPath;
}
/**
 *  添加文件
 *
 *  @param name 文件名称
 *  @param con  内容
 */
//TODO: 修改后此处可以删除 
-(void)creatTextName:(NSString *)name context:(NSString *)con{
    NSString *bookPath = [self bookPath];
    NSString *filePath= [bookPath stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *fileContent = con;
    NSData *fileData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
}
-(NSString *)getBookName{
    return bookName;
}
-(NSUInteger)NumBook{
    
    NSUInteger num =[ReaderDataSource shareInstance].totalChapter;
    return num;//TODO: 修改获取目录中章节数
}

@end
