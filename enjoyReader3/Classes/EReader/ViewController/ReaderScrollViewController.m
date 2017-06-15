//
//  E_ScrollViewController.m
//  E_Reader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ReaderScrollViewController.h"
#import "ReaderViewController.h"
#import "ReaderDataSource.h"
#import "EveryChapter.h"
#import "E_Paging.h"
#import "CommonManager.h"
#import "SettingTopBar.h"
#import "SettingBottomBar.h"
#import "E_ContantFile.h"
#import "DrawerView.h"
#import "CDSideBarController.h"
#import "WebViewControler.h"
#import "HUDView.h"
#import "SettingFontBottomBar.h"
#import "ChangeSourceViewController.h"
#import "ALBatteryView.h"
#import "ReaderADView.h"

@interface ReaderScrollViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,ReaderViewControllerDelegate,E_SettingTopBarDelegate,E_SettingBottomBarDelegate,E_DrawerViewDelegate,UIActionSheetDelegate,SettingFontBottomBarDelegate>
{
    UIPageViewController * _pageViewController;
    E_Paging             * _paginater;
    BOOL _isChangePage;    //是不是翻页；
    BOOL _isTurnOver;     //是否跨章；
    BOOL _isRight;       //翻页方向  yes为右 no为左
    BOOL _isMark;         //是不是点击书签
    BOOL _pageIsAnimating;          //某些特别操作会导致只调用datasource的代理方法 delegate的不调用
    BOOL openBefore;         //是不是向前翻页；
    UITapGestureRecognizer *tapGesRec;
    SettingTopBar *_settingToolBar;
    SettingBottomBar *_settingBottomBar;
    SettingFontBottomBar *_settingFontBottomBar;
    UIButton *_searchBtn;
    UIButton *_markBtn;
    UIButton *_shareBtn;
    CGFloat   _panStartY;
    UIImage  *_themeImage;
    NSString *urlStr;//小说章节原网页
    NSString *SourceTitle;//小说源名称
    CDSideBarController *sideBar;
    UILabel *downLoadlabel;
    BOOL bottomToolIsHidden;//底部工具栏是隐藏的
    UIView *downloadView;
    NSString      *_searchWord;//用来接受搜索页面的keyword
    BOOL ishadDownLoadNextChapter; //无网状态下一章是否缓存
    ReaderADView * adView;//广告 view
    UIButton *adBtn;//广告btn
    BOOL openAD;
    UILabel *pageLabel;//当前页码的label
    UILabel *chapterTitleLabel;//当前章节名称
    NSUInteger pageNow;//记录右下角页数的角标
    NSString *openUrl;//广告的点击链接
    NSUInteger showPage;//书签展示的页码
}

@property (copy, nonatomic) NSString* chapterTitle_;
@property (copy, nonatomic) NSString* chapterContent_;
@property (unsafe_unretained, nonatomic) NSUInteger fontSize;  ///int!
@property (unsafe_unretained, nonatomic) NSUInteger readOffset;
@property (assign, nonatomic) NSInteger readPage;
@property (assign, nonatomic) NSInteger nowPage;
@property (assign ,nonatomic)NSUInteger nowChapter;
@property (nonatomic,strong) NSArray * allChapterArr;
@property (nonatomic ,strong) NSArray *adArr;
@end


@implementation ReaderScrollViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[Chapter shareInstance] updateDownLoadArr];
    [[Chapter shareInstance] updateAllchapters];
    
    //当前章节
    _nowChapter= [CommonManager Manager_getChapterBefore:[[BookInfo siged] getBookID]];
    //设置总章节数
    [ReaderDataSource shareInstance].totalChapter = [[Chapter shareInstance] getChapters].count;

    _allChapterArr =[[Chapter shareInstance] getChapters];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [self openChapter:_nowChapter];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    [self loadAD];
    
    self.fontSize = [CommonManager fontSize];
    _pageIsAnimating = NO;
    //设置背景主题
    NSInteger themeID = [CommonManager Manager_getReadTheme];
    if (themeID == 1) {
        _themeImage = nil;
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)themeID]];
    }
    tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callToolBar)];
    
    [self.view addGestureRecognizer:tapGesRec];
    
    //添加调整亮度的手势
    UIPanGestureRecognizer *panGesRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(LightRegulation:)];
    
    //    panGesRec.maximumNumberOfTouches = 2;
    
    panGesRec.minimumNumberOfTouches = 2;
    
    [self.view addGestureRecognizer:panGesRec];
   
    
    
    
}

