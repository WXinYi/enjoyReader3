//
//  MyFMDB.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/17.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "MyFMDB.h"

static MyFMDB *instance = nil;

@interface MyFMDB ()
{
@private FMDatabase *_dataBase;
}

@end

@implementation MyFMDB



#pragma mark 创建FMDB单例
/**
 *  创建单利
 *
 *  @return
 */
+ (MyFMDB *)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        [instance createDataBase];
        
    });
    return instance;
}
#pragma mark 创建FMDB单例

+(FMDatabase*)openDB
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *sqlPath=[docPath stringByAppendingPathComponent:@"mydatabase.sqlite"];
  
    //数据库加锁，防止同时修改数据
    @synchronized(self){
        static FMDatabase * db=nil;
        if (!db) {
            db=[[FMDatabase alloc]initWithPath:sqlPath];
            if (![db open]) {
                MyNSLog("数据库打开失败！");
            }
            else return db;
        }
        else
        {
            if (![db open]) {
                MyNSLog("数据库打开失败！");
            }
            else {
                [self judgeFMDBofTable:db];
                return db;
            }
        }
    }
    return nil;
    
}

+ (void)judgeFMDBofTable:(FMDatabase *)db
{
    
    
    //draftlist表中 两个
    if( [db columnExists:@"draftid" inTableWithName:@"draftlist"])
    {
    }else{
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",@"draftlist",@"draftid"];
        [db executeUpdate:sql];
    }
    if( [db columnExists:@"title" inTableWithName:@"draftlist"])
    {
    }else{
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",@"draftlist",@"title"];
        [db executeUpdate:sql];
    }
    
    if( [db columnExists:@"md5string" inTableWithName:@"draftlist"])
    {
    }else{
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",@"draftlist",@"md5string"];
        [db executeUpdate:sql];
    }
    if( [db columnExists:@"createtime" inTableWithName:@"draftlist"])
    {
    }else{
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",@"draftlist",@"createtime"];
        [db executeUpdate:sql];
    }
}

/**
 *  创建表
 *
 *  @return
 */
- (void)createDataBase{
    NSString *dbPath = [NSString stringWithFormat:@"%@/Library/Caches/UserData.db",NSHomeDirectory()];
    _dataBase = [[FMDatabase alloc]initWithPath:dbPath];
    if ([_dataBase open]) {
        MyNSLog("创建数据库成功! path=%@",dbPath);
        //创建数据库然后添加表
        if (![_dataBase tableExists:@"draftlist"]) {
            
            
            [self createTableWithSQL:@"CREATE TABLE draftlist (draftid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,title text,md5string text,createtime text)"];
        }
        
        if ([_dataBase open]) {
            
            [_dataBase close];
        }
    }
    else{
        MyNSLog("创建数据库失败!");
    }
}

- (void)createTableWithSQL:(NSString *)createTableSQL{
    if ([_dataBase executeUpdate:createTableSQL]) {
        MyNSLog("创建表成功!");
    }
    else{
        MyNSLog("创建表失败");
    }
}


/**
 *  插入数据库数据
 *
 *  @param testType 插入的表的类型
 *  @param dict     插入的数据
 */
- (void)insertTableWithTestType:(ListType)listType andDict:(NSDictionary *)dict andcreatetime:(NSString*)createtime{
    if ([_dataBase open]) {
        switch (listType) {
            case draftlist:{
                MyNSLog("打开数据库成功!");
                
                NSString *titleStr = [dict valueForKey:@"title"];
                NSString *md5string = [dict valueForKey:@"md5string"];
                
                
                [_dataBase executeUpdate:@"INSERT INTO draftlist (title,md5string,createtime) VALUES (?,?,?)",titleStr,md5string,createtime];
            }
                break;
                
            default:
                break;
        }
        
        if ([_dataBase open]) {
            
            [_dataBase close];
        }
    }
    else{
        MyNSLog("打开数据库失败!");
    }
}


/**
 *  查找标题对应的数据库数据
 *
 *  @param listType 查找的表的类型
 *  @param titleStr  草稿标题的字段
 *
 *  @return NSDictionary类型的数据
 */
