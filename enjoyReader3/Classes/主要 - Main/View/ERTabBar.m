//
//  SYTabBar.m
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//自定义底部TabBar的Frame

#import "ERTabBar.h"
#import "draftSingle.h"
#import "PublishViewController.h"
NSString *const ERTabBarDidSelectNotification = @"ERTabBarDidSelectNotification";

@interface ERTabBar()
//中间发布按钮
@property (nonatomic,weak) UIButton *publishButton;
@property (strong, nonatomic) UITableView *contentView;
@property (nonatomic,strong)UIWindow *alertWindow;

@property (nonatomic,strong ) UITableView *chooseTableView;
@property (nonatomic,strong ) UIView *popView;
@property (nonatomic,strong ) NSArray *infoArray;

@end

@implementation ERTabBar
//因为用代码会调用initWithFrame这个方法，并进行初始化一次的设置，所以在里面设置按钮的属性
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置中间添加按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"icon_xie_"] forState:UIControlStateNormal];
        [publishButton addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        _publishButton = publishButton;
    }
    return self;
}
//重新布局TabBar
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    //标记按钮是否已经添加过监听器
    static BOOL added = NO;
    
    CGFloat width = self.sy_width;
    CGFloat height = self.sy_height;
    
    // 设置发布按钮的frame
//    _publishButton.center = CGPointMake(width * 0.5, height * 0.5 + 2);
//
    _publishButton.frame =CGRectMake(kScreenWidth/2-25, -5, 50, 50);

//    _publishButton.sy_height = height;
//    _publishButton.sy_width = width;
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    
    //因为在这里里面需要设置button的监听 如果是view *button 那么就不会提示addtag这个方法
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX+10, buttonY, buttonW-20, buttonH-5);
        button.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        // 增加索引
        index++;
        
        if (added == NO) {
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    added = YES;
}

- (void)buttonClick{
    
    //发出一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ERTabBarDidSelectNotification" object:nil userInfo:nil];
    
}

//点击发布按钮
- (void)publishButtonClick{
   
    PublishViewController * testVC = [PublishViewController new];
    [UIApplication sharedApplication].keyWindow.rootViewController.definesPresentationContext = YES;
    testVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    testVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:testVC animated:NO completion:nil];
    
}


//移出屏幕再消除




@end
