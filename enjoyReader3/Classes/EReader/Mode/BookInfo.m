//
//  BookInfo.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "BookInfo.h"
static BookInfo *book;
static NSString *BookID;


@implementation BookInfo

+(id)siged{
    if (book==nil) {
        book = [[BookInfo alloc] init];
    }
    return book;

}


-(void)bookID:(NSString *)bookid{


    BookID = bookid;


}


-(NSString *)getBookID{
    return BookID;
}


//获取book路径
-(NSString *)getBookPath{

    NSArray *cacesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [cacesPath objectAtIndex:0];
    NSString *bookPath = [documentsDirectory stringByAppendingPathComponent:BookID];
    return bookPath;

}
@end
