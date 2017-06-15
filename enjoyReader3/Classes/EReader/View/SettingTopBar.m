//
//  E_SettingBar.m
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "SettingTopBar.h"
#import "CommonManager.h"
#import "ReaderDataSource.h"

@implementation SettingTopBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:5/255.0 blue:5/255.0 alpha:0.9];;
//        [self configUI];
//        _readPage = readPage;
    }
    return self;

}

- (void)showToolBar{
   
    CGRect newFrame = self.frame;
    self.isHidden =NO;
    newFrame.origin.y += 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    

}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= 64;
    self.isHidden = YES;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
       
    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
