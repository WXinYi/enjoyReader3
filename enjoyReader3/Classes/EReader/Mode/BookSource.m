//
//  BookSource.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/10.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "BookSource.h"


static NSString *SourceID;

static NSString *SourceInfoPath;
@implementation BookSource

+ (BookSource *)shareInstance{
    
    static BookSource *bookSource;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        bookSource = [[BookSource alloc] init];
        
        
    });
    return bookSource;
}

-(void)SourceID:(NSString *)SourceId{
    
//    NSString *sourceId = SourceId;
//    [[NSUserDefaults standardUserDefaults] setValue:@(sourceId) forKey:[NSString stringWithFormat:@"%@SourceID",[[BookInfo siged] getBookID]]];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:SourceId forKey:[NSString stringWithFormat:@"%@SourceID",[[BookInfo siged] getBookID]]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    SourceID = SourceId;
    
    
}


-(NSString *)getSourceID{
    
    NSString *sourceID = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@SourceID",[[BookInfo siged] getBookID]]];
    
    NSString *cpContent = [NSMutableString stringWithContentsOfFile:[[BookSource shareInstance] getSourceInfoPath] encoding:NSUTF8StringEncoding error:NULL];//内容
    cpContent = [WXYClassMethodsViewController decode:cpContent];
    
    NSArray *arr = [WXYClassMethodsViewController stringToJSON:cpContent];
    
    if (sourceID ==nil) {
        
        return [arr[0] objectForKey:@"id"];
    }
    else
        
        return sourceID;
    
}

-(NSString *)getSourceTitle{

    NSString *SourceInfoPath = [NSString stringWithFormat:@"%@",[self getSourceInfoPath]];

    NSString *cpContent = [NSMutableString stringWithContentsOfFile:SourceInfoPath encoding:NSUTF8StringEncoding error:NULL];//内容
    cpContent = [WXYClassMethodsViewController decode:cpContent];
    
    NSArray * sourceArr = [WXYClassMethodsViewController stringToJSON:cpContent];

    NSString *title = [[NSString alloc]init];
    for (int i=0; i<sourceArr.count; i++) {
        if ([[sourceArr[i] objectForKey:@"id"] isEqualToString:[self getSourceID]]) {
            title =  [sourceArr[i] objectForKey:@"name"];
            break;
        }
        
    }
    return title;
}



-(NSString *)getSourceInfoPath{

    NSString *sourcePath = [NSString stringWithFormat:@"%@/SourceInfo.txt",[[BookInfo siged] getBookPath]];

    return sourcePath;
    
}

@end