-(void)loadAD{


    _adArr = [[NSArray alloc]init];
    NSArray *ADopen = [[NSUserDefaults standardUserDefaults] objectForKey:@"ad_open"];
    NSString *ADlast = [NSString stringWithFormat:@"%@",ADopen[3]];
    if ([ADlast isEqualToString:@"1"]) {
       
        NSDictionary *params = @{@"source":KSource,@"channel":KReaderAd,@"os":KAdOs};
        
        [XYNetworking GET:KAdUrl params:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            
            _adArr = responseObject;
            if (_adArr.count>0 && _adArr) {
                 openAD = YES;
            }else{
                openAD = NO;
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            openAD = NO;
        }];
        
        
    }else{
        openAD= NO;
    }

}
//调整亮度
- (void)LightRegulation:(UIPanGestureRecognizer *)recognizer{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan:
        {
            
            _panStartY = touchPoint.y;
        }
            break;
        case UIGestureRecognizerStateChanged:{
        
            CGFloat offSetY = touchPoint.y - _panStartY;
           // NSLog(@"offSetY == %f",offSetY);
            CGFloat light = [UIScreen mainScreen].brightness;
            if (offSetY >=0 ) {
              
                CGFloat percent = offSetY/self.view.frame.size.height;
                CGFloat regulaLight =  light -percent ;
                if (regulaLight >= 1.0) {
                    regulaLight = 1.0;
                }
                [[UIScreen mainScreen] setBrightness:regulaLight];
            }else{
                CGFloat percent = offSetY/self.view.frame.size.height;
                CGFloat regulaLight = light - percent;
                if (regulaLight <= 0.0) {
                    regulaLight = 0.0;
                }
                [[UIScreen mainScreen] setBrightness:regulaLight];
            
            
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
        
        }
            break;
        default:
            break;
    }
}
//点击字体按钮
-(void)callFontBar{
    
    
    
    //    SettingFontBottomBar
    if (_settingFontBottomBar == nil) {
        [self callToolBar];
        _settingFontBottomBar=[[SettingFontBottomBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 100)];
        [self.view addSubview:_settingFontBottomBar];
        _settingFontBottomBar.delegate = self;
        [_settingFontBottomBar showFontBar];
        [self shutOffPageViewControllerGesture:YES];
        
    }else{
        
        [_settingFontBottomBar hideFontBar];
        _settingFontBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
        
    }
    
}

