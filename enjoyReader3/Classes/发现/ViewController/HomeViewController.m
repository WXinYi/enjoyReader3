//
//  HomeViewController.m
//  enjoyReader3
//
//  Created by WangXy on 16/8/18.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "HomeViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "HomeMaximTableViewCell.h"
#import "HotBookTableViewCell.h"
#import "RecentlyUnfoldCell.h"
#import "HomeHeaderView.h"
#import "RecentlyFoldCell.h"
#import "AppDelegate.h"
#import "BookShelCell.h"
#import "ShowViewController.h"
#import "MybooksViewController.h"
#import "SearchViewViewController.h"
#import "DKNightVersion.h"
#import "DKNightVersionManager.h"
@interface HomeViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource,UITableViewDataSource,UITableViewDelegate>
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic ,strong) NSMutableArray *arr;

@property(nonatomic,strong)NewPagedFlowView *pageFlowView;
@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,assign)BOOL isShow;
@end

@implementation HomeViewController
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.dk_tintColorPicker = DKColorPickerWithKey(BBG);

    self.view.dk_backgroundColorPicker =  DKColorPickerWithKey(BBG);
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navLabel.text = @"阅来客栈";
    navLabel.textColor = [self colorWithHexString:@"#BA1B18"];
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:@"shouye_icon_sousuo" hightImage:@"shouye_icon_sousuo" target:self action:@selector(pushSearch)];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BBG);
    

    
    _isShow = NO;
    self.navigationController.navigationBar.translucent = NO;
    _arr = [NSMutableArray arrayWithObjects:@"hah", nil];
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    _tableview.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _tableview.delegate =self;
    _tableview.separatorStyle = NO;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] init];
    for (int index = 0; index < 5; index++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite%02d",index]];
        [self.imageArray addObject:image];
        
    }
    
    [self.view addSubview:_tableview];

    NSURL * url = ((AppDelegate *)[UIApplication sharedApplication].delegate).url;
    ;
    if(url){
        
        ShowViewController *vc = [[ShowViewController alloc]init];
        vc.isPush = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);

    }
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString* night = [user objectForKey:@"NightModel"];
    if ([night isEqualToString:@"ninght"]) {
    
    }else{
    }
}
-(void) viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 2;
        
    }else if(section == 1){
        
        return _arr.count;
        
    }else
        
        return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
//            第一组
            switch (indexPath.row) {
                case 0:
                    
                    if (iPhone4||iPhone5) {
                        
                        return 120;
                    
                    }else if (iPhone6P){
                        return 180;
                    }
                    
                    return  160;
                    
                    break;
                    
                case 1:
                    return 80;
                    
                    break;
                    
                default:
                    break;
            }

            break;
            
       case 1:
//                    第二组
            if (_isShow) {
                return 75;
            }
            return 180;
    
            break;
//            第三组
       case 2:
            
            return 88;
            
            break;
            
        default:
            break;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomeHeaderView *HeaderView =[[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:nil options:nil] firstObject];
    if (section == 1) {
        HeaderView.frame = CGRectMake(0, 0, kScreenWidth, 50);
        HeaderView.headerTitle.text = @"最近看的书";
        HeaderView.headerIcon.image = [UIImage imageNamed:@"shouye_icon_zuijinkandeshu"];
        [HeaderView.HeaderBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
        HeaderView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        HeaderView.headerTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        HeaderView.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);

        return HeaderView;
        
    }else if (section == 2 ){
        
        HeaderView.frame = CGRectMake(0, 0, kScreenWidth, 50);
        
        HeaderView.headerTitle.text = @"最新发表";
        HeaderView.jumpImage.hidden = YES;
        HeaderView.headerIcon.image = [UIImage imageNamed:@"shouye_icon_zuixinfabiao"];
        HeaderView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        HeaderView.headerTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        HeaderView.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
        return HeaderView;
    
    }
       return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
//            第一组 轮播图+ 金句
            switch (indexPath.row) {
                case 0:{
//                  轮播图
                    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth - 113) * 9 / 16 )];
                    _pageFlowView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
                    _pageFlowView.delegate = self;
                    _pageFlowView.dataSource = self;
                    _pageFlowView.minimumPageAlpha = 0.4;
                    _pageFlowView.minimumPageScale = 0.95;
                    //提前告诉有多少页
                    _pageFlowView.orginPageCount = self.imageArray.count;
                    _pageFlowView.isOpenAutoScroll = YES;
                    //初始化pageControl
                    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 18, kScreenWidth, 8)];
                    _pageFlowView.pageControl = pageControl;
                    [_pageFlowView addSubview:pageControl];
                    UIScrollView *bottomScrollView;
                    if (iPhone5||iPhone4) {
                        bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 135)];
                    }else{
                         bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160)];
                    }
                    [bottomScrollView addSubview:_pageFlowView];
                    
                    [cell.contentView addSubview:bottomScrollView];
                    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
                    return cell;
                }
                    break;
                case 1:{
//                  金句
                    HomeMaximTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeMaximTableViewCell" owner:nil options:nil] firstObject];
                    cell.yinhaoImage.dk_imagePicker = DKImagePickerWithNames(@"image_yinhao",@"image_yinhao_yejian",@"image_yinhao_yejian");
                    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
                    cell.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
                    cell.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTFOUR);
                    cell.zanBtn.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTFOUR);
                    cell.xinLabel.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTFOUR);
                    cell.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                    
                }
                    break;
                    
                default:
                    break;
            }
            break;
