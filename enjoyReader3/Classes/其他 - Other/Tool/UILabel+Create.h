//
//  UILabel+Create.h
//  安好
//
//  Created by rlp on 14-11-14.
//  Copyright (c) 2014年 lianchuangbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Create)
/**
 *  初始化UIlabel
 *
 *  @param frame           frame
 *  @param text            text
 *  @param font            font
 *  @param textColor       textColor
 *  @param backgroundColor backgroundColor
 *  @param numberOfLines   numberOfLines
 *  @param lineSpacing     lineSpacing
 *
 *  @return UIlabel
 */
-(UILabel *)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor *)textColor backgroundColor:(UIColor*)backgroundColor numberOfLines:(NSInteger)numberOfLines lineSpacing:(CGFloat )lineSpacing;

-(UILabel *)initWithFrame1:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor *)textColor backgroundColor:(UIColor*)backgroundColor numberOfLines:(NSInteger)numberOfLines lineSpacing:(CGFloat )lineSpacing;


@end
