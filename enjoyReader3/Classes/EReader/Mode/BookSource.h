//
//  BookSource.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/10.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookSource : NSObject
/**
 *  单例
 *
 *  @return 实例
 */
+ (BookSource *)shareInstance;

//传入源id
-(void)SourceID:(NSString *)SourceId;


//得到当前源id
-(NSString *)getSourceID;

////传入sourceinfo路径
//-(void)SourceInfoPath:(NSString *)SourceInfoPath;

//得到sourceinfo路径
-(NSString *)getSourceInfoPath;

//得到当前源名称
-(NSString *)getSourceTitle;

@end
