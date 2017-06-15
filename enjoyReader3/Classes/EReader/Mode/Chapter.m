//
//  Chapter.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/11.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "Chapter.h"
#import "CommonManager.h"
#import "BookInfo.h"

static NSString *chapterUrl;
static NSArray * hadDownLoadArr;
static NSArray *allchaptersArr;
static NSMutableDictionary *allDownLoadChapter;
static NSMutableArray * listArray;
@implementation Chapter

+ (Chapter *)shareInstance{

    
    static Chapter *chapter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        chapter = [[Chapter alloc] init];
        
        
    });
    return chapter;


}

-(void)ChapterUrl:(NSString *)ChapterUrl{

    

    chapterUrl = ChapterUrl;



}

-(NSString *)getChapterUrlMd5{

    NSString *UrlMd5 = [WXYClassMethodsViewController md5:chapterUrl];


    return UrlMd5;

}

//得带当前章节的Url
-(NSString *)getChapterUrl{

    return chapterUrl;


}

//得到当前章节的title
-(NSString *)getChapterTitle{
    NSUInteger index = [CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]];
    
    NSArray *titleArr = [self getTitleArr];
    NSString *chapterTitle =[[NSString alloc]init];
    if (titleArr.count < index) {
        
        chapterTitle = [titleArr lastObject];
    }else{
        chapterTitle = titleArr[index];
    }
   


    return chapterTitle;

}

-(NSUInteger)getChapterNumber{

    NSUInteger b = 0;
    NSArray *source = [self getChapters];
    
    for (NSUInteger i = 0; i < [self getChapters].count; i++) {
        
        NSString *linkStr = [self getChapterUrl];
        
        if ([[source[i] objectForKey:@"link"] isEqualToString:linkStr]) {
            
            b = (NSInteger)i;
            break;
            
        }

    }

    return b;

}
//得到所有章节目录的数组
-(NSArray *)getChapters{
    
    NSString *chapterPath = [NSString stringWithFormat:@"%@/%@/chaptersInfo.txt",[[BookInfo siged] getBookPath],[CommonManager Manager_getSourceID]];

    NSString *cpContent = [NSMutableString stringWithContentsOfFile:chapterPath encoding:NSUTF8StringEncoding error:NULL];//内容
    cpContent = [WXYClassMethodsViewController decode:cpContent];
    
    NSArray *chaptersArr = [WXYClassMethodsViewController stringToJSON:cpContent];
//    NSArray *chaptersArr = [NSArray arrayWithContentsOfFile:chapterPath];
    
    return chaptersArr;

}
/**
 *  获取当前源的章节路径
 *
 *  @return 当前源的章节路径
 */
-(NSString *)getChapterFilePath{


    NSString *chapterPath = [NSString stringWithFormat:@"%@/%@",[[BookInfo siged] getBookPath],[CommonManager Manager_getSourceID]];
    
    return chapterPath;


}

/**
 *  第X章是否被下载
 *
 *  @param index 第X章
 *
 *  @return 是或否  
 */
-(BOOL)isDownThisChapter:(NSInteger)index{


    //获得已经下载的章节字典 {url：key}
    NSMutableDictionary *chapterDic= [self getdownLoadArr];
    
    NSString *fileName =[NSString stringWithFormat:@"%@.txt",[WXYClassMethodsViewController md5:[[[Chapter shareInstance] getAllchaptersArr][index] objectForKey:@"link"]]];
    
    NSString *str = [chapterDic objectForKey:fileName];
    
    if (str ==nil) {
        
        return NO;
    }
    
    return YES;
   
    
}
//目录颜色
-(void)getListArray{

    listArray = [[NSMutableArray alloc]init];
    
    NSArray *chaptersArray = [self getChapters];
    
    for (int i =0 ; i<chaptersArray.count; i++) {
        
       BOOL ishave =  [self isDownThisChapter:i];
        
        if (ishave ==YES) {
            
            [listArray addObject:@"#000000"];
            
        }else{
            
            [listArray addObject:@"#999999"];
            
        }
    
    }

}
-(NSMutableArray*)getListChapterArray{

    [self getListArray];
    return listArray;

}
//得到所有章节目录名称
-(NSMutableArray *)getTitleArr {

    NSArray *chapterArr = [self getChapters];
    NSMutableArray *titleArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<chapterArr.count; i++) {
        NSString *chapterTitle = [chapterArr[i] objectForKey:@"title"];
        [titleArr addObject:chapterTitle];
        
    }

    return titleArr;



}
-(void)updateAllchapters{


    NSString *chapterPath = [NSString stringWithFormat:@"%@/%@/chaptersInfo.txt",[[BookInfo siged] getBookPath],[CommonManager Manager_getSourceID]];
    
    NSString *cpContent = [NSMutableString stringWithContentsOfFile:chapterPath encoding:NSUTF8StringEncoding error:NULL];//内容
    cpContent = [WXYClassMethodsViewController decode:cpContent];
    
    allchaptersArr = [WXYClassMethodsViewController stringToJSON:cpContent];
    
//    allchaptersArr = [NSArray arrayWithContentsOfFile:chapterPath];



}

-(NSArray*)getAllchaptersArr{

    return allchaptersArr;

}

-(void)updateDownLoadArr{

    NSString *chapterPath = [NSString stringWithFormat:@"%@/%@",[[BookInfo siged] getBookPath],[CommonManager Manager_getSourceID]];
    allDownLoadChapter = [[NSMutableDictionary alloc]init];
    
    hadDownLoadArr = [FileOperation  getAllFileName:chapterPath];
    for (int i =0; i < hadDownLoadArr.count; i++) {
        NSString * key = hadDownLoadArr[i];
        [allDownLoadChapter setValue:@"1" forKey:key];
        
    }

}

-(NSMutableDictionary*)getdownLoadArr{

    return allDownLoadChapter;

}

@end
