//
//  ERBassViewController.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/2.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ERBassViewController.h"
#import "UILabel+Create.h"
#import "WXYClassMethodsViewController.h"
#import "UICustomActionSheet.h"
#import "ArticleContentViewController.h"
#import "LXAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import "HUDView.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//自定义分享编辑界面所需要导入的头文件
#import <ShareSDKUI/SSUIEditorViewStyle.h>
@interface ERBassViewController ()

#define JHUDRGBHexAlpha(rgbValue,a)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define JHUDRGBA(r,g,b,a)               [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@property(nonatomic,strong)UIImageView * emptyImgView;

@property(nonatomic,strong)UIImageView * emptyDataView;

@property(nonatomic,strong)UIImageView * positionView;

@property(nonatomic,strong)UILabel * emptyDataLable;

@property(nonatomic,strong)UIImageView * emptyConsultImgView;

@property(nonatomic,strong)UIScrollView * emptyScrollView;

@end

@implementation ERBassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.loadingHudView = [[JHUD alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self viewWithCreateEmptyView];
    [self viewWithEmptyDataImgView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

}

-(void)sharewithtitle:(NSString *)title andimages:(NSArray *)images andtext:(NSString*)text andurl:(NSURL*)url andtype:(NSUInteger ) type{

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:images
                                        url:url
                                      title:title
                                       type:type];


    // 设置分享菜单栏样式（非必要）
    // 设置分享菜单的背景颜色
    [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1]];
    // 设置分享菜单颜色
    [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    // 设置分享菜单－取消按钮背景颜色
    [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    // 设置分享菜单－取消按钮的文本颜色
    [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor blackColor]];
    // 设置分享菜单－社交平台文本颜色
    [SSUIShareActionSheetStyle setItemNameColor:[UIColor blackColor]];
    // 设置分享菜单－社交平台文本字体
    [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
//    //设置分享编辑界面的导航栏颜色
//    [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor whiteColor]];
//    //设置编辑界面标题颜色
//    [SSUIEditorViewStyle setTitleColor:[UIColor blackColor]];
//    //设置取消发布标签文本颜色
//    [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor blackColor]];
//    
//    [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor blackColor]];
//    //设置分享编辑界面状态栏风格
//    [SSUIEditorViewStyle setStatusBarStyle:UIStatusBarStyleDefault];
    //设置简单分享菜单样式
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    
    
    
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                     items:@[@(SSDKPlatformTypeSinaWeibo),
                                                                             @(SSDKPlatformSubTypeQQFriend),
                                                                             @(SSDKPlatformSubTypeQZone),
                                                                             @(SSDKPlatformSubTypeWechatSession),
                                                                             @(SSDKPlatformSubTypeWechatTimeline),
                                                                             @(SSDKPlatformSubTypeWechatFav),
                                                                             @(SSDKPlatformTypeCopy)]
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                                   NSLog(@"分享成功!");
                                                                   if (platformType== SSDKPlatformTypeCopy) {
                                                                       [HUDView showMsg:@"复制成功!" inView:self.view];                                                                   } else {
                                                                           [HUDView showMsg:@"分享成功!" inView:self.view];
                                                                       };
                                                                   
                                                                   break;
                                                               case SSDKResponseStateFail:
                                                                   NSLog(@"分享失败%@",error);
                                                                   [HUDView showMsg:@"分享失败!" inView:self.view];

                                                                   break;
                                                               case SSDKResponseStateCancel:
                                                                   NSLog(@"分享已取消");
                                                                   break;
                                                               default:
                                                                   break;
                                                           }
                                                       }];
    //删除和添加平台示例
//    [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];//(默认微信，QQ，QQ空间都是直接跳客户端分享，加了这个方法之后，可以跳分享编辑界面分享)
    [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeSinaWeibo)];
//    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeCopy)];

}

-(void)loadingCircleAnimation
{
   
    self.loadingHudView.messageLabel.text = @"请稍等，正在拼命加载";
    self.loadingHudView.indicatorBackGroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.1];
    self.loadingHudView.indicatorForegroundColor = [UIColor lightGrayColor];
    [self.loadingHudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
}

-(void)loadingCircleJoinAnimation
{
    self.loadingHudView.messageLabel.text = @"请稍等，正在拼命加载";
    self.loadingHudView.indicatorForegroundColor = JHUDRGBA(60, 139, 246, .5);
    self.loadingHudView.indicatorBackGroundColor = JHUDRGBA(185, 186, 200, 0.3);
    [self.loadingHudView showAtView:self.view hudType:JHUDLoadingTypeCircleJoin];
}

