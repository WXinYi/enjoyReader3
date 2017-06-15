//
//  SYADViewController.m
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ERADViewController.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFNetworking.h>
#import "ERMainController.h"
#import "ERADItem.h"
#import "GuideViewController.h"

static NSString *const SYCode2 = @"";


@interface ERADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backGroupView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@property (nonatomic,strong) ERADItem *item;
//定一个计时器的属性用来记录左上角的倒计时
@property (nonatomic,weak) NSTimer *timer;

@end

@implementation ERADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jumpButton.hidden =YES;
    NSLog(@"网络缓存大小cache = %.2fMB",[PPNetworkCache getAllHttpCacheSize]/1024/1024.f);
    
    //检查网络状态
    [PPNetworkHelper checkNetworkStatusWithBlock:^(PPNetworkStatus status) {
        switch (status) {
            case PPNetworkStatusUnknown:
            case PPNetworkStatusNotReachable: {
                
                
                NSLog(@"无网络,加载缓存数据");
                break;
            }
            case PPNetworkStatusReachableViaWWAN:
            case PPNetworkStatusReachableViaWiFi: {
                NSLog(@"有网络,请求网络数据");
                break;
            }
        }
    }];

    self.jumpButton.layer.masksToBounds = YES;
    self.jumpButton.layer.cornerRadius = 7;
    
    //设置启动背景图片
    [self setupLaunchImage];
    
    //设置启动页面上的广告图片
    //关掉广告
    [self setupADData];
    
    
}

//每隔一秒钟进行一次操作
- (void)timerChange
{
    //因为倒计时是三秒所以定义一个属性来记录倒计时的时间
    static NSInteger i = 3;
    i--;
    
    //拼接倒计时数据
    NSString *title = [NSString stringWithFormat:@"%ld 秒|跳过",i];
    //赋值于左上角按钮字体
    [_jumpButton setTitle:title forState:UIControlStateNormal];
    
    //当计时器的数字为0时则进入主控制器
    if (i == -1) {
        
        [self jumpBtn];
    }
}

//设置启动页面上的广告
//插入广告图片 -> 活数据 -> 请求数据 -> 查看接口文档 -> AFN
- (void)setupADData
{
    // 1. 创建一个请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.创建请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = SYCode2;
    
    [mgr GET:@"" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *_Nullable responseObject) {
        
        //获取广告字典
        NSDictionary *adDic = [responseObject[@"ad"] firstObject];
        
        //字典转模型
        ERADItem *item = [ERADItem mj_objectWithKeyValues:adDic];
        
        _item = item;
        
        //把广告数据展示到广告界面
        UIImageView *adImageView = [[UIImageView alloc]init];
        [self.containView addSubview:adImageView];
        //设置广告显示在控制器中的尺寸，广告的图片宽度等于屏幕的宽度，高度根据一定的比例进行缩放个扩大
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h;
        
        if (item.w) {
            h = w / item.w * item.h;
        }
        if (h > [UIScreen mainScreen].bounds.size.height * 0.7) {
            h = [UIScreen mainScreen].bounds.size.height * 0.85;
        }
       
        adImageView.frame = CGRectMake(0, 0, w, h);
        
        //设置广告图片
        [adImageView sd_setImageWithURL:[NSURL URLWithString:item.w_picurl]];
        
        //添加一个点击手势，当点击广告是会进入广告的网页
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        adImageView.userInteractionEnabled = YES;
        [adImageView addGestureRecognizer:tap];
        self.jumpButton.hidden = NO;
        //开启一个定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"%@",error);
        [self jumpBtn];

    }];
}

//点击广告左上角的计时器即可进入广告网页
- (void)tap
{
    //加载广告网页
    NSURL *url = [NSURL URLWithString:_item.ori_curl];
    
    //在打开浏览器之前要先确认网址是否存在
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }
}
#pragma mark - 屏幕适配

//根据不同的机型进行不同的启动页面设置，在PCH文件里定义每个型号手机的高度，再根据不同的型号是设置不同的屏幕启动画面的背景图片
- (void)setupLaunchImage
{
    UIImage *image;
    
    if (iPhone6P) {
        image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if (iPhone6){
        image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    }else if (iPhone5){
        image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    }else if (iPhone4){
        image =[UIImage imageNamed:@"LaunchImage-700"];
    }
    
    self.backGroupView.image = image;
}


//点击页面右上角计时器按钮会直接跳过广告页面进入主页面

- (IBAction)jumpBtn {

    //进入主控制器的方法有三种
    /*
     - push 因为广告也没有导航栏所以不能用push
     - modal modal之后广告控制器不会销毁
     - 修改窗口gen控制器  广告控制器会销毁并把主页面设置成当前控制器的根控制器
     */
    
    // 使用 NSUserDefaults 读取用户数据
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    
    if (![useDef boolForKey:@"notFirst"]) {
        // 如果是第一次进入引导页
        GuideViewController *mainVc = [[GuideViewController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController= mainVc;
    }else{
        ERMainController *mainVc = [[ERMainController alloc]init];
        mainVc.view.backgroundColor = [UIColor whiteColor];
        mainVc.tabBar.tintColor = [UIColor redColor];
        [UIApplication sharedApplication].keyWindow.rootViewController= mainVc;
    }
    

//  //点击按钮跳入主页面，这时候广告页面会销毁，同时会把主页面设置成当前控制器的根控制器。
  
//
//动画开场
//    [UIView animateWithDuration:0.5 animations:^{
//        ERMainController *mainVc = [[ERMainController alloc]init];
//        mainVc.view.backgroundColor = [UIColor whiteColor];
//        mainVc.tabBar.tintColor = [UIColor redColor];
//        
//        [UIApplication sharedApplication].keyWindow.rootViewController= mainVc;
//        
//    }];
    
    //销毁计时器
    [_timer invalidate];
}

//进入广告页面的时候隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
