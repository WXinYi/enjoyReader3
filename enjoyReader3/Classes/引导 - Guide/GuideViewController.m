//
//  GuideViewController.m
//  enjoyReader3
//
//  Created by WangXy on 16/9/7.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "GuideViewController.h"
#import "NewPagedFlowView.h"
#import "ERMainController.h"
#import "PGIndexBannerSubiew.h"
@interface GuideViewController ()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource>
@property (nonatomic,strong) UIScrollView *guideScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *jumpBtn;
@property (strong, nonatomic) NewPagedFlowView * pageFlowView;
@property (strong, nonatomic)UIScrollView *bottomScrollView;
@end

@implementation GuideViewController
- (IBAction)jumpoverClick:(UIButton *)sender {
    
    BOOL flag= YES;
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [useDef setBool:flag forKey:@"notFirst"];
    [useDef synchronize];
    
    ERMainController *mainVc = [[ERMainController alloc]init];
    mainVc.view.backgroundColor = [UIColor whiteColor];
    mainVc.tabBar.tintColor = [UIColor redColor];
    [UIApplication sharedApplication].keyWindow.rootViewController= mainVc;

    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    
    [_pageFlowView stopTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jumpBtn.titleLabel.textColor = [WXYClassMethodsViewController colorWithHexString:@"#BA1B18"];
    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,276)];

    if (iPhone4||iPhone5) {
        _pageFlowView.frame =CGRectMake(0, 0, kScreenWidth,190);
    }
    
    _pageFlowView.backgroundColor = [UIColor clearColor];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.5;
    _pageFlowView.minimumPageScale = 0.85;
    //提前告诉有多少页
    _pageFlowView.orginPageCount = 3;
    
    _pageFlowView.isOpenAutoScroll = NO;
    
    _pageFlowView.pageControl = _pageControl;

    if (iPhone4||iPhone5) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-50, [UIScreen mainScreen].bounds.size.width, 190)];
    }else{
   _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-50, [UIScreen mainScreen].bounds.size.width, 276)];
    }
    [_bottomScrollView addSubview:_pageFlowView];

    [self.view addSubview:_bottomScrollView];
}

-(void)fullScreenshots{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
}


-(void)save{
    
    UIGraphicsBeginImageContext(_pageFlowView.bounds.size); //currentView 当前的view
    
    [_pageFlowView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);  //保存到相册中
    
}


//获得屏幕图像
- (UIImage *)imageFromView: (UIScrollView *) theView
{
    
    UIGraphicsBeginImageContext(theView.contentSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);  //保存到相册中

    return theImage;
}

//获得某个范围内的屏幕图像
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}
#pragma mark 轮播view Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    
    if (iPhone4||iPhone5) {
        return CGSizeMake(200, 190);
    }
    return CGSizeMake(298, 276);
    
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {

    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
}

#pragma mark 轮播图View Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return 3;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    
    if (!bannerView) {
        
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, 298, 276)];
        bannerView.coverView.hidden = YES;
        bannerView.layer.cornerRadius = 4;
        
        bannerView.layer.masksToBounds = YES;
    }
     bannerView.mainImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"yindaoye_kapian_0%ld",(long)index+1]];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