-(void)loadingDotAnimation
{
    self.loadingHudView.messageLabel.text = @"请稍等，正在拼命加载";
    self.loadingHudView.indicatorBackGroundColor = [UIColor whiteColor];
    self.loadingHudView.indicatorForegroundColor = [UIColor orangeColor];
    [self.loadingHudView showAtView:self.view hudType:JHUDLoadingTypeDot];
}

-(void)loadingCustomAnimations
{
    NSMutableArray * images = [NSMutableArray array];
    for (int index = 0; index<=19; index++) {
        NSString * imageName = [NSString stringWithFormat:@"%d.png",index];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    
    self.loadingHudView.indicatorViewSize = CGSizeMake(80, 80);
    self.loadingHudView.customAnimationImages = images;
    self.loadingHudView.messageLabel.text = @"请稍等，正在拼命加载";
    [self.loadingHudView showAtView:self.view hudType:JHUDLoadingTypeCustomAnimations];
    
}

-(void)loadingGifAnimations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loadinggif3" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    self.loadingHudView.gifImageData = data;
    self.loadingHudView.indicatorViewSize = CGSizeMake(110, 110); // Maybe you can try to use (100,250);
    self.loadingHudView.messageLabel.text = @"请稍等，正在拼命加载";
    [self.loadingHudView showAtView:self.view hudType:JHUDLoadingTypeGifImage];
}


-(void)loadingFailure
{
    self.loadingHudView.indicatorViewSize = CGSizeMake(100, 100);
    self.loadingHudView.messageLabel.text = @"网络连接失败，请检查网络连接 !";
    [self.loadingHudView.refreshButton setTitle:@"重试" forState:UIControlStateNormal];
    self.loadingHudView.customImage = [UIImage imageNamed:@"zhanweitu_yuanxing_170-170"];
    [self.loadingHudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
    
}

-(void)loadingFailure2
{
    self.loadingHudView.indicatorViewSize = CGSizeMake(150, 150);
    self.loadingHudView.messageLabel.text = @"加载失败，请重新尝试";
    [self.loadingHudView.refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    self.loadingHudView.customImage = [UIImage imageNamed:@"zhanweitu_yuanxing_170-170"];
    [self.loadingHudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
}

-(void)loadinghide
{
    [self.loadingHudView hide];
    
}

//- (void)showNavigation
//{
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"root_navigation"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//}
//
//- (void)hiddenNavigation
//{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//    self.navigationController.navigationBar.translucent = YES;
//    
//}

-(void)showCustomHudSingleLine:(NSString *)text
{
    
    if (text==nil||text.length==0) {
        return;
    }
    
    UIView *customHud = [[UIView alloc] init];
    customHud.tag = 888;
    
    
    
    UILabel *contenLabel = [[UILabel alloc]initWithFrame1:CGRectMake(10, 10, kScreenWidth-20, kScreenWidth - 20) text:text font:[UIFont boldSystemFontOfSize:16.f] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] numberOfLines:0 lineSpacing:0];
    
    
    contenLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat width = contenLabel.frame.size.width + 20.0;
    CGFloat height = contenLabel.frame.size.height + 20.0;
    customHud.frame = CGRectMake((kScreenWidth - width)/2, (kScreenHeight - height)/2, width, height);
    customHud.layer.masksToBounds = YES;
    customHud.layer.cornerRadius = 8;
    customHud.backgroundColor = [UIColor blackColor];
    customHud.alpha = 0;
    
    
    [customHud addSubview:contenLabel];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:customHud];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        customHud.alpha = 0.8;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.5f animations:^{
            
            customHud.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            customHud.hidden = YES;
            
            [customHud removeFromSuperview];
            
        }];
        
    }];
}

-(void)hideCustomHud
{
    UIView *view = [[[UIApplication sharedApplication].delegate window] viewWithTag:888];
    [UIView animateWithDuration:0.3f animations:^{
        
        view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        view.hidden = YES;
        
        [view removeFromSuperview];
    }];
}




