//
//  HUDView.h
//
//
///  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//
/*
 弹出视图
 */

#import <UIKit/UIKit.h>

@interface HUDView : UIView
{
    UIFont *msgFont;
}
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, retain) UILabel  *labelText;
@property (nonatomic, assign) float leftMargin;
@property (nonatomic, assign) float topMargin;
@property (nonatomic, assign) float animationLeftScale;
@property (nonatomic, assign) float animationTopScale;
@property (nonatomic, assign) float totalDuration;

+ (void)showMsg:(NSString *)msg inView:(UIView*)theView;

@end
