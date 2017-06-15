//
//  CodeTools.h
//  FirstProject
//
//  Created by OWN on 16/2/18.
//  Copyright © 2016年 OWN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZIP.h"

@interface CodeTools : NSObject

+(NSString *)GZipDecompressAndBase64String :(NSString *)zippedString;

+(NSString *)unCompress:(NSData *)data;

+(NSString *)GZipCompressAndBase64String :(NSString *)zippedString;

+(NSData *)Compress:(NSString *)result;

@end