-(void)viewWithCreateEmptyView{
    //    self.emptyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    //    self.emptyScrollView.backgroundColor =  [ClassMethodsViewController colorWithHexString:@"#fdfcfc"];
    //    self.emptyScrollView.contentSize = CGSizeMake(self.emptyScrollView.width,self.emptyScrollView.height+1);
    //    self.emptyScrollView.showsVerticalScrollIndicator = NO;
    //    self.emptyScrollView.hidden = YES;
    
    
    self.emptyImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.emptyImgView.hidden = YES;
    self.emptyImgView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self.view addSubview:self.emptyImgView];
}

-(void)showEmptyImgViewWithImgName:(NSString *)imgName
{
    self.emptyImgView.hidden = NO;
    UIImage * Img = [UIImage imageNamed:imgName];
    self.emptyImgView.frame = CGRectMake((kScreenWidth-Img.size.width)/2.0, (kScreenHeight-2*64-Img.size.height)/2.0, Img.size.width, Img.size.height);
    [self.emptyImgView setImage:Img];
    [self.view bringSubviewToFront:self.emptyImgView];
    
    
}

-(void)hiddenEmptyAllView{
    self.emptyImgView.hidden = YES;
    [self.view sendSubviewToBack:self.emptyImgView];
    self.emptyDataView.hidden = YES;
    [self.view sendSubviewToBack:self.emptyDataView];
    self.emptyDataLable.hidden = YES;
    [self.view sendSubviewToBack:self.emptyDataLable];
    self.emptyDataLable.text = nil;
    
}

-(void)viewWithEmptyDataImgView{
    
    UIImage * img = [UIImage imageNamed:@"暂无数据"];
    self.emptyDataView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-img.size.width)/2.0, (kScreenHeight-2*64-img.size.height)/2.0, img.size.width, img.size.height)];
    [self.emptyDataView setImage:img];
    self.emptyDataView.hidden = YES;
    [self.view addSubview:self.emptyDataView];
    
    self.emptyDataLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.emptyDataView.frame.origin.y + self.emptyDataView.frame.size.height+20,kScreenWidth , 20)];
    self.emptyDataLable.textAlignment = NSTextAlignmentCenter;
    self.emptyDataLable.textColor = [WXYClassMethodsViewController colorWithHexString:@"#cccccc"];
    self.emptyDataLable.font = [UIFont systemFontOfSize:13];
    self.emptyDataLable.hidden = YES;
    [self.view addSubview:self.emptyDataLable];
    
}

-(void)showEmptyNoDataViewWithTitle:(NSString*)title{
    
    [self.view bringSubviewToFront:self.emptyDataView];
    [self.view bringSubviewToFront:self.emptyDataLable];
    self.emptyDataView.hidden = NO;
    self.emptyDataLable.hidden = NO;
    self.emptyDataLable.text = title;
}

- (void)positioningImage:(NSUInteger )type
{
    UIImage * img = nil;
    
    self.positionView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-img.size.width)/2.0, (kScreenHeight-2*64-img.size.height)/2.0, img.size.width, img.size.height)];
    
    [self.positionView setImage:img];
    
    [self.view addSubview:self.positionView];
}
- (void)hiddenPositingImage
{
    if (self.positionView == nil) {
        
        [self.positionView removeFromSuperview];
        self.positionView = nil;
    }
}
//将时间戳转换成 年 月 日 时 分
-(NSString *)changeTimeToString:(NSString *)String
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    NSString *dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:String.integerValue]];
    
    return dateString;
    //    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[String intValue]];
    
    //    NSString *string = [NSString stringWithFormat:@"%@",confromTimesp];
    
    //    NSRange rangeYear = {0, 4};
    
    //    NSString *stringYear = [string substringWithRange:rangeYear];
    
    //    NSRange rangeMouth = {5, 2};
    
    //    NSString *stringMouth = [string substringWithRange:rangeMouth];
    
    //    NSRange rangeDay = {8, 2};
    
    //    NSString *stringDay = [string substringWithRange:rangeDay];
    
    //    NSRange rangeHour = {11, 2};
    
    //    NSString *stringHour = [string substringWithRange:rangeHour];
    
    //    NSRange rangeminute = {14, 2};
    
    //    NSString *stringminute = [string substringWithRange:rangeminute];
    
    //    NSString *timeString = [NSString stringWithFormat:@"%@年%@月%@日 %@:%@",stringYear,stringMouth,stringDay,stringHour,stringminute];
    
    //    MyNSLog("=====%@",timeString);
    
    //    return timeString;
}

-(UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
