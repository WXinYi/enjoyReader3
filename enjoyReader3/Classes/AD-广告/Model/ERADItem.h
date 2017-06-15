//
//  SYADItem.h
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//  从返回的数据中挑选有用的属性

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ERADItem : NSObject

//当前广告图片URL
@property (nonatomic,strong) NSString *w_picurl;
//点击广告之后跳入的广告网址
@property (nonatomic,strong) NSString *ori_curl;
//广告图片的宽度
@property (nonatomic,assign) CGFloat w;
//广告图片的高度
@property (nonatomic,assign) CGFloat h;


@end
