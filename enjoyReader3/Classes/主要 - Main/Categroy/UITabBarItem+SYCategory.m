//
//  UITabBarItem+SYCategory.m
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "UITabBarItem+SYCategory.h"

@implementation UIBarButtonItem (SYCategory)
//封装一个工具类，调用其方法在其他控制力里面用来设置NavigationBar上左右Item的属性
+ (instancetype)itemWithImage:(NSString *)image hightImage:(NSString *)hightImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    //[self alloc]initWithCustomView:
    //              ||
    //[UIBarButtonItem alloc]initWithCustomView:
    //给按钮添加一个背景图片 防止点击范围越界
    UIView *containView = [[UIView alloc]initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return [[self alloc]initWithCustomView:containView];
}

+ (instancetype)itemWithImage:(NSString *)image selImage:(NSString *)selImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    //[self alloc]initWithCustomView:
    //              ||
    //[UIBarButtonItem alloc]initWithCustomView:
    return [[self alloc]initWithCustomView:btn];
}
@end
