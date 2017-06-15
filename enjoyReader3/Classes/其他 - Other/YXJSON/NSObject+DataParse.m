//
//  NSObject+DataParse.m
//  安好医生端
//
//  Created by lianchuang on 14-7-1.
//  Copyright (c) 2014年 lianchuangbrother. All rights reserved.
//

#import "NSObject+DataParse.h"

@implementation NSObject (DataParse)

// JSON数据解析方法，dict为得到的数据源字典
- (id)initWithDictionary:(NSDictionary*) dict {
    self = [self init];
    if(self && dict){
        [self objectFromDictionary:dict];
    }
    return self;
}

-(NSString *) className {
    return NSStringFromClass([self class]);
}

// 解析数据
- (void)objectFromDictionary:(NSDictionary*) dict {
    unsigned int propCount, i;
    objc_property_t* properties = class_copyPropertyList([self class], &propCount);
    for (i = 0; i < propCount; i++) {
        objc_property_t prop = *properties;
        properties++;
        const char *propName = property_getName(prop);
        if(propName) {
            NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            id obj = [dict objectForKey:name];
//            NSLog(@"%@",[obj className]);
            if (!obj)
                continue;
            if ([[obj className] isEqualToString:@"__NSCFString"] || [[obj className] isEqualToString:@"__NSCFNumber"]||[[obj className] isEqualToString:@"__NSCFConstantString"]) {
                [self setValue:obj forKeyPath:name];
            } else if ([obj isKindOfClass:[NSDictionary class]]) {
                id subObj = [self valueForKey:name];
                if (subObj)
                    [subObj objectFromDictionary:obj];
            }
        }
    }
    //free(properties);
}

@end
