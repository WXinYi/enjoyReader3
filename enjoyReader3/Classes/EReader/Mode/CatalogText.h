//
//  CatalogText.h
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogText : NSObject
/**
 *  单例
 */
+(id)siged;
/**
 *  对txt分段保存
 *
 *  @param path txt路径
 */
-(void)loadTextWithBookID:(NSString *)bookID;
/**
 *  获取 图书名称
 *
 *  @return 图书名称
 */
-(NSString *)getBookName;
/**
 *  获取分成了多少本书
 */
-(NSUInteger)NumBook;
@end
