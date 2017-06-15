//
//  E_ReaderDataSource.m
//  E_Reader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ReaderDataSource.h"
#import "CommonManager.h"
#import "CatalogText.h"
#import "HUDView.h"
#import "BookInfo.h"

@implementation ReaderDataSource

+ (ReaderDataSource *)shareInstance{
    
    static ReaderDataSource *dataSource;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dataSource = [[ReaderDataSource alloc] init];
    });
    return dataSource;
}



- (instancetype)init{
    
    self = [super init];
    
    _currentChapterIndex = 0;
    
    return self;
}

/**
 *  章节跳转
 *
 *  @param clickChapter 跳转指定章节数
 *
 *  @return 该章节
 */
- (EveryChapter *)openChapter:(NSInteger)clickChapter{
    //先判断本地有没有此章节
    
    
    _currentChapterIndex = clickChapter;
    
    EveryChapter *chapter = [[EveryChapter alloc] init];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[[BookInfo siged] getBookPath],[[BookSource shareInstance] getSourceID]];
    
    
    NSString *cpContent = [NSMutableString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/chaptersInfo.txt",filePath] encoding:NSUTF8StringEncoding error:NULL];//内容
    cpContent = [WXYClassMethodsViewController decode:cpContent];
    
    NSArray *ChaptersArr = [WXYClassMethodsViewController stringToJSON:cpContent];
    
//    NSArray *ChaptersArr = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/chaptersInfo.txt",filePath]];
    
//    找到对应的章节的url
    NSDictionary *Dic = ChaptersArr [clickChapter];
    NSString *chapterUrl = [NSString stringWithFormat:@"%@",[Dic objectForKey:@"link"]];
    
    NSString *urlStrMd5 = [NSString stringWithFormat:@"%@.txt",[WXYClassMethodsViewController md5:chapterUrl]];
    
    
    BOOL isHaveChapter = [FileOperation fileExists:urlStrMd5 AtPath:filePath];
    
    if (isHaveChapter ==YES) {
        //有本章节
        NSString *chapterPath = [NSString stringWithFormat:@"%@/%@",filePath,urlStrMd5];
        
        NSString *cpContent = [NSMutableString stringWithContentsOfFile:chapterPath encoding:NSUTF8StringEncoding error:NULL];
        //解密
        chapter.chapterContent = [WXYClassMethodsViewController decode:cpContent];

    }else{
            //没有此章节
            NSString *PlatformUrl = [NSString stringWithFormat:@"%@%@",KBASSUrl,KChapter];
            
            NSArray *chapterArray = [[Chapter shareInstance] getChapters];
            
            NSDictionary *params = @{@"url":[chapterArray[clickChapter] objectForKey:@"link"]};
            
            [XYNetworking POST:PlatformUrl params:params success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSString *ret = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ret"]];
                if ([ret isEqualToString:@"0"]) {
                    
                    
                    NSDictionary *dic = [[responseObject objectForKey:@"data"] objectForKey:@"chapter"];
                    
                    NSString *cpContent =[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"chapter"] objectForKey:@"body"]];
                    
                    if ([[dic allKeys] containsObject:@"cpContent"]) {
                        cpContent = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"chapter"] objectForKey:@"cpContent"]];
                    }
                   
                    chapter.chapterContent = cpContent;
                    
                }
                
               
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                
                MyNSLog("error:%@",error);
                
            }];
        
        
    }
    return chapter;
    
    
    }



    
/**a
 *  通过传入id来获取章节信息
 *
 *  @return 章节类
 */
- (EveryChapter *)openChapter{
    
    NSUInteger index = [CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]];
    
    _currentChapterIndex = index;
    
    EveryChapter *chapter = [[EveryChapter alloc] init];
    
    NSArray *cacesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [cacesPath objectAtIndex:0];
    NSString *bookPath = [documentsDirectory stringByAppendingPathComponent:@"book"];
    NSString *bName = [NSString stringWithFormat:@"%@%d.txt",[[CatalogText siged] getBookName],0];
    NSString *filePath= [bookPath stringByAppendingPathComponent:bName];
    chapter.chapterContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    //    chapter.chapterContent = [CatalogText getCatalog][0];
    return chapter;
}

