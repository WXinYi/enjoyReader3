//
//  ILTranslucentView.h
//  EnjoyReader3
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILTranslucentView : UIView

@property (nonatomic) BOOL translucent; //do you want blur effect? (default: YES)
@property (nonatomic) CGFloat translucentAlpha; //alpha of translucent  effect (default: 1)
@property (nonatomic) UIBarStyle translucentStyle; //blur style, Default or Black
@property (nonatomic, strong) UIColor *translucentTintColor; //tint color of blur, [UIColor clearColor] is default


@end
