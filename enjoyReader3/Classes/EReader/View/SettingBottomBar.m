//
//  E_SettingBottomBar.m
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "SettingBottomBar.h"
#import "E_ContantFile.h"
#import "CommonManager.h"
#import "ILSlider.h"
#import "HUDView.h"
#import "SettingFontBottomBar.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17
#define MIN_TIPS @"字体已到最小"
#define MAX_TIPS @"字体已到最大"

@implementation SettingBottomBar
{
    ILSlider *ilSlider;//章节进度条
    UILabel  *showLbl;
    SettingFontBottomBar *_settingFontBar;
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

- (void)configUI{
    
    
    
    showLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, self.frame.size.height - kBottomBarH - 70, self.frame.size.width - 140 , 60)];
    showLbl.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [showLbl setTextColor:[UIColor whiteColor]];
    showLbl.font = [UIFont systemFontOfSize:18];
    showLbl.textAlignment = NSTextAlignmentCenter;
    showLbl.numberOfLines = 2;
    showLbl.alpha = 0.7;
    showLbl.hidden = YES;
    [self addSubview:showLbl];
    
    ilSlider = [[ILSlider alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 54 - 40  , self.frame.size.width - 100, 40) direction:ILSliderDirectionHorizonal];
    ilSlider.maxValue = 3;
    ilSlider.minValue = 1;
    
    [ilSlider sliderChangeBlock:^(CGFloat value) {
        
        if (!isFirstShow) {
            showLbl.hidden = NO;
            double percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
            showLbl.text = [NSString stringWithFormat:@"第%ld章\n%.1f%@",_currentChapter,percent*100,@"%"];
        }
        isFirstShow = NO;
       
       
    }];
    
    [ilSlider sliderTouchEndBlock:^(CGFloat value) {
        
        showLbl.hidden = YES;
        float percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
        NSInteger page = (NSInteger)round(percent * _chapterTotalPage);
        if (page == 0) {
            page = 1;
        }
        [_delegate sliderToChapterPage:page];
    }];

    [self addSubview:ilSlider];
   
    //前一章 按钮
    UIButton *preChapterBtn = [UIButton buttonWithType:0];
    preChapterBtn.frame = CGRectMake(5, self.frame.size.height - 54 - 40 , 40, 40);
    preChapterBtn.backgroundColor = [UIColor clearColor];
    [preChapterBtn setTitle:@"上一章" forState:0];
    [preChapterBtn addTarget:self action:@selector(goToPreChapter) forControlEvents:UIControlEventTouchUpInside];
    preChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [preChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:preChapterBtn];
    
    //后一章 按钮
    UIButton *nextChapterBtn = [UIButton buttonWithType:0];
    nextChapterBtn.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 54 - 40 , 40, 40);
    nextChapterBtn.backgroundColor = [UIColor clearColor];
    [nextChapterBtn setTitle:@"下一章" forState:0];
    [nextChapterBtn addTarget:self action:@selector(goToNextChapter) forControlEvents:UIControlEventTouchUpInside];
    nextChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [nextChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:nextChapterBtn];
    
    NSArray *iconArr = @[@"目录.png",@"放大.png",@"缩小.png",@"下载.png",@"背景.png"];
    for (int i=0; i<5; i++) {
        CGFloat x =((kScreenWidth-200)/6)*(i+1) + 40*i;
        UIButton *bottomBtn =[UIButton buttonWithType:0];
        bottomBtn.frame = CGRectMake(x, self.frame.size.height-45, 28,28);
        [bottomBtn addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.tag = 100000+i;
        
        [bottomBtn setImage:[UIImage imageNamed:iconArr[i]] forState:0];
        
        bottomBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [self addSubview:bottomBtn];
        
    }
    
    
}

-(void)doSomething:(UIButton *)button{

    if (button.tag == 100000) {
        
        [self showDrawerView];
        
    }else if (button.tag == 100001){
    //文字放大
    
        [self changeBig];
    
    
    }else if (button.tag == 100002){
    //字体缩小
    
        [self changeSmall];
    
    }else if (button.tag == 100003){
    
        [self callCacheClick];
    
    }else{
    
        [self showFontBottomBar];
    
    }


}

-(void)showFontBottomBar{


    [_delegate callFontBar];


}

#pragma mark - 小
- (void)changeSmall
{
    NSUInteger fontSize = [CommonManager fontSize];
    if (fontSize <= MIN_FONT_SIZE) {
        [HUDView showMsg:MIN_TIPS inView:self];
        return;
    }
    fontSize--;
    [CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
}

- (void)changeBig
{
    NSUInteger fontSize = [CommonManager fontSize];
    if (fontSize >= MAX_FONT_SIZE) {
        [HUDView showMsg:MAX_TIPS inView:self];
        return;
    }
    fontSize++;
    [CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
    
}

- (void)updateFontButtons
{
    NSUInteger fontSize = [CommonManager fontSize];
    _bigFont.enabled = fontSize < MAX_FONT_SIZE;
    _smallFont.enabled = fontSize > MIN_FONT_SIZE;
}

- (void)goToNextChapter{
    
    [_delegate turnToNextChapter];
    
}

- (void)goToPreChapter{
    
    [_delegate turnToPreChapter];

}



- (void)showDrawerView{
   
    [_delegate callDrawerView];

}

- (void)changeSliderRatioNum:(float)percentNum{
    
    ilSlider.ratioNum = percentNum;

}

- (void)callCacheClick{
    
    [_delegate callCacheClick];
}




- (void)showToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= kBottomBarH;
    float currentPage = [[NSString stringWithFormat:@"%ld",_chapterCurrentPage] floatValue] + 1;
    float totalPage = [[NSString stringWithFormat:@"%ld",_chapterTotalPage] floatValue];
    if (currentPage == 1) {//强行放置头部
        ilSlider.ratioNum = 0;
    }else{
        ilSlider.ratioNum = currentPage/totalPage;
    }
    
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y += kBottomBarH;
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
