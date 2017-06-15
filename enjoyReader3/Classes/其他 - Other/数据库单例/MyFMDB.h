//
//  MyFMDB.h
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/17.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@interface MyFMDB : NSObject
/**
 *  创建单利
 *
 *  @return
 */
+ (MyFMDB *)instance;

+(FMDatabase *)openDB;
/**
 *  插入数据库数据
 *
 *  @param testType 插入的表的类型
 *  @param dict     插入的数据
 */
- (void)insertTableWithTestType:(ListType)listType andDict:(NSDictionary *)dict andcreatetime:(NSString*)createtime;



/**
 *  删除一条草稿数据
 *
 *  @param testType 表的名称
 *  @param titleStr 标题
 *  @param md5string md5string
 */
- (void)deleteTableWithTestType:(ListType)testType withtitle:(NSString *)titleStr orWithmd5string:(NSString *)md5string;


/**
 *  查询查询所有信息
 *
 *  @param testType  表名称
 *
 *
 *  @return array类型这一列所有内容
 */
- (NSArray *)getAllBrandwithTestType:(ListType)testType;


/**
 *  查找标题对应的数据库数据
 *
 *  @param listType 查找的表的类型
 *  @param titleStr  草稿标题的字段
 *
 *  @return NSDictionary类型的数据
 */
- (NSDictionary *)selectAllWithTestType:(ListType)listType withtitle:(NSString *)titleStr;


/**
 *  查找md5string对应的数据库数据
 *
 *  @param listType 查找的表的类型
 *  @param md5string  草稿md5string
 *
 *  @return NSDictionary类型的数据
 */
- (NSDictionary *)selectAllWithTestType:(ListType)listType withmd5string:(NSString *)md5string;



/**
 *  更新标题
 *
 *  @param testType 表的名称
 *  @param titleStr 标题
 *  @param md5string md5string
 */
- (void)updataTableWithTestType:(ListType)testType updatatitle:(NSString *)titleStr withmd5string:(NSString *)md5string;







@end
