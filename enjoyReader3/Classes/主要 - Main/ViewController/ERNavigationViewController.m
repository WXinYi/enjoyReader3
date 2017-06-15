//
//  SYNavigationViewController.m
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ERNavigationViewController.h"

@interface ERNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation ERNavigationViewController

//修改整体导航栏上的文字大小
//load类加载进内存的时候调用，只会调用一次

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  设置navigation的背景颜色和字体的颜色
     */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BBG);
    
    __block UIView * navBottomLine = nil;
    
    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]){
            
            UIView* v = obj;
            
            if (v.subviews.count)
            {
                navBottomLine = [v.subviews firstObject];
            }
            
            *stop=YES;
        }
    }];
    
    navBottomLine.hidden = YES;
    
    self.navigationBar.translucent = NO;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];

    /**
     *  是否开启手势返回
     *
     *  @param respondsToSelector:@selectorinteractivePopGestureRecognizer
     *  是否开启手势返回的方法
     *
     *  @return 无
     */
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
/**
 *  设置navigation的背景颜色和字体的颜色
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  跳转获取viewcontroller，首页的viewcontroller显示tabbar，其他的隐藏
 *
 *  @param viewControllerToPresent
 *  @param flag
 *  @param completion
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *parentViewController = [self.viewControllers lastObject];
    UIViewController *rootViewController = [self.viewControllers firstObject];
    
    if ([parentViewController isKindOfClass:[rootViewController class]]) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }else{
        parentViewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
    
    rootViewController.hidesBottomBarWhenPushed = NO;
    
    
}
@end