- (EveryChapter *)openChapterWithChapterContent:(NSString *)chapterContent{
    
    EveryChapter *chapter = [[EveryChapter alloc] init];

    chapter.chapterContent = chapterContent;

    return chapter;
}






/**
 *  打开得页数
 *
 *  @return 返回页数
 */
- (NSUInteger)openPage{
    
    NSUInteger index = [CommonManager Manager_getPageBefore:[[BookInfo siged] getBookID]];
    return index;
    
}

/**
 *  获得下一章内容
 *
 *  @return 章节类
 */
- (EveryChapter *)nextChapter{
    //TODO: 
    if (_currentChapterIndex >= _totalChapter) {
        [HUDView showMsg:@"没有更多内容了" inView:nil];
        return nil;
        
    }else{
        _currentChapterIndex++;
        
         MyNSLog("------现在是第%lu章",(unsigned long)_currentChapterIndex);
        EveryChapter *chapter = [self openChapter:_currentChapterIndex];
//        chapter.chapterContent = readTextData(_currentChapterIndex);
        
    
        return chapter;
        
    }
    
}
    
/**
 *  获得上一章内容
 *
 *  @return 章节类
 */
- (EveryChapter *)preChapter{
    
    if (_currentChapterIndex <= 0) {
        [HUDView showMsg:@"已经是第一页了" inView:nil];
        return nil;
        
    }
    else{
        _currentChapterIndex --;

        MyNSLog("------现在是第%lu章",(unsigned long)_currentChapterIndex);
        EveryChapter *chapter =[self openChapter:_currentChapterIndex];
//        chapter.chapterContent = readTextData(_currentChapterIndex);
        
        
        
        return chapter;
    }
}
/**
 *  获得全文
 */
- (void)resetTotalString{
    
    _totalString = [NSMutableString string];
    _everyChapterRange = [NSMutableArray array];
    
    for (int i = 1; i <  INT_MAX; i ++) {
        
        if (readTextData(i) != nil) {
            
            NSUInteger location = _totalString.length;
            [_totalString appendString:readTextData(i)];
            NSUInteger length = _totalString.length - location;
            NSRange chapterRange = NSMakeRange(location, length);
            [_everyChapterRange addObject:NSStringFromRange(chapterRange)];
            
            
        }else{
            break;
        }
    }
    
}
/**
 *  获得指定章节的第一个字在整篇文章中的位置
 *
 *  @param page 指定章节
 *
 *  @return 位置
 */
- (NSInteger)getChapterBeginIndex:(NSInteger)page{
    
    NSInteger index = 0;
    for (int i = 1; i < page; i ++) {
        
        if (readTextData(i) != nil) {
            
            index += readTextData(i).length;
            // NSLog(@"index == %ld",index);
            
        }else{
            break;
        }
    }
    return index;
}
/**
 *  全文搜索
 *
 *  @param keyWord 要搜索的关键字
 *
 *  @return 搜索的关键字所在的位置
 */
- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord{
    //关键字为空 则返回空数组
    if (keyWord == nil || [keyWord isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *searchResult = [[NSMutableArray alloc] initWithCapacity:0];//内容
    NSMutableArray *whichChapter = [[NSMutableArray alloc] initWithCapacity:0];//内容所在章节
    NSMutableArray *locationResult = [[NSMutableArray alloc] initWithCapacity:0];//搜索内容所在range
    NSMutableArray *feedBackResult = [[NSMutableArray alloc] initWithCapacity:0];//上面3个数组集合
    
    
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < keyWord.length; i ++) {
        
        [blankWord appendString:@" "];
    }
    
    //一次搜索20条
    for (int i = 0; i < 20; i++) {
        
        if ([_totalString rangeOfString:keyWord options:1].location != NSNotFound) {
            
            NSInteger newLo = [_totalString rangeOfString:keyWord options:1].location;
            NSInteger newLen = [_totalString rangeOfString:keyWord options:1].length;
            // NSLog(@"newLo == %ld,, newLen == %ld",newLo,newLen);
            int temp = 0;
            for (int j = 0; j < _everyChapterRange.count; j ++) {
                if (newLo > NSRangeFromString([_everyChapterRange objectAtIndex:j]).location) {
                    temp ++;
                }else{
                    break;
                }
                
            }
            
            [whichChapter addObject:[NSString stringWithFormat:@"%d",temp]];
            [locationResult addObject:NSStringFromRange(NSMakeRange(newLo, newLen))];
            
            NSRange searchRange = NSMakeRange(newLo, [self doRandomLength:newLo andPreOrNext:NO] == 0?newLen:[self doRandomLength:newLo andPreOrNext:NO]);
            
            NSString *completeString = [[_totalString substringWithRange:searchRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [searchResult addObject:completeString];
            
            
            
            [_totalString replaceCharactersInRange:NSMakeRange(newLo, newLen) withString:blankWord];
            MyNSLog("++++++++++++%d+++++++++++",i);
        }else{
            break;
        }
    }
    
    [feedBackResult addObject:searchResult];
    [feedBackResult addObject:whichChapter];
    [feedBackResult addObject:locationResult];
    return feedBackResult;
    
}

- (NSInteger)doRandomLength:(NSInteger)location andPreOrNext:(BOOL)sender
{
    //获取1到x之间的整数
    if (sender == YES) {
        NSInteger temp = location;
        NSInteger value = (arc4random() % 13) + 5;
        location -=value;
        if (location<0) {
            location = temp;
        }
        
        return location;
        
    }
    else
    {
        
        NSInteger value = (arc4random() % 20) + 20;
        if (location + value >= _totalString.length) {
            value = 0;
        }else{
            
        }
        
        return value;
        
    }
    
    
}
//TODO: 修改数据库读取 
static NSString *readTextData(NSUInteger index){
    

  __block  NSString *bodyContent;
   
    if(index<[[CatalogText siged] NumBook]){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",[[BookInfo siged] getBookPath],[[BookSource shareInstance] getSourceID]];
        
        NSString *cpContent = [NSMutableString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/chaptersInfo.txt",filePath] encoding:NSUTF8StringEncoding error:NULL];//内容
        cpContent = [WXYClassMethodsViewController decode:cpContent];
        
        NSArray *ChaptersArr = [WXYClassMethodsViewController stringToJSON:cpContent];
        
//        NSArray *ChaptersArr = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/chaptersInfo.txt",filePath]];
        
        //    找到对应的章节的url
        NSDictionary *Dic = ChaptersArr [index];
       
        NSString *chapterUrl = [NSString stringWithFormat:@"%@",[Dic objectForKey:@"url"]];
        
        NSString *urlStrMd5 = [WXYClassMethodsViewController md5:chapterUrl];
        
        BOOL isHaveChapter = [FileOperation fileExists:urlStrMd5 AtPath:filePath];
        
        
    if (isHaveChapter ==YES) {
        //加载本地
        NSString *chapterPath = [NSString stringWithFormat:@"%@/%@.txt",filePath,urlStrMd5];
        
        NSString *cpContent = [NSMutableString stringWithContentsOfFile:chapterPath encoding:NSUTF8StringEncoding error:NULL];
        //解密
        bodyContent = [WXYClassMethodsViewController decode:cpContent];
        
        return bodyContent;
        
    }else{
        //网络请求
        
        NSString *PlatformUrl = [NSString stringWithFormat:@"%@%@",KBASSUrl,KChapter];

        NSArray *chapterArray = [[Chapter shareInstance] getChapters];
        
        NSDictionary *params = @{@"url":[chapterArray[index] objectForKey:@"link"]};
        [XYNetworking POST:PlatformUrl params:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *ret = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ret"]];
            if ([ret isEqualToString:@"0"]) {
                
                
                NSDictionary *dic = [[responseObject objectForKey:@"data"] objectForKey:@"chapter"];
                
                bodyContent =[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"chapter"] objectForKey:@"body"]];
                
                if ([[dic allKeys] containsObject:@"cpContent"]) {
                    bodyContent = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"chapter"] objectForKey:@"cpContent"]];
                }
                
                
            }
            
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
            MyNSLog("error:%@",error);
            
            
        }];

        return bodyContent;
    }
        
}
    return nil;

}
@end
