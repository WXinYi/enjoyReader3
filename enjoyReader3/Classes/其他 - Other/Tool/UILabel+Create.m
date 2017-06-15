//
//  UILabel+Create.m
//  安好
//
//  Created by rlp on 14-11-14.
//  Copyright (c) 2014年 lianchuangbrother. All rights reserved.
//

#import "UILabel+Create.h"
#import "MyUILabel.h"

@implementation UILabel (Create)
-(UILabel *)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor *)textColor backgroundColor:(UIColor*)backgroundColor numberOfLines:(NSInteger)numberOfLines lineSpacing:(CGFloat )lineSpacing{
    MyUILabel *label = [[MyUILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor =textColor;
    label.backgroundColor =backgroundColor;
    label.numberOfLines = numberOfLines;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    label.attributedText = attributedString;
    [label sizeToFit];

    

    return label;
}

-(UILabel *)initWithFrame1:(CGRect)frame text:(NSString *)text font:(UIFont*)font textColor:(UIColor *)textColor backgroundColor:(UIColor*)backgroundColor numberOfLines:(NSInteger)numberOfLines lineSpacing:(CGFloat )lineSpacing{
    MyUILabel *label = [[MyUILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor =textColor;
    label.backgroundColor =backgroundColor;
    label.numberOfLines = numberOfLines;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    label.attributedText = attributedString;
    [label sizeToFit];
    label.verticalAlignment = VerticalAlignmentMiddle;
    
    if (label.frame.size.height<=24.5f) {
        label.frame =CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, 16.f);
    }
    
    
    return label;
}
@end
