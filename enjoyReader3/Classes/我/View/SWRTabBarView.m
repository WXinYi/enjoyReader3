//
//  SWRTabBarView.m
//  JianshuMyPage
//
//  Created by Weiran Shi on 2015-12-10.
//  Copyright © 2015 Vera Shi. All rights reserved.
//

#import "SWRTabBarView.h"
#import "SWRTabButton.h"

@interface SWRTabBarView ()
@property(nonatomic,strong)SWRTabButton *Tougaobutton;
@property(nonatomic,strong)SWRTabButton *huifubutton;
@property(nonatomic,strong)SWRTabButton *zanbutton;
@end

@implementation SWRTabBarView

- (void)shiftWhenScroll:(UIScrollView *)scrollView headerViewHeight:(CGFloat)headerViewHeight initialPositionY:(CGFloat)initialPositionY
{
    if (scrollView.contentOffset.y  >= headerViewHeight - self.frame.size.height){
        CGRect frame = self.frame;
        frame.origin.y = initialPositionY + scrollView.contentOffset.y  - (headerViewHeight - self.frame.size.height);
        self.frame = frame;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *tintGray = [UIColor colorWithWhite:0.8 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, tintGray.CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddLineToPoint(context, self.frame.size.width, 0.0f);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, 0.0f, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    CGContextStrokePath(context);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setButtonArr:(NSArray *)buttonArr
{
    _buttonArr = buttonArr;
    
    NSInteger buttonNum = buttonArr.count;
    CGFloat margin = 20;
    CGFloat buttonWidth = (self.frame.size.width - 2 * margin) / buttonNum;
    
//    for (int i = 0; i < buttonArr.count; i++){
//        NSString *buttonTitle = buttonArr[i];
//        SWRTabButton *button = [[SWRTabButton alloc] initWithButtonTitle:buttonTitle frame:CGRectMake(0, 0, 100, 50)];
//        button.center = CGPointMake(margin + i * buttonWidth + buttonWidth / 2, button.frame.size.height / 2);
//        button.selected = NO;
//        button.tag = 1000+i;
//        [button addTarget:self action:@selector(changeButten:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
//    }
//
    
    _Tougaobutton= [[SWRTabButton alloc] initWithButtonTitle:buttonArr[0] frame:CGRectMake(0, 0, 100, 50)];
    _Tougaobutton.center = CGPointMake(margin + 0 * buttonWidth + buttonWidth / 2, _Tougaobutton.frame.size.height / 2);
    _Tougaobutton.selected = YES;
    _Tougaobutton.tag = 1000+0;
    [_Tougaobutton addTarget:self action:@selector(changeButten:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_Tougaobutton];
    
    if (buttonArr.count >1) {

    _huifubutton = [[SWRTabButton alloc] initWithButtonTitle:buttonArr[1] frame:CGRectMake(0, 0, 100, 50)];
    _huifubutton.center = CGPointMake(margin + 1 * buttonWidth + buttonWidth / 2, _huifubutton.frame.size.height / 2);
    _huifubutton.selected = NO;
    _huifubutton.tag = 1000+1;
    [_huifubutton addTarget:self action:@selector(changeButten:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_huifubutton];
    if (buttonArr.count >2) {
        _zanbutton = [[SWRTabButton alloc] initWithButtonTitle:buttonArr[2] frame:CGRectMake(0, 0, 100, 50)];
        _zanbutton.center = CGPointMake(margin + 2 * buttonWidth + buttonWidth / 2, _zanbutton.frame.size.height / 2);
        _zanbutton.selected = NO;
        _zanbutton.tag = 1000+2;
        [_zanbutton addTarget:self action:@selector(changeButten:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_zanbutton];

    }
    }
    
}
-(void)changeButten:(UIButton *)butten{

    if ([self.delegate respondsToSelector:@selector(menuHeaderButtonClicked:)]){
    
        [self.delegate menuHeaderButtonClicked:butten];
    }
    butten.selected = YES;
    if (butten.tag ==1000) {
        //投稿
        _zanbutton.selected = NO;
        _huifubutton.selected = NO;
    }else if (butten.tag == 1001){
        //回复
        _Tougaobutton.selected = NO;
        _zanbutton.selected = NO;
    
    }else{
        //赞 
        _huifubutton.selected = NO;
        _Tougaobutton.selected = NO;
    
    }



}
@end
