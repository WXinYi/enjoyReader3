//
//  KeyboardFromPerfInfo.m
//  Anhao
//
//  Created by 马晓良 on 15/5/7.
//  Copyright (c) 2015年 lianchuang. All rights reserved.
//

#import "KeyboardFromPerfInfo.h"

#define kLineWidth 1
#define kNumFont [UIFont systemFontOfSize:27]
@implementation KeyboardFromPerfInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, kScreenWidth, 216);
        //
        arrLetter = [NSArray arrayWithObjects:@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"RST",@"UVW",@"XYZW", nil];
        
        connectionTimer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        connectionTimer.fireDate = [NSDate distantFuture];
        //
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        //
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-2)/3, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-2)/3*2 + 1, 0, kLineWidth, 216)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*(i+1), kScreenWidth, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
    }

    return self;
}

-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    UIButton *button;
    //
    CGFloat frameX;
    CGFloat frameW;
    switch (y)
    {
        case 0:
            frameX = (kScreenWidth - 2)/3*y + y;
            frameW = (kScreenWidth - 2)/3;
            break;
        case 1:
            frameX = (kScreenWidth - 2)/3*y + y;
            frameW = (kScreenWidth - 2)/3;
            break;
        case 2:
            frameX = (kScreenWidth - 2)/3*y + y;
            frameW = (kScreenWidth - 2)/3;
            break;
            
        default:
            break;
    }
    CGFloat frameY = 54*x;
    
    //
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, 54)];
    
    //
    NSInteger num = y+3*x+1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(longPress:)];
    longPressGR.minimumPressDuration = 0.5;
    [button addGestureRecognizer:longPressGR];
    
    
    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    
    if (num == 10 || num == 12)
    {
        UIColor *colorTemp = colorNormal;
        colorNormal = colorHightlighted;
        colorHightlighted = colorTemp;
        if (num == 10) {
            button.userInteractionEnabled = NO;
        }
    }
    button.backgroundColor = colorNormal;
    //    button.backgroundColor = [UIColor whiteColor];
    CGSize imageSize = CGSizeMake(frameW, 54);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    
    
    
    if (num<10)
    {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, frameW, 28)];
        labelNum.text = [NSString stringWithFormat:@"%ld",(long)num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        [button addSubview:labelNum];
        
        if (num != 1)
        {
            UILabel *labelLetter = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frameW, 16)];
            labelLetter.text = [arrLetter objectAtIndex:num-2];
            labelLetter.textColor = [UIColor blackColor];
            labelLetter.textAlignment = NSTextAlignmentCenter;
            labelLetter.font = [UIFont systemFontOfSize:12];
            [button addSubview:labelLetter];
        }
    }
    else if (num == 11)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    }
    else if (num == 10)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, frameW, 28)];
        label.text = @"";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    }
    else
    {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-2)/6-11, 19, 22, 17)];
        arrow.image = [UIImage imageNamed:@"arrowInKeyboard"];
        [button addSubview:arrow];
        
    }
    
    return button;
}


-(void)clickButton:(UIButton *)sender
{
    if (sender.tag == 10)
    {
        [self.delegate appendingStringAnother];
        return;
    }
    else if(sender.tag == 12)
    {
        [self.delegate numberKeyboardBackspaceAnother];
    }
    else
    {
        NSInteger num = sender.tag;
        if (sender.tag == 11)
        {
            num = 0;
        }
        [self.delegate numberKeyboardInputAnother:num];
    }
}
- (void)longPress:(UITapGestureRecognizer *)tap
{
    UIButton * button = (UIButton *)[tap view];
    if (tap.state == UIGestureRecognizerStateEnded){
        connectionTimer.fireDate = [NSDate distantFuture];
 
    }else if (tap.state == UIGestureRecognizerStateBegan){
        if (button.tag == 12)
        {
            connectionTimer.fireDate = [NSDate distantPast];
        }
        
    }else if (tap.state == UIGestureRecognizerStateChanged){
        
    }
}

-(void)timerFired:(NSTimer *)timer{
    [self.delegate numberKeyboardBackspaceAnother];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