#pragma 弹出上下工具栏
- (void)callToolBar{
    if (_settingFontBottomBar!=nil) {
        [self callFontBar];
    }else{
    
    if (_settingToolBar == nil) {
        
        _settingToolBar= [[SettingTopBar alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 84)];
    
        UIButton *backBtn = [UIButton buttonWithType:0];
        backBtn.frame = CGRectMake(10, 20, 60, 44);
        [backBtn setTitle:@" 返回" forState:0];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn setTitleColor:[UIColor whiteColor] forState:0];
        [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
        [_settingToolBar addSubview:backBtn];
        
        UIButton *bookMarkBtn = [UIButton buttonWithType:0];
        bookMarkBtn.frame = CGRectMake(_settingToolBar.frame.size.width  - 50, 30, 30, 30);
        
        NSRange range = [_paginater rangeOfPage:_readPage];
        
        if ([CommonManager checkIfHasBookmark:range withChapter:_nowChapter+1]) {
            
            bookMarkBtn.selected = YES;
            
        }else{
            
            bookMarkBtn.selected = NO;
        }
        
        if (bookMarkBtn.selected == YES) {
            
            [bookMarkBtn setImage:[UIImage imageNamed:@"书签r"] forState:0];
            
            
        }else{
            
            [bookMarkBtn setImage:[UIImage imageNamed:@"书签x"] forState:0];
            
        }
        
        [bookMarkBtn addTarget:self action:@selector(bookMarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_settingToolBar addSubview:bookMarkBtn];
        
      
        UIButton *openWebBtn = [UIButton buttonWithType:0];
        openWebBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [openWebBtn setBackgroundColor:[UIColor blackColor]];
        openWebBtn.frame = CGRectMake(0, _settingToolBar.frame.size.height-20, _settingToolBar.frame.size.width, 20);
        NSString *sourceTitle = [NSString stringWithFormat:@"%@",[[BookSource shareInstance] getSourceTitle]];
        [openWebBtn setTitle:[NSString stringWithFormat:@"本章内容由 %@ 提供，点击查看原网页",sourceTitle] forState:0];
        
        [openWebBtn setTitleColor:[UIColor whiteColor] forState:0];
        [openWebBtn addTarget:self action:@selector(openWebClick) forControlEvents:UIControlEventTouchUpInside];
        [_settingToolBar addSubview:openWebBtn];
        
        
        [self.view addSubview:_settingToolBar];
        
        _settingToolBar.delegate = self;
        [_settingToolBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
       
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        
        
        UIButton *changeSourceBtn = [UIButton buttonWithType:0];
        [changeSourceBtn setTitle:@"换源" forState:0];
        changeSourceBtn.frame = CGRectMake(_settingToolBar.frame.size.width  - 120, 21, 60, 44);
        [changeSourceBtn addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventTouchUpInside];
        [_settingToolBar addSubview:changeSourceBtn];
        
    }else{
        
        //隐藏下拉按钮
        [self hideMultifunctionButton];
        [_settingToolBar hideToolBar];
        
        _settingToolBar = nil;
        [self shutOffPageViewControllerGesture:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
    }
    
    if (_settingBottomBar == nil) {
        
        _settingBottomBar = [[SettingBottomBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kBottomBarH)];
        [self.view addSubview:_settingBottomBar];
        _settingBottomBar.chapterTotalPage = _paginater.pageCount;
        _settingBottomBar.chapterCurrentPage = _readPage;
        _settingBottomBar.currentChapter = _nowChapter;
        _settingBottomBar.delegate = self;
        [_settingBottomBar showToolBar];
        bottomToolIsHidden =NO;
        [self shutOffPageViewControllerGesture:YES];
        
    }else{
        
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        bottomToolIsHidden = YES;
        downloadView.hidden = YES;
        [self shutOffPageViewControllerGesture:NO];
    
    }
    }
}
#pragma mark --- 换源点击方法
-(void)changeSource{

    [CommonManager saveCurrentPage:_readPage];
    [CommonManager saveCurrentChapter:_nowChapter];
    ChangeSourceViewController *changeVC = [[ChangeSourceViewController alloc]init];
    
    [self presentViewController:changeVC animated:YES completion:nil];

}

-(void)openWebClick{
    
    NSURL *urlstr = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:urlstr];
    
    
    
}


- (void)backToFront{
    
    [self goBack];
}

#pragma mark 添加书签点击方法
- (void)bookMarkBtnClick:(UIButton *)button{
    
    button.selected = !_markBtn.selected;
    
    NSRange range = [_paginater rangeOfPage:_readPage];
    
    if ([CommonManager checkIfHasBookmark:range withChapter:_nowChapter+1]) {
        
        [button setImage:[UIImage imageNamed:@"书签x"] forState:0];
        [HUDView showMsg:@"成功删除书签" inView:self.view];

        
    }else{
        
        [button setImage:[UIImage imageNamed:@"书签r"] forState:0];
        [HUDView showMsg:@"成功添加书签" inView:self.view];

    }
    
    NSRange range1 = [_paginater rangeOfPage:_readPage];
    
    NSInteger bn = _nowChapter;
    
    if (!bn) {
        
        bn = 0;
    }
    
    [CommonManager saveCurrentMark:_nowChapter+1 andChapterRange:range1 byChapterContent:_paginater.contentText];
    
}
#pragma mark   添加阅读控制器
- (void)initPageView:(BOOL)isFromMenu;
{
    if (_pageViewController) {

        [_pageViewController.view removeFromSuperview];
        [pageLabel removeFromSuperview];
        [chapterTitleLabel removeFromSuperview];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
//    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone] forKey: UIPageViewControllerOptionInterPageSpacingKey];
//    //翻页样式
//    _pageViewController = [[UIPageViewController alloc]
//                               
//                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
//                               
//                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
   
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    downloadView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-115, kScreenWidth, 15)];
    downloadView.backgroundColor = [UIColor blackColor];
    downloadView.hidden = YES;
    [self.view addSubview:downloadView];
    
    
    //页码label
    pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, kScreenHeight-30, 100, 20)];
    pageLabel.backgroundColor = [UIColor clearColor];

    pageLabel.font = [UIFont fontWithName:@"Arial" size:13];
    pageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:pageLabel];
    
    //章节标题名称label
    chapterTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, kScreenWidth-50, 20)];
    chapterTitleLabel.backgroundColor = [UIColor clearColor];
    chapterTitleLabel.text = @"第一章 朝气蓬勃";
    chapterTitleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    chapterTitleLabel.textColor = [UIColor grayColor];
    [self.view addSubview:chapterTitleLabel];
    
    //电池电量
    ALBatteryView *batteryView = [[ALBatteryView alloc] initWithFrame:CGRectMake(15, kScreenHeight-30, 25, 25)];
    [self.view addSubview:batteryView];
    [batteryView setBatteryLevelWithAnimation:NO forValue:[UIDevice currentDevice].batteryLevelInPercentage inPercent:YES];
    
    downLoadlabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, kScreenWidth, 10)];
    downLoadlabel.backgroundColor = [UIColor blackColor];
    downLoadlabel.textColor = [UIColor whiteColor];
    [downloadView addSubview:downLoadlabel];
    
    if (_isChangePage == YES) {
        
        if (_isRight) {
            //下一章开头
             [self showPage:0];
            pageLabel.text = [NSString stringWithFormat:@"第 1 / %ld 页",_paginater.pageCount];
        }else{
            //点击书签
            if (_isMark) {
                [self showPage:showPage];
                pageLabel.text = [NSString stringWithFormat:@"第 %ld / %ld 页",showPage+1,_paginater.pageCount];
                _isMark =NO;
                
            }else{
            // 上一章
            [self showPage:_paginater.pageCount-1];
            pageLabel.text = [NSString stringWithFormat:@"第 %ld / %ld 页",_paginater.pageCount,_paginater.pageCount];
            }
        }
        
    }else{
    //从书架打开跳到这里
        if (_isRight == YES) {
            [self showPage:0];
            pageLabel.text = [NSString stringWithFormat:@"第 1 / %ld 页",_paginater.pageCount];

        }else{
            
            
            NSUInteger beforePage = [[ReaderDataSource shareInstance] openPage];
            [self showPage:beforePage];
            pageLabel.text = [NSString stringWithFormat:@"第 %ld / %ld 页",beforePage+1,_paginater.pageCount];

        }

    }
    
}

