//
//  YXJSON.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/5/20.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXJSON : NSObject

/** 将字典或者数组转换为JSON格式字符串 @return JSON格式字符串 */
+ (NSString *)JSONStringWithDictionaryOrArray:(id)dictionaryOrArray;

/** 将字典或者数组转换为JSON的Data @return JSON的Data */
+ (NSData *)JSONSDataWithDictionaryOrArray:(id)dictionaryOrArray;

/** 将JSON格式字符串转换为字典或者数组 @return 字典或者数组 */
+ (id)dictionaryOrArrayWithJSONSString:(NSString *)jsonString;

/** 将JSON的Data转换为字典或者数组 @return 字典或者数组 */
+ (id)dictionaryOrArrayWithJSONSData:(NSData *)jsonData;

@end
