//
//  NXAboutItem.m
//  NXAboutControllerDemo
//
//  Created by 蒋瞿风 on 16/6/17.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import "SettingAboutItem.h"

@implementation SettingAboutItem

+ (instancetype)itemWithTitle:(NSString *)title
                       detail:(NSString *)detail
                      handler:(MXAboutItemHandler)handler{
    SettingAboutItem *item = [[SettingAboutItem alloc] init];
    item.title        = title;
    item.detail       = detail;
    item.handler      = handler;
    return item;
}

@end