#pragma mark - readerVcDelegate
- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo{
    
    if (yesOrNo == NO) {
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }else{
        _pageViewController.delegate = nil;
        _pageViewController.dataSource = nil;
    
    }
}

//词霸
- (void)ciBaWithString:(NSString *)ciBaString{
   
    WebViewControler *webView = [[WebViewControler alloc] initWithSelectString:ciBaString];
    [self presentViewController:webView animated:YES completion:NULL];

}

#pragma mark - 点击侧边栏目录跳转
- (void)turnToClickChapter:(NSInteger)chapterIndex{
    _isRight =YES;
    _isChangePage =NO;
    [self openChapter:chapterIndex];//加1 是因为indexPath.row从0 开始的
    //TODO: 如果没有网络，跳转没有缓存的章节
    
    _nowChapter = chapterIndex;
//    [CommonManager saveCurrentChapter:_nowChapter];

}
#pragma mark   拖动进度条
- (void)sliderToChapterPage:(NSInteger)chapterIndex{
    [self showPage:chapterIndex - 1];
    pageLabel.text = [NSString stringWithFormat:@"第 %ld / %ld 页",chapterIndex,_paginater.pageCount];

}

#pragma mark - 点击侧边栏书签跳转
- (void)turnToClickMark:(Mark *)eMark{
    
//    EveryChapter *e_chapter = [[ReaderDataSource shareInstance] openChapter:[eMark.markChapter integerValue]];
    [self openChapter:[eMark.markChapter integerValue]-1];
    
    if (_pageViewController) {
        
         MyNSLog("remove pageViewController");
        [_pageViewController.view removeFromSuperview];
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    showPage = [self findOffsetInNewPage:NSRangeFromString(eMark.markRange).location];
    _isChangePage = YES;
    _isMark = YES;
    _isRight = NO;
    [self showPage:showPage];
}

#pragma mark - 上一章
- (void)turnToPreChapter{
    
    _isChangePage =NO;
    _isRight = YES;
    if (_nowChapter <= 1) {
        [HUDView showMsg:@"已经是第一章" inView:self.view];
        return;
    }
    [self turnToClickChapter:_nowChapter - 1];
    
}
#pragma mark - 下一章
- (void)turnToNextChapter{
    _isRight = YES;
    _isChangePage =NO;
    if (_nowChapter == [ReaderDataSource shareInstance].totalChapter) {
        [HUDView showMsg:@"已经是最后一章" inView:self.view];
        return;
    }
    [self turnToClickChapter:_nowChapter+1];

}

#pragma mark - 隐藏设置bar
- (void)hideTheSettingBar{
    
    if (_settingToolBar == nil) {
       
    }else{
        [self hideMultifunctionButton];
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [self shutOffPageViewControllerGesture:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
    }
    
    if (_settingBottomBar == nil) {
        bottomToolIsHidden = NO;
     }else{
        
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
         bottomToolIsHidden = YES;
         downloadView.hidden = YES;
        [self shutOffPageViewControllerGesture:NO];
    }
}


#pragma mark --
- (void)parseChapter:(EveryChapter *)chapter
{
    self.chapterContent_ = chapter.chapterContent;
    self.chapterTitle_ = chapter.chapterTitle;
    [self configPaginater];
}

//-------1
- (void)configPaginater
{
    _paginater = [[E_Paging alloc] init];
    ReaderViewController *temp = [[ReaderViewController alloc] init];
    temp.delegate = self;
    [temp view];
    _paginater.contentFont = self.fontSize;
    _paginater.textRenderSize = [temp readerTextSize];
    _paginater.contentText = self.chapterContent_;
    [_paginater paginate];
  
}

- (void)readPositionRecord
{
    int currentPage = [_pageViewController.viewControllers.lastObject currentPage];
    
    NSRange range = [_paginater rangeOfPage:currentPage];
    
    self.readOffset = range.location;
}

- (void)fontSizeChanged:(int)fontSize
{
    [self readPositionRecord];
    self.fontSize = fontSize;
    _paginater.contentFont = self.fontSize;
    [_paginater paginate];
    int showPage = [self findOffsetInNewPage:self.readOffset];
    [self showPage:showPage];
    
}
#pragma mark - 直接隐藏多功能下拉按钮
- (void)hideMultifunctionButton{
    if (_markBtn) {

        [_markBtn removeFromSuperview];
        _markBtn = nil;

    }
}

#pragma mark - TopbarDelegate 
//返回的时候保存阅读到的当前页
- (void)goBack{
    
    [CommonManager saveCurrentPage:_readPage];
    
    [CommonManager saveCurrentChapter:_nowChapter];
    
    [[BookSource shareInstance] SourceID:[[BookSource shareInstance] getSourceID]];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}




#pragma mark - CDSideBarDelegate -- add by tiger-
- (void)changeGestureRecognizers{
    
    tapGesRec.enabled = YES;
    for (int i = 0 ; i < _pageViewController.gestureRecognizers.count; i ++) {
        UIGestureRecognizer *ges = (UIGestureRecognizer *)[_pageViewController.gestureRecognizers objectAtIndex:i];
        ges.enabled = YES;
    }
}

- (void)menuButtonClicked:(NSInteger)index{
    
    if (index == 0) {
        
        [HUDView showMsg:@"分享至新浪" inView:self.view];
        
    }else if (index == 1){
       
        [HUDView showMsg:@"分享至朋友圈" inView:self.view];
        
    }else if(index == 2){

        [HUDView showMsg:@"分享至微信" inView:self.view];
    }

}



#pragma mark - 底部左侧按钮触发事件
- (void)callDrawerView{
    
    [self callToolBar];
    tapGesRec.enabled = NO;
    sideBar.singleTap.enabled = NO;
    DELAYEXECUTE(0.18, {DrawerView *drawerView = [[DrawerView alloc] initWithFrame:self.view.frame parentView:self.view];drawerView.delegate = self;
        [self.view addSubview:drawerView];});
    

}


#pragma mark -   下载章节按钮
- (void)callCacheClick{
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:@"缓存多少章？"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *aCancel=[UIAlertAction actionWithTitle:@"取消"
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction *action){
        MyNSLog("Cancel Download!");
    }];
    
    UIAlertAction *aAllDownload = [UIAlertAction actionWithTitle:@"全部"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                        
//                                                        NSInvocationOperation *operation1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downloadAllChapter) object:nil];
//                                                        [queue addOperation:operation1];
                                                        
                                                             
                                                        NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
                                                            [self downloadChapter:0 end:_allChapterArr.count];
                                                        }];
                                                             [queue addOperation:operation1];
                                                             
    }];
    UIAlertAction *aDownloadBack50 = [UIAlertAction actionWithTitle:@"后面50章"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                
                                                                NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
                                                                    
                                                                    //如果后面没有50章
                                                                
                                                                    if (_nowChapter+50 >=_allChapterArr.count) {
                                                                   
                                                                        [self downloadChapter:_nowChapter end:_allChapterArr.count];
                                                                   
                                                                    }else{
                                                                    
                                                                        [self downloadChapter:_nowChapter end:_nowChapter+50];
                                                                   
                                                                    }
                                                                    
                                                                }];
                                                                
                                                                [queue addOperation:operation2];
                                                                
        
    }];
    
    UIAlertAction *aDownloadBackAll = [UIAlertAction actionWithTitle:@"后面全部"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action){
                                                                 NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
                                                                     
                                                                     [self downloadChapter:_nowChapter end:_allChapterArr.count];
                                                                 
                                                                 }];
                                                                 
                                                                 [queue addOperation:operation3];
                                                                 
    }];
    
    
    [alertController addAction:aDownloadBack50];
    [alertController addAction:aDownloadBackAll];
    [alertController addAction:aAllDownload];
    [alertController addAction:aCancel];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
 

  
}


