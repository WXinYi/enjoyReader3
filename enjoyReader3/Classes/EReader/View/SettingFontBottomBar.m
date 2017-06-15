//
//  SettingFontBottomBar.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/2.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "SettingFontBottomBar.h"
#import "CommonManager.h"
#import "HUDView.h"



@implementation SettingFontBottomBar
{
    
    
    BOOL isFirstShow;
    
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9];// [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0]
        isFirstShow = YES;
        [self configUI];
    }
    return self;
    
}
-(void)configUI{


//    _bigFont = [UIButton buttonWithType:0];
//    _bigFont.frame = CGRectMake(110 + (self.frame.size.width - 200)/2, self.frame.size.height - 44, (self.frame.size.width - 200)/2, 44);
//    [_bigFont setImage:[UIImage imageNamed:@"reader_font_increase.png"] forState:0];
//    _bigFont.backgroundColor = [UIColor clearColor];
//    
//    [_bigFont addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self addSubview:_bigFont];
//    
//    _smallFont = [UIButton buttonWithType:0];
//    
//    [_smallFont setImage:[UIImage imageNamed:@"reader_font_decrease.png"] forState:0];
//    [_smallFont addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
//    _smallFont.frame =  CGRectMake(90, self.frame.size.height - 44, (self.frame.size.width - 200)/2, 44);
//    [self addSubview:_smallFont];




    //主题
    //主题颜色滚动条
    UIScrollView *themeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(30, self.frame.size.height - 54 -20 , self.frame.size.width - 60, 40)];
    themeScroll.backgroundColor = [UIColor clearColor];
    [self addSubview:themeScroll];
    
    NSInteger themeID = [CommonManager Manager_getReadTheme];
    
    for (int i = 1; i <= 4; i ++) {
        
        UIButton * themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        themeButton.layer.cornerRadius = 2.0f;
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        themeButton.frame = CGRectMake(0 + 36*i + (self.frame.size.width - 60 - 6 *36)*(i - 1)/3, 2, 36, 36);
        
        if (i == 1) {
            [themeButton setBackgroundColor:[UIColor whiteColor]];
            
        }else{
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateNormal];
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateSelected];
        }
        
        if (i == themeID) {
            themeButton.selected = YES;
        }
        
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateSelected];
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateHighlighted];
        themeButton.tag = 7000+i;
        [themeButton addTarget:self action:@selector(themeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [themeScroll addSubview:themeButton];



    }
}



- (void)themeButtonPressed:(UIButton *)sender{
    
    [sender setSelected:YES];
    
    for (int i = 1; i <= 5; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:7000+i];
        
        if (button.tag != sender.tag) {
            [button setSelected:NO];
        }
    }
    
    [_delegate themeButtonAction:self themeIndex:sender.tag-7000];
    [CommonManager saveCurrentThemeID:sender.tag-7000];
}
- (void)showFontBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= kBottomBarH;
   
    [UIView animateWithDuration:0.18 animations:^{
        
        self.frame = newFrame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)hideFontBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y += kBottomBarH;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        
    }];
    
}

@end