//         第二组   最近看的书
        case 1:
        {
        
            if (_isShow == NO) {
                RecentlyFoldCell *bookcell = [[[NSBundle mainBundle] loadNibNamed:@"RecentlyFoldCell" owner:nil options:nil] firstObject];
                if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
                    bookcell.View1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                    bookcell.View1.layer.shadowOffset = CGSizeMake(3.0, 3.0);
                    bookcell.View1.layer.shadowOpacity = YES;
                    //                [bookcell.btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
                    
                    bookcell.View2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                    bookcell.View2.layer.shadowOffset = CGSizeMake(3.0, 3.0);
                    bookcell.View2.layer.shadowOpacity = YES;
                    bookcell.View3.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                    bookcell.View3.layer.shadowOffset = CGSizeMake(3.0, 3.0);
                    bookcell.View3.layer.shadowOpacity = YES;
                    
                }
                bookcell.selectionStyle = UITableViewCellSelectionStyleNone;
                               bookcell.dk_backgroundColorPicker = DKColorPickerWithKey(MYBOOK);
                return bookcell;
            }
            
            BookShelCell *bookcell = [[[NSBundle mainBundle] loadNibNamed:@"BookShelCell" owner:nil options:nil] firstObject];
            bookcell.myBookName.text = [NSString stringWithFormat:@"%d",arc4random()%100];
            bookcell.selectionStyle = UITableViewCellSelectionStyleNone;
            return bookcell;
        
        }
            break;
            
        case 2:{
            RecentlyUnfoldCell *bookcell = [[[NSBundle mainBundle] loadNibNamed:@"RecentlyUnfoldCell" owner:nil options:nil] firstObject];
            bookcell.selectionStyle = UITableViewCellSelectionStyleNone;
            bookcell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
            bookcell.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTWO);
            bookcell.timeLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
            bookcell.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
            return bookcell;
        
        }
            break;
       
        default:
            
            break;
    }
    return nil;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2 ) {
        
        ShowViewController *vc = [[ShowViewController alloc]init];
        vc.isPush = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}

//展开
-(void)show:(UIButton *)sender{
    
    
    MybooksViewController *vc = [[MybooksViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    if (_isShow == NO) {
//        NSLog(@"hahah");
//        _isShow = YES;
//        NSMutableArray *addindexPaths = [[NSMutableArray alloc] init];
//        NSMutableArray *deleindexPaths= [[NSMutableArray alloc] init];
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//        [deleindexPaths addObject: indexPath];
//        [_arr removeAllObjects];
//        [self.tableview beginUpdates];
//        [self.tableview deleteRowsAtIndexPaths:deleindexPaths withRowAnimation:UITableViewRowAnimationBottom];
//        [self.tableview endUpdates];
//        for (int i=0; i<9; i++) {
//            NSString *s = [[NSString alloc] initWithFormat:@"hello %d",i];
//            [_arr addObject:s];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
//            [addindexPaths addObject: indexPath];
//        }
//        [self.tableview beginUpdates];
//        [self.tableview insertRowsAtIndexPaths:addindexPaths withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableview endUpdates];
//        
//    }else{
//        
//        _isShow = NO;
//        
//        NSMutableArray *addindexPaths = [[NSMutableArray alloc] init];
//        NSMutableArray *deleindexPaths= [[NSMutableArray alloc] init];
//        
//        for (int i=0; i<9; i++) {
//            [_arr removeAllObjects];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
//            [addindexPaths addObject: indexPath];
//        }
//        
//        [self.tableview beginUpdates];
//        [self.tableview deleteRowsAtIndexPaths:addindexPaths withRowAnimation:UITableViewRowAnimationBottom];
//        [self.tableview endUpdates];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//        [deleindexPaths addObject: indexPath];
//        _arr = [NSMutableArray arrayWithObjects:@"hah", nil];
//        
//        [self.tableview beginUpdates];
//        [self.tableview insertRowsAtIndexPaths:deleindexPaths withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableview endUpdates];
//        
//    }
}

//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(self.tableview.contentSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);  //保存到相册中
    
    return theImage;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    
}

#pragma mark 轮播view Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    
    return CGSizeMake(kScreenWidth - 80, ( kScreenWidth - 113 ) * 9 / 16);
    
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
}

#pragma mark 轮播图View Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    
    if (!bannerView) {
        
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, (kScreenWidth - 113) * 9 / 16)];
        
        bannerView.layer.cornerRadius = 4;
        
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
    
}

#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    
    if (_imageArray == nil) {
        
        _imageArray = [NSMutableArray array];
        
    }
    
    return _imageArray;
}

//设置状态栏字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
    
}
-(void)pushSearch{

    SearchViewViewController *vc = [[SearchViewViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