- (void)openTapGes{
    
    tapGesRec.enabled = YES;
}


- (void) downloadChapter:(NSUInteger) index end:(NSUInteger) endIndex {
    
    
    endIndex = MIN(_allChapterArr.count, endIndex);
   
    if (index >= endIndex){
        
        if (bottomToolIsHidden ==NO) {
            downloadView.hidden = NO;
            downLoadlabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:13];
            downLoadlabel.text = @"缓存完成！";
            downLoadlabel.hidden = NO;
        }
        
        MyNSLog("执行完毕");
        [[Chapter shareInstance] updateDownLoadArr];
        [[Chapter shareInstance] getListArray];
        [HUDView showMsg:@"缓存完成" inView:nil];
        return;
    }
   __block int num;
    __weak ReaderScrollViewController *clone_self = self;
    
    NSString *PlatformUrl = [NSString stringWithFormat:@"%@%@", KBASSUrl, KChapter];
    
    NSString * url = [_allChapterArr[index] objectForKey:@"link"];
    
    NSDictionary *params = @{@"url":url};
    
    [XYNetworking POST:PlatformUrl params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *ret = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"ret"]];
        if ([ret isEqualToString:@"0"]) {
            
            
            NSString *tr = [NSString stringWithFormat:@"%@/%@",
                            [[BookInfo siged] getBookPath],
                            [[BookSource shareInstance] getSourceID]];
            
            
            NSDictionary *dic = [[responseObject objectForKey:@"data"] objectForKey:@"chapter"];
            
            NSString *cpContent = [NSString stringWithFormat:@"%@",
                                   [[[responseObject objectForKey:@"data"] objectForKey:@"chapter"] objectForKey:@"body"]];
            
            if ([[dic allKeys] containsObject:@"cpContent"]) {
                cpContent = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"chapter"] objectForKey:@"cpContent"]];
            }
            
            //加密
            
            cpContent = [WXYClassMethodsViewController encrypt:cpContent];
            
            NSString *Urlname = [WXYClassMethodsViewController md5:url];
            
            [FileOperation createFileNamed:[NSString stringWithFormat:@"%@.txt", Urlname] inDirectory:tr andWriteIn:cpContent];
            
            MyNSLog ("执行完毕 [%ld]", index);
            num = num+1;
            
            if (bottomToolIsHidden ==NO) {
                downloadView.hidden = NO;
                downLoadlabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:13];
                downLoadlabel.text = [NSString stringWithFormat:@"已经缓存：%lu章/%ld章",(unsigned long)index,endIndex];
                downLoadlabel.hidden = NO;
            }
            
        }
        
        [clone_self downloadChapter:index + 1 end:endIndex];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        MyNSLog("---------error:%@", error);
        [clone_self downloadChapter:index + 1 end:endIndex];
    }];
    
}


