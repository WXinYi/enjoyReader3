//
//  E_CommonManager.m
//  E_Reader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "CommonManager.h"
#import "E_ContantFile.h"
#import "Mark.h"
#import "CatalogText.h"
@implementation CommonManager

/**
 *  获得主题背景
 *
 *  @return 主题背景id
 */
+ (NSInteger)Manager_getReadTheme{
    
    NSString *themeID = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Theme",[[BookInfo siged] getBookID]]];
    
    if (themeID == nil) {
        
        return 1;
        
    }else{
        
        return [themeID integerValue];
        
    }
    
}

/**
 *  保存主题ID
 *
 *  @param currentThemeID 主题ID
 */
+ (void)saveCurrentThemeID:(NSInteger)currentThemeID{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentThemeID) forKey:[NSString stringWithFormat:@"%@Theme",[[BookInfo siged] getBookID]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/**
 *  获得之前看的页码
 *
 *  @return 页码数
 */
+ (NSUInteger)Manager_getPageBefore:(NSString *)bookname{
    
    NSString *pageID = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Page",bookname]];
    
    if (pageID == nil) {
        return 0;
    }else{
        return [pageID integerValue];
    }
    
}
/**
 *  保存页码
 *
 *  @param currentChapter 现页码
 */
+ (void)saveCurrentPage:(NSInteger)currentPage{
    [[NSUserDefaults standardUserDefaults] setValue:@(currentPage) forKey:[NSString stringWithFormat:@"%@Page",[[BookInfo siged] getBookID]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  获得之前看的章节
 *
 *  @return 章节数
 */
+ (NSUInteger)Manager_getChapterBefore:(NSString *)bookname
{
    NSString *chapterID = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@OPEN",bookname]];
    if (chapterID == nil) {
        return 0;
    }else{
        NSUInteger acc = [chapterID integerValue];
        return acc;
        
    }
    
}
/**
 *  保存章节
 *
 *  @param currentChapter 现章节
 */
+ (void)saveCurrentChapter:(NSInteger)currentChapter{
    [[NSUserDefaults standardUserDefaults] setValue:@(currentChapter) forKey:[NSString stringWithFormat:@"%@OPEN",[[BookInfo siged] getBookID]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


/**
 *  获得字号
 *
 *  @return 字号大小
 */
+ (NSUInteger)fontSize
{
    NSUInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@FONT_SIZE",[[BookInfo siged] getBookID]]];
    if (fontSize == 0) {
        fontSize = 20;
    }
    return fontSize;
}

+ (void)saveFontSize:(NSUInteger)fontSize
{
    [[NSUserDefaults standardUserDefaults] setValue:@(fontSize) forKey:[NSString stringWithFormat:@"%@FONT_SIZE",[[BookInfo siged] getBookID]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//#pragma mark 保存源
///**
// *  保存页码
// *
// *  @param currentChapter 现页码
// */
//+ (void)saveSource:(NSString *)currentSource{
//
//    [[NSUserDefaults standardUserDefaults] setValue:@(currentSource) forKey:[NSString stringWithFormat:@"%@SourceId",[[BookInfo siged] getBookID]]];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//
//}
//
//
//
///**
// *  获得之前看的页码
// *
// *  @return 页码数
// */
//+ (NSString *)Manager_getSourceIdBefore:(NSString *)bookname{
//
//
//
//
//
//
//
//
//
//}


#pragma mark- 书签保存
/**
 *  保存书签
 *有书签就删除  没有就添加
 *  @param currentChapter 当前章节
 *  @param chapterRange   当前页起始的一段文字的range
 */
+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent{
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    Mark *eMark = [[Mark alloc] init];
    eMark.markRange   = NSStringFromRange(chapterRange);
    eMark.markChapter = [NSString stringWithFormat:@"%ld",currentChapter];

    eMark.markContent = [chapterContent substringWithRange:chapterRange];
    eMark.markTime    = locationString;
    
    if (![self checkIfHasBookmark:chapterRange withChapter:currentChapter]) {//没加书签
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@epubBookName",[[BookInfo siged] getBookID]]];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (oldSaveArray.count == 0) {
            
            NSMutableArray *newSaveArray = [[NSMutableArray alloc] init];
            [newSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:newSaveArray] forKey:[NSString stringWithFormat:@"%@epubBookName",[[BookInfo siged] getBookID]]];
            
        }else{
            
            [oldSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:[NSString stringWithFormat:@"%@epubBookName",[[BookInfo siged] getBookID]]];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{//有书签
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@epubBookName",[[BookInfo siged] getBookID]]];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0 ; i < oldSaveArray.count; i ++) {
            
            Mark *e = (Mark *)[oldSaveArray objectAtIndex:i];
            
            if (((NSRangeFromString(e.markRange).location >= chapterRange.location) &&
                 (NSRangeFromString(e.markRange).location < chapterRange.location + chapterRange.length)) &&
                ([e.markChapter isEqualToString:[NSString stringWithFormat:@"%ld",(long)currentChapter]])) {
                
                [oldSaveArray removeObject:e];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray]
                                                          forKey:[NSString stringWithFormat:@"%@epubBookName", [[BookInfo siged] getBookID]]];
                
            }
        }
    }
    
}
/**
 *  检查当前页是否加了书签
 *
 *  @param currentRange 当前range
 *  @param currentChapter
 *  @return 是否加了书签
 */
+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@epubBookName",[[BookInfo siged] getBookID]]];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    int k = 0;
    for (int i = 0; i < oldSaveArray.count; i ++) {
        Mark *e = (Mark *)[oldSaveArray objectAtIndex:i];
        
        if ((NSRangeFromString(e.markRange).location >= currentRange.location) &&
            (NSRangeFromString(e.markRange).location < currentRange.location + currentRange.length) &&
            [e.markChapter isEqualToString:[NSString stringWithFormat:@"%ld",(long)currentChapter]]) {
            k++;
        }else{
            // k++;
        }
    }
    if (k >= 1) {
        return YES;
    }else{
        return NO;
    }
}
/**
 *  获得书签数组
 *
 *  @return 书签数组
 */
+ (NSMutableArray *)Manager_getMark{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@epubBookName",[[BookInfo siged] getBookID]]];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    data = nil;
    if (oldSaveArray.count == 0) {
        return nil;
    }else{
        return oldSaveArray;
        
    }
    
}


/**
 *  保存源
 *
 *  @param  保存现在的源
 */
+ (void)saveSourceID:(NSInteger)SourceID{
    [[NSUserDefaults standardUserDefaults] setValue:@(SourceID) forKey:[NSString stringWithFormat:@"%@SourceID",[[BookInfo siged] getBookID]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 *  获得之前使用的源
 *
 *  @return 源id
 */
+ (NSString *)Manager_getSourceID{
    
    NSString *sourceID = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@SourceID",[[BookInfo siged] getBookID]]];
    
    NSString *cpContent = [NSMutableString stringWithContentsOfFile:[[BookSource shareInstance] getSourceInfoPath] encoding:NSUTF8StringEncoding error:NULL];//内容
    cpContent = [WXYClassMethodsViewController decode:cpContent];
    
    NSArray *arr = [WXYClassMethodsViewController stringToJSON:cpContent];
//     = [NSArray arrayWithContentsOfFile:[[BookSource shareInstance] getSourceInfoPath]];
    
    if (sourceID ==nil) {
        return [arr[0] objectForKey:@"id"];
    }
    else
        return sourceID;
    
}




@end
