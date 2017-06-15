//
//  UIView+SYCategory.h
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SYCategory)
@property (nonatomic, assign) CGFloat sy_width;
@property (nonatomic, assign) CGFloat sy_height;
@property (nonatomic, assign) CGFloat sy_x;
@property (nonatomic, assign) CGFloat sy_y;
@property (nonatomic, assign) CGFloat sy_centerX;
@property (nonatomic, assign) CGFloat sy_centerY;
@property (nonatomic, assign) CGSize sy_size;
@property (nonatomic, assign) CGFloat sy_right;
@property (nonatomic, assign) CGFloat sy_bottom;

//判断一个控件是否真正显示在主窗口
- (BOOL)isShowingOnKeyWindow;
@end
