//
//  SYMainController.m
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ERMainController.h"
#import "MyQuanerViewController.h"//书架
#import "HomeViewController.h"
#import "FindViewController.h"
#import "ERNavigationViewController.h"
#import "SWRTableViewController.h"
#import "ERTabBar.h"
#import "AppDelegate.h"
#import "NewloginViewController.h"
@interface ERMainController ()<UITabBarControllerDelegate>

@end

@implementation ERMainController
+ (void)initialize
{
    //appearance 可是该对象对应的类型属性进行统一
    UITabBarItem *item = [UITabBarItem appearance];
    
    //设置普通状态下字体富文本属性
    NSMutableDictionary *normalDic = [NSMutableDictionary dictionary];
    normalDic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    normalDic[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    //设置点击状态下字体富文本属性
    NSMutableDictionary *selectedDic = [NSMutableDictionary dictionary];
    selectedDic[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   //设置底部控制器
    [self setupChildViewController];
    //替换系统原有的tabBar
    [self setupTabBar];
//    在tabbar上添加一层view 用来切换背景颜色
    UIView *background = [[UIView alloc] init];
    background.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    background.frame = self.tabBar.bounds;
    [[UITabBar appearance] insertSubview:background atIndex:0];
    self.selectedIndex = 0;
    self.delegate = self;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).appIsOpen = YES;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
//    if (viewController == [tabBarController.viewControllers objectAtIndex:3] || viewController == [tabBarController.viewControllers objectAtIndex:2]){
//        
//        NewloginViewController * loginViewController = nil;
//        if (iPhone4) {
//            loginViewController = [[NewloginViewController alloc]initWithNibName:@"NewloginViewController4" bundle:[NSBundle mainBundle]];
//            
//        }else if (iPhone5){
//            
//            loginViewController = [[NewloginViewController alloc]initWithNibName:@"NewloginViewController5" bundle:[NSBundle mainBundle]];
//            
//        }else if (iPhone6){
//            
//            loginViewController = [[NewloginViewController alloc]initWithNibName:@"NewloginViewController6" bundle:[NSBundle mainBundle]];
//        }else{
//            
//            loginViewController = [[NewloginViewController alloc]initWithNibName:@"NewloginViewController6+" bundle:[NSBundle mainBundle]];
//        }
//        
//        [self presentViewController:loginViewController animated:YES completion:nil];
//        
//        return NO;
//    }
    return YES;
    
}
-(void)viewWillAppear:(BOOL)animated{

    NSLog(@"ces");
    [super viewWillAppear:YES];

}

//防止侧滑卡死
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([self isKindOfClass:[HomeViewController class]]||[self isKindOfClass:[MyQuanerViewController class]]||[self isKindOfClass:[FindViewController class]]||[self isKindOfClass:[SWRTableViewController class]]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }else{
        
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
    }
    
}
//设置底部TabBar控制器上的按钮
- (void)setupChildViewController
{
    //首页
    [self addOneChildViewController:[[HomeViewController alloc]init] title:@"首页" image:@"icon_shouye_close" selected:@"icon_shouye_close"];
    
    //圈儿
    [self addOneChildViewController:[[MyQuanerViewController alloc]init] title:@"圈儿" image:@"icon_quaner_close" selected:@"icon_quaner_close"];
    
    //发现
    [self addOneChildViewController:[[FindViewController alloc]init] title:@"发现" image:@"icon_faxian_close" selected:@"icon_faxian_close"];
    
    //我的
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SWRTableViewController" bundle:nil];
   
    SWRTableViewController *me = [sb instantiateInitialViewController];
   
    [self addOneChildViewController:me title:@"我的" image:@"icon_wode_close" selected:@"icon_wode_close"];
    
}

//设置公用控制器
- (void)addOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selected:(NSString *)selecetedImage
{
    // 设置文字的样式
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [WXYClassMethodsViewController colorWithHexString:@"#666666"]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : THEMECOLOR} forState:UIControlStateSelected];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selecetedImage];
    
    //自定义NavigationViewController用来包装
    
    ERNavigationViewController *nav = [[ERNavigationViewController alloc]initWithRootViewController:vc];
    
    [self addChildViewController:nav];
    
}


//因为tabBar属于私有属性不能直接修改，所以采取用KVC的办法修改里面的TabBar

- (void)setupTabBar
{
    [self setValue:[[ERTabBar alloc]init] forKey:@"tabBar"];
}

@end
