//
//  NSObject+DataParse.h
//  安好医生端
//
//  Created by lianchuang on 14-7-1.
//  Copyright (c) 2014年 lianchuangbrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (DataParse)

// JSON数据解析方法，dict为得到的数据源字典
- (id)initWithDictionary:(NSDictionary*) dict;

@end