// //////////////////////////////////////////////////////////////////

#pragma mark - 改变主题
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme{
  
    if (theme == 1) {
        _themeImage = nil;
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)theme]];
    }
   
    [self showPage:self.readPage];
}

#pragma mark - 根据偏移值找到新的页码
- (NSUInteger)findOffsetInNewPage:(NSUInteger)offset
{
    NSUInteger pageCount = _paginater.pageCount;
    for (int i = 0; i < pageCount; i++) {
        NSRange range = [_paginater rangeOfPage:i];
        if (range.location <= offset && range.location + range.length > offset) {
            return i;
        }
    }
    return 0;
}

//显示第几页
- (void)showPage:(NSUInteger)page
{
    ReaderViewController *readerController = [self readerControllerWithPage:page];
    [_pageViewController setViewControllers:@[readerController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL f){
                                     
                                 }];
}

//打开指定的页数
- (ReaderViewController *)readerControllerWithPage:(NSUInteger)page
{
    _readPage = page;
    [adView removeFromSuperview];
    [adBtn removeFromSuperview];
    ReaderViewController *textController = [[ReaderViewController alloc] init];
    textController.delegate = self;
    textController.keyWord = _searchWord;
    textController.themeBgImage = _themeImage;
    if (_themeImage == nil) {
        textController.view.backgroundColor = [UIColor whiteColor];
    }else{
        textController.view.backgroundColor = [UIColor colorWithPatternImage:_themeImage];
    }

    [textController view];
    textController.currentPage = page;
    textController.totalPage = _paginater.pageCount;
    textController.chapterTitle = self.chapterTitle_;
    textController.font = self.fontSize;
    textController.text = [_paginater stringOfPage:page];
    pageNow = page+1;
//    pageLabel.text = [NSString stringWithFormat:@"第 %ld / %ld 页",pageNow,_paginater.pageCount];
    
    
    //及时删除广告
    chapterTitleLabel.text = [[Chapter shareInstance] getChapterTitle];
    NSUserDefaults *pageHeight = [NSUserDefaults standardUserDefaults];
    NSInteger height =[pageHeight integerForKey:@"pageHeight"];
    
    float ratio = height/[UIScreen mainScreen].bounds.size.height;
    if (ratio <0.70) {
        
        
    }else{
        [adView removeFromSuperview];
        [adBtn removeFromSuperview];
    }
    
    if (_settingBottomBar) {
       
        float currentPage = [[NSString stringWithFormat:@"%ld", _readPage] floatValue] + 1;
        float totalPage = [[NSString stringWithFormat:@"%ld", textController.totalPage] floatValue];
       
        float percent;
        if (currentPage == 1) {//强行放置头部
            
            percent = 0;
            
        }else{
            
            percent = currentPage/totalPage;
        }

        [_settingBottomBar changeSliderRatioNum:percent];
    }
    
    _searchWord = nil;
    return textController;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -向前翻页
//
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    _isTurnOver = NO;
    _isRight = NO;
    _isChangePage =YES;
    ReaderViewController *textController =  [self preChapterViewController:viewController];
    
    return textController;
    
}

/**
 *  获得上一页内容
 *
 *  @return 章节类
 */
- (ReaderViewController *)preChapterViewController:(UIViewController *)viewController{
    
    ReaderViewController *reader = (ReaderViewController *)viewController;
    
    NSUInteger currentPage = reader.currentPage;
    
    if (_nowChapter <= 0) {
        
        if (currentPage <=0) {
            [HUDView showMsg:@"已经是第一页了" inView:nil];
            
            _pageIsAnimating = NO;
            
            return  nil;
        }else{
            
            _nowPage = currentPage -1;
            
            ReaderViewController *textController = [self readerControllerWithPage:currentPage - 1];
            
            return textController;
        }
        
        
    }else{
        
        if (currentPage> 0) {
            
            
            _pageIsAnimating = YES;
            _nowPage = currentPage-1;
            ReaderViewController *textController = [self readerControllerWithPage:currentPage-1];
            
            [CommonManager saveCurrentChapter:_nowChapter];
            return textController;
        }else{
            //翻到前一章
            _nowChapter --;
            
            MyNSLog("------现在跳转到第%ld章", _nowChapter);
            _pageIsAnimating = YES;
            
            currentPage = [self lastPage];//self.lastPage + 1;
            
            _nowPage = currentPage;
            
            [self openChapter:_nowChapter];
            if (ishadDownLoadNextChapter ==YES) {
                _nowPage = 0;
                
                ReaderViewController *textController = [self readerControllerWithPage:currentPage-1];
                
                return textController;
                
            }else{
                
                return nil;
            }
           
            
        }
        
        
        
    }
}