- (NSDictionary *)selectAllWithTestType:(ListType)listType withtitle:(NSString *)titleStr {
    if ([_dataBase open]) {
        
        NSDictionary *dict  = [[NSDictionary alloc] init];
        switch (listType) {
            case draftlist:{
                FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM draftlist where title = ?",titleStr];
                while ([resultSet next]) {
                    
                    NSString *md5string = [resultSet stringForColumn:@"md5string"];
                    NSString *createtime = [resultSet stringForColumn:@"createtime"];
                    dict  = [NSDictionary dictionaryWithObjectsAndKeys:md5string,@"md5string",titleStr,@"title",createtime,@"createtime",nil];
                }
            }
                break;
                
            default:
                break;
        }
        
        if ([_dataBase open]) {
            
            [_dataBase close];
        }
        return dict;

    }
    else{
        MyNSLog("打开数据库失败!");
    }
    return [NSDictionary dictionary];
}


/**
 *  查找md5string对应的数据库数据
 *
 *  @param listType 查找的表的类型
 *  @param md5string  草稿md5string
 *
 *  @return NSDictionary类型的数据
 */
- (NSDictionary *)selectAllWithTestType:(ListType)listType withmd5string:(NSString *)md5string {
    if ([_dataBase open]) {
        
        NSDictionary *dict  = [[NSDictionary alloc] init];
        switch (listType) {
            case draftlist:{
                FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM draftlist where md5string = ?",md5string];
                while ([resultSet next]) {
                    NSString *titleString = [resultSet stringForColumn:@"title"];
                    NSString *createtime = [resultSet stringForColumn:@"createtime"];

                    dict  = [NSDictionary dictionaryWithObjectsAndKeys:md5string,@"md5string",titleString,@"title",createtime,@"createtime",nil];
                }
            }
                break;
                
            default:
                break;
        }
        
        if ([_dataBase open]) {
            
            [_dataBase close];
        }
        return dict;
        
    }
    else{
        MyNSLog("打开数据库失败!");
    }
    return [NSDictionary dictionary];
}

/**
 *  更新标题
 *
 *  @param testType 表的名称
 *  @param titleStr 标题
 *  @param md5string md5string
 */
- (void)updataTableWithTestType:(ListType)testType updatatitle:(NSString *)titleStr withmd5string:(NSString *)md5string{
    [_dataBase open];
    
    switch (testType) {
        case draftlist:{
            NSString *updateSql = [NSString stringWithFormat:@"update draftlist set  title = '%@'  where md5string = '%@'",titleStr,md5string];
            [_dataBase executeUpdate:updateSql];
        }
            break;
            
        default:
            break;
    }
    if ([_dataBase open]) {
        
        [_dataBase close];
    }
}

/**
 *  删除一条草稿数据
 *
 *  @param testType 表的名称
 *  @param titleStr 标题
 *  @param md5string md5string
 */
- (void)deleteTableWithTestType:(ListType)testType withtitle:(NSString *)titleStr orWithmd5string:(NSString *)md5string{
    [_dataBase open];
    
    switch (testType) {
        case draftlist:{
            if (titleStr.length>0) {
                
                NSString *deleteSql = [NSString stringWithFormat: @"delete from draftlist where title = '%@'",titleStr];
                [_dataBase executeUpdate:deleteSql];
                
            }else{
                
                NSString *deleteSql = [NSString stringWithFormat: @"delete from draftlist where md5string = '%@'",md5string];
                [_dataBase executeUpdate:deleteSql];
            
            }
           
        }
            break;
            
        default:
            break;
    }
    if ([_dataBase open]) {
        
        [_dataBase close];
    }
}


/**
 *  查询表中所有信息
 *
 *  @param testType  表名称
 *
 *
 *  @return array类型这一列所有内容
 */
- (NSArray *)getAllBrandwithTestType:(ListType)testType {

    if ([_dataBase open]) {

    NSMutableArray *titleArray = [NSMutableArray array];
    switch (testType) {
        case draftlist:{
            
    FMResultSet *result = [_dataBase executeQuery:@"select * from draftlist"];
            
    while ([result next]) {
        
        NSString *titleNames=[result stringForColumn:@"title"];
        NSString *md5Str = [result stringForColumn:@"md5string"];
        NSString *createtime = [result stringForColumn:@"createtime"];
        NSDictionary* dict  = [NSDictionary dictionaryWithObjectsAndKeys:md5Str,@"md5string",titleNames,@"title",createtime,@"createtime",nil];

        [titleArray addObject:dict];
    }
        }
            break;
            
        default:
            break;
    }

    if ([_dataBase open]) {
        
        [_dataBase close];
    }
    return titleArray;
        
    }else{
        MyNSLog("打开数据库失败!");
    
    }
    return [NSArray array];
}

@end
