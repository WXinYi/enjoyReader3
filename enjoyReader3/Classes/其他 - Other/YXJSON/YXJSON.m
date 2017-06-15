//
//  YXJSON.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/5/20.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#if __has_feature(objc_arc) 
#define YX_release(obj) 
#define YX_autorelease(obj) 
#else 
#define YX_release(obj) [obj release] 
#define YX_autorelease(obj) [obj autorelease] 
#endif
#import "YXJSON.h"

@implementation YXJSON

+ (NSString *)JSONStringWithDictionaryOrArray:(id)dictionaryOrArray
{
    if (dictionaryOrArray == nil)
    {
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryOrArray options:NSJSONWritingPrettyPrinted error:nil];
    if (data == nil)
    {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    YX_autorelease(string);
    return string;
}
+ (NSData *)JSONSDataWithDictionaryOrArray:(id)dictionaryOrArray
{
    if (dictionaryOrArray == nil)
    { return nil; }
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryOrArray options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}
+ (id)dictionaryOrArrayWithJSONSString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves|| NSJSONReadingMutableContainers error:nil];
}
+ (id)dictionaryOrArrayWithJSONSData:(NSData *)jsonData
{
    if (jsonData == nil)
    {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves|| NSJSONReadingMutableContainers error:nil];
}


@end











