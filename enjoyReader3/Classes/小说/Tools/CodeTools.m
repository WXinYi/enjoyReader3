//
//  CodeTools.m
//  FirstProject
//
//  Created by OWN on 16/2/18.
//  Copyright © 2016年 OWN. All rights reserved.
//

#import "CodeTools.h"
#import "Base64.h"
#import "NSData+GZIP.h"

const NSUInteger SERVER_MAGIC_DIGITS = 12;
const NSUInteger SERVER_MAGIC_LENGTH = 8;


@implementation CodeTools

/**
 *  解压缩解Base64
 *
 *  @param zippedString 被压缩和编码的字符串
 *
 *  @return 所需要的信息
 */
+(NSString *)GZipDecompressAndBase64String:(NSString *)zippedString
{
    if (zippedString == nil && [zippedString isEqual:@""])
    {
        return @"";
    }
    else
    {
        NSUInteger pos = zippedString.length % SERVER_MAGIC_DIGITS;
        NSMutableString *string = [[NSMutableString alloc] initWithString:zippedString];
        [string deleteCharactersInRange:NSMakeRange(pos, SERVER_MAGIC_LENGTH)];
        NSData * data = [string base64DecodedData];
        
        return [self unCompress:data];
    }
}


+(NSString *)GZipCompressAndBase64String:(NSString *)rawString
{
    if (rawString == nil && [rawString isEqual:@""]) {
        return @"";
    }else{
        NSData *data = [self Compress:rawString];
        NSString *zippedString =[data base64EncodedString];
        return zippedString;
    }
}

+(NSString *)unCompress:(NSData *)data
{
    data = [data gunzippedData];
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return result;
}

+(NSData *)Compress:(NSString *)result
{
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];

    data = [data gzippedData];
    
    return data;
}


@end