#pragma mark -向后翻页

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    
    
    ReaderViewController *textController = [self nextChapterViewController:viewController];
    _isChangePage =YES;//是翻页
    
    return textController;
}
/**
 *  获得下一页内容
 *
 *  @return 章节类
 */
- (ReaderViewController *)nextChapterViewController:(UIViewController *)viewController{
    
    _isTurnOver = NO;
    
    _isRight = YES;
    
    ReaderViewController *reader = (ReaderViewController *)viewController;
    
    NSInteger currentPage = reader.currentPage;
    
    if (_nowChapter+1 >= [[Chapter shareInstance] getChapters].count && currentPage+1  >=_paginater.pageCount) {
        
            [HUDView showMsg:@"没有更多内容" inView:nil];
            return nil;
        
    }else{
        
        _pageIsAnimating = YES;
        
        if (currentPage >= [self lastPage]) {
            //进入下一章
            _isTurnOver = YES;
            _nowChapter++;
            
            MyNSLog("------现在是第%lu章", (unsigned long)_nowChapter);
            
             [self openChapter:_nowChapter];
            if (ishadDownLoadNextChapter ==YES) {
                _nowPage = 0;
                
                ReaderViewController *textController = [self readerControllerWithPage:0];
                
                return textController;

            }else{
            
                return nil;
            }

            
        }
        
        _pageIsAnimating = YES;
        
        _nowPage = currentPage+1;
        
        ReaderViewController *textController = [self readerControllerWithPage:currentPage + 1];
        
        [CommonManager saveCurrentChapter:_nowChapter];
        
        return textController;
        
    }
    
}

//- (BOOL)prefersStatusBarHidden{
//return YES; // 返回NO表示要显示，返回YES将hiden
//
//}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    _pageIsAnimating = NO;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    if (completed) {
        //翻页完成
        pageLabel.text = [NSString stringWithFormat:@"第 %ld / %ld 页",pageNow,_paginater.pageCount];
       //最后一页加广告
        NSUserDefaults *pageHeight = [NSUserDefaults standardUserDefaults];
        NSInteger height =[pageHeight integerForKey:@"pageHeight"];
        

        float ratio = height/[UIScreen mainScreen].bounds.size.height;
        if (ratio <0.70 && openAD ==YES) {
            
            int a = arc4random() % _adArr.count;
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ReaderADView" owner:nil options:nil];
            adView = [nibContents objectAtIndex:0];

             NSString *adUrlStr = [_adArr[a] objectForKey:@"res_url"];
            
//            openUrl =  [NSString stringWithFormat:@"%@%@",[_adArr[a] objectForKey:@"download_url"],[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
            if (iPhone4) {
               adView.frame =CGRectMake(0, kScreenHeight-100, kScreenWidth, 60);
            }else{
            adView.frame =CGRectMake(10, kScreenHeight-100, kScreenWidth-20, 60);
            }
            
            [adView.adImage sd_setImageWithURL:(NSURL*)adUrlStr];
            adView.adTitle.text = [_adArr[a] objectForKey:@"app_name"];
        
            adView.adContent.text = [_adArr[a] objectForKey:@"app_desc"];
            adView.backgroundColor = [UIColor clearColor];

            [self.view addSubview:adView];
            
            adBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-320)/2, kScreenHeight-100, 320, 60)];
            adBtn.backgroundColor = [UIColor clearColor];
            [adBtn addTarget:self action:@selector(openUrl) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:adBtn];
        }else{
            [adView removeFromSuperview];
            [adBtn removeFromSuperview];
        }

    }else{ //翻页未完成 又回来了。
        
        
        if (_isTurnOver && !_isRight) {//往右翻 且正好跨章节
            
             EveryChapter *chapter =[[ReaderDataSource shareInstance] nextChapter];
            [self parseChapter:chapter];
            
        }else if(_isTurnOver && _isRight){//往左翻 且正好跨章节
            
            EveryChapter *chapter = [[ReaderDataSource shareInstance] preChapter];
            [self parseChapter:chapter];
            
        }
        
        
        
    }
}



-(void)openUrl{

    NSURL *url = [NSURL URLWithString:openUrl];
    [[UIApplication sharedApplication] openURL:url];

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIView class]]){
        
        return NO;
        
    }
    
    return YES;
    
}

- (NSUInteger)lastPage
{
    return _paginater.pageCount - 1;
}

