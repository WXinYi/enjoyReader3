//
//  draftSingle.h
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/16.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface draftSingle : NSObject

//单例
+ (draftSingle *)shareInstance;

-(void)creatDraftFile;

-(NSString *)getDraftPath;


//得到所有信息

-(NSArray *)getAllDraftInfo;

/**
 *  通过标题获取草稿内容
 *
 *  @param fileName 文章标题
 *
 *  @return 内容
 */
-(NSString *)getDraftContentwithmd5str:(NSString *)md5string;


//获取创建时间
-(NSString *)getnowdata;

/**
 *  保存新建的草稿
 *
 *  @param titleName title的标题
 *  @param content   内容
 */
-(void)saveDraftContentWithTitleName:(NSString *)titleName withcontent:(NSString *)content;



/**
 *更新草稿
 *
 *  @param md5Str    已有的MD5
 *  @param titleName 标题
 *  @param content   内容
 */
-(void)updataDraftContentWithmd5Str:(NSString *)md5Str WithTitleName:(NSString *)titleName withcontent:(NSString *)content;


/**
 *  删除草稿
 *
 *  @param md5String   传入MD5String
 */
-(void)deleteDraftWithMd5:(NSString *)md5String;
@end
