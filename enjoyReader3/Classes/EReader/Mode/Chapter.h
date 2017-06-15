//
//  Chapter.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/11.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject
/**
 *  单例
 *
 *  @return 实例
 */
+ (Chapter *)shareInstance;



-(void)ChapterUrl:(NSString *)ChapterUrl;

//得到当前章节UrlMD5加密后的字符串
-(NSString *)getChapterUrlMd5;

//得带当前章节的Url
-(NSString *)getChapterUrl;

//得到当前章节的title
-(NSString *)getChapterTitle;

//得到所有章节的数组
-(NSArray*)getChapters;

//得到有标记颜色的目录数组
-(void)getListArray;
-(NSMutableArray*)getListChapterArray;
// *  @return 当前源的章节路径
-(NSString *)getChapterFilePath;

//得到目录标题
-(NSMutableArray *)getTitleArr;
// 第X章是否被下载
-(BOOL)isDownThisChapter:(NSInteger)index;


-(void)updateDownLoadArr;

-(void)updateAllchapters;

-(NSArray*)getAllchaptersArr;

-(NSMutableDictionary*)getdownLoadArr;
@end