- (void)openChapter:(NSInteger)clickChapter{
    //先判断本地有没有此章节
    
    EveryChapter *chapter = [[EveryChapter alloc] init];
    
    NSString *filePath;
    
    //从书架打开
    filePath = [NSString stringWithFormat:@"%@/%@",[[BookInfo siged] getBookPath],[[BookSource shareInstance] getSourceID]];
   
    NSString *cpContent = [NSMutableString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/chaptersInfo.txt",filePath] encoding:NSUTF8StringEncoding error:NULL];//内容
    
    cpContent = [WXYClassMethodsViewController decode:cpContent];
    
    NSArray *ChaptersArr = [WXYClassMethodsViewController stringToJSON:cpContent];
   
    
    NSDictionary *Dic = [[NSDictionary alloc] init];
    
    //    找到对应的章节的url
    if (ChaptersArr.count < clickChapter) {
        
        Dic = [ChaptersArr lastObject];
        [CommonManager saveCurrentChapter:ChaptersArr.count-1];
        _nowChapter =ChaptersArr.count-1;
        

    }else{
    
        if (ChaptersArr.count == 0) {
            [HUDView showMsg:@"暂时没有章节信息" inView:self.view];

        }else{
            Dic = ChaptersArr[clickChapter];
            _nowChapter =clickChapter;
        }
      
    }
    
    
    NSString *chapterUrl = [NSString stringWithFormat:@"%@",[Dic objectForKey:@"link"]];
    
    urlStr = chapterUrl;
    
    NSString *urlStrMd5 = [NSString stringWithFormat:@"%@.txt",[WXYClassMethodsViewController md5:chapterUrl]];
    
    
    
    BOOL isHaveChapter = [FileOperation fileExists:urlStrMd5 AtPath:filePath];
    ishadDownLoadNextChapter = isHaveChapter;
    if (isHaveChapter ==YES) {
        
        [CommonManager saveCurrentChapter:clickChapter];
        [[Chapter shareInstance] getListArray];

        //有本章节
        NSString *chapterPath = [NSString stringWithFormat:@"%@/%@",filePath,urlStrMd5];
        
        NSString *cpContent = [NSMutableString stringWithContentsOfFile:chapterPath encoding:NSUTF8StringEncoding error:NULL];
        //解密
        chapter.chapterContent = [WXYClassMethodsViewController decode:cpContent];
        
        [self parseChapter:chapter];
        
        [self initPageView:_isRight];
        
    }else{
        //没有此章节

        NSString *PlatformUrl = [NSString stringWithFormat:@"%@%@",KBASSUrl,KChapter];
        
        NSArray *chapterArray = [[Chapter shareInstance] getChapters];
//        if (clickChapter ==nil) {
//            
//            clickChapter = 0;
//            
//        }
        if (chapterArray ==nil) {
            
            [HUDView showMsg:@"暂时没有章节信息" inView:self.view];

        }else{
            
            NSDictionary *chapterDic = [[NSDictionary alloc] init];
            //    找到对应的章节的url
            if (ChaptersArr.count < clickChapter) {
                
                chapterDic = [ChaptersArr lastObject];
                [CommonManager saveCurrentChapter:ChaptersArr.count-1];
                _nowChapter =ChaptersArr.count-1;
            }else{
                
                chapterDic = ChaptersArr[clickChapter];
                _nowChapter =clickChapter;

            }
            
        
        NSDictionary *params = @{@"url":[chapterDic objectForKey:@"link"]};
        
        urlStr = [chapterDic objectForKey:@"link"];
        
        __weak ReaderScrollViewController *clone_self = self;
            
        [XYNetworking POST:PlatformUrl params:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *ret = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ret"]];
            if ([ret isEqualToString:@"0"]) {
                
                NSDictionary *dic = [[responseObject objectForKey:@"data"] objectForKey:@"chapter"];
                
                NSString *cpContent =[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"chapter"] objectForKey:@"body"]];
                
                if ([[dic allKeys] containsObject:@"cpContent"]) {
                    cpContent = [NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"data"] objectForKey:@"chapter"] objectForKey:@"cpContent"]];
                }
                
                chapter.chapterContent = cpContent;
                [CommonManager saveCurrentChapter:clickChapter];
            }
            [clone_self parseChapter:chapter];
            [clone_self initPageView:NO];
            [[Chapter shareInstance] getListArray];

        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [HUDView showMsg:@"暂时没有章节信息,请换源" inView:self.view];
            
            MyNSLog("error:%@",error);
            
            [clone_self callToolBar];
            
        }];
        
        }
    }
    //章节名称赋值
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.presentedViewController endAppearanceTransition];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

}

-(void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:YES];
    [CommonManager saveCurrentPage:_readPage];
    [CommonManager saveCurrentChapter:_nowChapter];
    [[BookSource shareInstance] SourceID:[[BookSource shareInstance] getSourceID]];
    [self.presentedViewController beginAppearanceTransition: NO animated: animated];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.presentedViewController endAppearanceTransition];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
