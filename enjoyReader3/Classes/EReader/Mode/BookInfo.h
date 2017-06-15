//
//  BookInfo.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookInfo : NSObject
/**
 *  单例
 */
+(id)siged;

-(void)bookID:(NSString *)bookid;
//获取book
-(NSString *)getBookID;

//当前书的目录
//-(void)bookPath:(NSString *)bookpath;
//获取book路径
-(NSString *)getBookPath;
@end
