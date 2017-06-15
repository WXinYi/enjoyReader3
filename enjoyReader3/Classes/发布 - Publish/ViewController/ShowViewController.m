//
//  ShowViewController.m
//  enjoyReader3
//
//  Created by WangXy on 16/8/30.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ShowViewController.h"
#import "ShowTextView.h"
#import "ShowWebView.h"
#import "detailBackView.h"
#import "CommentTextView.h"
#import "commentFootView.h"
#import "QuanViewController.h"
#import "SWRTableViewController.h"
#import "AppDelegate.h"
#import "DKNightVersion.h"
#import "ShowMoreView.h"
@interface ShowViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic ,assign) BOOL isWebViewshow;
@property (nonatomic ,assign) NSInteger webHeight;
@property (nonatomic ,strong) detailBackView *head;
@property (nonatomic ,strong) commentFootView *foot;
@property (nonatomic ,assign) CGFloat oldOffset;
@property (nonatomic ,assign) CGFloat keyboardY;
@property (nonatomic ,assign) BOOL isShowToolBar;
@property (nonatomic ,assign) BOOL showComment;
@property (nonatomic ,assign) BOOL muenOpen;
@property (nonatomic ,assign) BOOL hasCollect;
@property (nonatomic ,strong) UIButton *leftButton;
@property (nonatomic ,strong) UIButton *rightButton;
@property (nonatomic ,strong) UITableView *muenTable;
@property (nonatomic ,strong) UILabel *chapte;//目录上的章节
@property (nonatomic ,strong) UIVisualEffectView *effectView;
@property (nonatomic ,strong) CommentTextView *commentTextView;//输入评论的视图
@property (nonatomic ,strong) ShowMoreView *moreView;

@end

@implementation ShowViewController
{
    ShowWebView *textview;
    NSString *bobybackgroundcolor ;
    NSString *blockquotecolor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    
    [self loadingCircleJoinAnimation];
    //内容
    textview = [[ShowWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight)];
//    textview.scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    textview.backgroundColor = [UIColor clearColor];
    textview.scrollView.bounces = NO;
    textview.delegate = self;

    //    添加金句按钮
    [self becomeFirstResponder];
    UIMenuItem *menuItem1 = [[UIMenuItem alloc]initWithTitle:@"添加金句"action:@selector(addToTemplate:)];
    UIMenuItem *menuItem2 = [[UIMenuItem alloc]initWithTitle:@"分享"action:@selector(addToTemplate:)];

    UIMenuController*menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,nil]];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHidenToolBar)];
    //点击的次数
    singleRecognizer.delegate =self;
    
    [textview addGestureRecognizer:singleRecognizer];
    textview.scrollView.delegate = self;
    textview.userInteractionEnabled = YES;
   
    
    [self.view addSubview:textview];
    
    [self addheadView];
    self.muenTable = [[UITableView alloc] initWithFrame:CGRectMake(-(kScreenWidth-50), 0, kScreenWidth-50, kScreenHeight) style:UITableViewStylePlain];
    self.muenTable.delegate = self;
    self.muenTable.dataSource =self;
    self.muenTable.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.muenTable.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self.view addSubview:self.muenTable];
    _muenTable.hidden = YES;
    
    self.moreView = [[[NSBundle mainBundle] loadNibNamed:@"ShowMoreView" owner:nil options:nil] firstObject];
    self.moreView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth-100, kScreenHeight);
    self.moreView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.moreView.toolView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    self.moreView.nightSwitch.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.moreView.SeeAuthorView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.moreView.followAuthorView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.moreView.jubaoView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.moreView.nightView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.moreView.nightLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.moreView.seeAuthorLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.moreView.followAuthorLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.moreView.jubaoLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);

    [self.moreView.nightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
       
        self.moreView.nightSwitch.on = YES;
        bobybackgroundcolor= [NSString stringWithFormat:@"background:#3f3f3f;color:#b3b3b3"];
        blockquotecolor = [NSString stringWithFormat:@"background-color: #555555;border-color: #323232"];

    }else{
        //日间
        self.moreView.nightSwitch.on = NO;
        bobybackgroundcolor= [NSString stringWithFormat:@"background:#f7f8fa;color:#2c2c2c"];
        blockquotecolor = [NSString stringWithFormat:@"background-color: #edeef0;border-color: #bcbcbc"];
    }
    [self loadHtml];
    [self.view addSubview:self.moreView];
    
    self.moreView.hidden = YES;
    
    [self addCenterButton];
   
}

-(void)switchAction:(id)sender{


    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        self.moreView.nightSwitch.on = YES;
        [self.dk_manager nightFalling];
        //修改文字颜色
        [textview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#b3b3b3'"];
        //修改body背景颜色
        [textview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#3f3f3f'"];
       
    }else {
        [self.dk_manager dawnComing];
        //日间
        self.moreView.nightSwitch.on = NO;
        //修改文字颜色
        [textview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#2c2c2c'"];
        //修改body背景颜色
        [textview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#f7f8fa'"];
       
    }

}
- (void)webViewDidStartLoad:(UIWebView *)webView{

//    [self loadinghide];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self loadinghide];

}
-(void)loadHtml{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"html"];
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSString * title = @"我是标题我是标题我是标题我是标题我是标题";
    
    NSString *info = @"阅读量： 2000 · 字数：9032";
    
    //  设置背景色等
    
    NSString *BookStr = [NSString stringWithFormat:
                         @"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "body {font-size: 18;%@}\n"
                         "blockquote {margin: 0 0 20px 0;padding: 20px;font-weight: 100;word-break: break-all;border-left: 4px solid #999;%@}\n"
                         "h1,h2,h3,h4,h5,h6 {margin: .7em 0;line-height: 1.5;-webkit-font-smoothing: antialiased;}\n"
                         "h1 { font-size: 24px }\n"
                         "h2 { font-size: 22px }\n"
                         "h3 { font-size: 20px }\n"
                         "h4 { font-size: 13px ;color:#7E7C8A}\n"
                         "h5,\n"
                         "h6 { font-size: 17px }\n"
                         "hr {border: none;border-bottom: 1px solid #d5d5d5;margin-bottom: 25px;}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body class=\"{{mode}}>\"\n"
                         "<br></br>\n"
                         "<br></br>\n"
                         "<h1>%@</h1>\n"
                         "<h4>%@</h4>\n"
                         "%@\n"
                         "<br></br>\n"
                         "</body>\n"
                         "<script type='text/javascript'>\n"
                         "function setDayMode() {\n"
                         " $('body').removeClass('reader-night-mode');\n"
                         " }\n"
                         "  function setNightMode() {\n"
                         "    $('body').addClass('reader-night-mode');\n"
                         " }\n"
                         "  function sectionArticle() {\n"
                         "     $('body').addClass('section-article');\n"
                         "  }\n"
                         " </script>\n"
                         "</html>",bobybackgroundcolor,blockquotecolor,title,info,content];
    
    
    [textview loadHTMLString:BookStr baseURL:nil];
}
-(void)viewDidAppear:(BOOL)animated{
//加载目录
   
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if(action ==@selector(addToTemplate:)) {//添加为模板方法
        
        return YES;
    }
    
    return NO;
}

-(void)addToTemplate:(UIMenuController*)sender{
    
    NSString* selection = [textview stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    
    NSLog(@"ceshishi%@",selection);
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    _isShowToolBar = YES;
    _muenOpen = NO;
    _hasCollect = NO;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    //通知，监听键盘的弹出控制输入框的位置
    //监听键盘，键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardwill:)
                                                name:UIKeyboardWillShowNotification object:nil];
    
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keybaordhide:)
                                                name:UIKeyboardWillHideNotification object:nil];
    
    //设置点击手势，当点击空白处，结束编辑，收回键盘
    UITapGestureRecognizer *tapp=[[UITapGestureRecognizer alloc]
                                  initWithTarget:self action:@selector(tapActions:)];
    //开启交互
    self.view.userInteractionEnabled=YES;
    //添加手势到视图
    
    [self.view addGestureRecognizer:tapp];

    _isWebViewshow = NO;
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark --muentable代理方法，数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 30;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.textLabel.text = @"我是章节标题";
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTWO);
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:14];
    return cell;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _muenTable.frame.size.width, 75)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 25, _muenTable.frame.size.width-36, 18)];
    titleLabel.text = @"标题";
    titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:18];

    _chapte = [[UILabel  alloc] initWithFrame:CGRectMake(18, 54, _muenTable.frame.size.width-36, 12)];
    _chapte.text = @"第3章/共1232131章";
    _chapte.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    _chapte.font = [UIFont fontWithName:@"Heiti SC" size:12];
    
    [header addSubview:titleLabel];
    [header addSubview:_chapte];
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 74.5, _muenTable.frame.size.width, 0.5)];
    line.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [header addSubview:line];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 75;
}
//点击手势方法
-(void)tapActions:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    if (_effectView != nil && _leftButton.hidden == NO) {
        
        [self leftButtonClick];
    }
    if (_effectView != nil && _leftButton.hidden == YES) {
        [self moreBtnClick];
    }
    
    
}

//当键盘出现时，调用此方法
-(void)keyboardwill:(NSNotification *)sender
{
    
    if (_showComment) {
        //获取键盘高度
        NSDictionary *dict=[sender userInfo];
        NSValue *value=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardrect = [value CGRectValue];
        int height=keyboardrect.size.height;
        
        [UIView animateWithDuration:0.35 animations:^{
            
            _commentTextView.frame = CGRectMake(0, kScreenHeight-height-118, kScreenWidth, 118);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

//当键盘隐藏时候，视图回到原定
-(void)keybaordhide:(NSNotification *)sender
{
    [UIView animateWithDuration:0.35 animations:^{
        
            _commentTextView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 118);
        
    } completion:nil];
}
#pragma mark -添加左右按钮
-(void)addCenterButton{
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, kScreenHeight/2-25, 50, 50)];
    [self.leftButton setImage:[UIImage imageNamed:@"icon_mulu128-128"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, kScreenHeight/2-25, 50, 50)];
    [self.rightButton setImage:[UIImage imageNamed:@"icon_shoucang_2_128-128"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"icon_shoucang128-128"] forState:UIControlStateSelected];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    
}

#pragma mark -添加上下工具栏
-(void)addheadView{
    
    _commentTextView = [[[NSBundle mainBundle] loadNibNamed:@"CommentTextView" owner:nil options:nil] firstObject];
    _commentTextView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 118);
    _commentTextView.dk_backgroundColorPicker =DKColorPickerWithKey(BBG);
    _commentTextView.commentTextInputView.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    _commentTextView.commentTextInputView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _commentTextView.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _commentTextView.sendBtn.backgroundColor = [WXYClassMethodsViewController colorWithHexString:@"#cd7776"];
    [self.view addSubview:_commentTextView];
    
    _head = [[[NSBundle mainBundle] loadNibNamed:@"detailBackView" owner:nil options:nil] firstObject];
    _head.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _head.frame = CGRectMake(0, 15, kScreenWidth, 88);
    [self.view addSubview:_head];

    [_head.backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    _head.authorIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
    [_head.authorIcon addGestureRecognizer:iconTap];
    
    _head.authorName.userInteractionEnabled = YES;
    _head.authorName.dk_textColorPicker = DKColorPickerWithKey(TXTTWO);
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
    [_head.authorName addGestureRecognizer:nameTap];
    _head.haveWatchLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    _head.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [_head.authorFollowBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _foot =[[[NSBundle mainBundle] loadNibNamed:@"commentFootView" owner:nil options:nil] lastObject];
    _foot.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _foot.frame = CGRectMake(0, kScreenHeight-60, kScreenWidth, 60);
    [_foot.allCommentBtn addTarget:self action:@selector(toMoreComment:) forControlEvents:UIControlEventTouchUpInside];
    [_foot.commontBtn addTarget:self action:@selector(callCommentTextView:) forControlEvents:UIControlEventTouchUpInside];
    [_foot.zanBtn addTarget:self action:@selector(zanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _foot.commontBtn.layer.borderWidth = 0.5;
    _foot.commontBtn.layer.borderColor = [WXYClassMethodsViewController colorWithHexString:@"#929292"].CGColor;
    _foot.commontBtn.layer.masksToBounds = YES;
    _foot.commontBtn.layer.cornerRadius = 5;
    [_foot.shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    _foot.commontBtn.titleLabel.textColor = [WXYClassMethodsViewController colorWithHexString:@"#333333"];

    [self.view addSubview:_foot];
    
}
#pragma mark --工具栏点击事件
-(void)iconClick:(id)tap{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SWRTableViewController" bundle:nil];
    SWRTableViewController *me = [sb instantiateInitialViewController];
    me.isFromComment = YES;
    [self.navigationController pushViewController:me animated:YES];
    
}
-(void)zanBtnClick{

   

}
-(void)moreBtnClick{
    if (self.leftButton.hidden == YES) {
        
        //        关闭菜单
       
        [UIView animateWithDuration:0.35 animations:^{
            self.moreView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth-100, kScreenHeight);
        } completion:^(BOOL finished) {
            self.moreView.hidden = YES;
            [_effectView removeFromSuperview];
            _effectView = nil;
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            [self showTopBar];
            [self showBottomBar];
        }];
//        [self loadHtml];
        [self.view endEditing:YES];
        
    }else{
    
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        _effectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
        
        _effectView.frame = self.view.bounds;
        
        [self.view insertSubview:_effectView belowSubview:_muenTable];
        [self hideTopBar];
        [self hideBottomBar];
        self.moreView.hidden = NO;
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
        [UIView animateWithDuration:0.35 animations:^{
            
            self.moreView.frame = CGRectMake(100, 0, kScreenWidth-100, kScreenHeight);
            
        } completion:nil];
        [self.view endEditing:YES];
    
    }
    
   

}
-(void)toMoreComment:(UIButton *)sender{
    
    QuanViewController *vc = [[QuanViewController alloc]init];

    [self.navigationController pushViewController:vc animated:YES];
}
-(void)callCommentTextView:(UIButton *)sender{
    
    [self hideCenterButton];
    
    self.showComment = YES;
    [_commentTextView.commentTextInputView becomeFirstResponder];

    
}
-(void)leftButtonClick{
    if (_muenOpen==NO) {
//        打开菜单
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        _effectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
        
        _effectView.frame = self.view.bounds;
        
        [self.view insertSubview:_effectView belowSubview:_muenTable];
        [self hideTopBar];
        [self hideBottomBar];
        _muenTable.hidden = NO;
        [UIView animateWithDuration:0.35 animations:^{
            
            self.leftButton.frame = CGRectMake(kScreenWidth-75  , kScreenHeight/2-25, 50, 50);
            self.muenTable.frame = CGRectMake(0, 0, kScreenWidth-50, kScreenHeight);
            self.rightButton.frame =CGRectMake(kScreenWidth  , kScreenHeight/2-25, 50, 50);

        } completion:nil];
        _muenOpen = YES;
        [self.view endEditing:YES];
    }else{
        
//        关闭菜单

        
        [UIView animateWithDuration:0.35 animations:^{
            self.leftButton.frame = CGRectMake(-10  , kScreenHeight/2-25, 50, 50);
            self.muenTable.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth-50, kScreenHeight);
            self.rightButton.frame =CGRectMake(kScreenWidth-40  , kScreenHeight/2-25, 50, 50);
        } completion:^(BOOL finished) {
            _muenTable.hidden = YES;
            [self showTopBar];
            [self showBottomBar];
            [_effectView removeFromSuperview];
            _effectView = nil;
        }];
        _muenOpen = NO;
        [self.view endEditing:YES];

    }


}
-(void)rightButtonClick{
    
    if (_hasCollect == NO) {
        [self.rightButton setImage:[UIImage imageNamed:@"icon_shoucang128-128"] forState:UIControlStateNormal];
        _hasCollect = YES;
    }else{
        [self.rightButton setImage:[UIImage imageNamed:@"icon_shoucang_2_128-128"] forState:UIControlStateNormal];
        _hasCollect = NO;
    }
    
    
}
-(void)showOrHidenToolBar{
    
    if (_isShowToolBar) {
        [self hideTopBar];
        [self hideBottomBar];
        [self hideCenterButton];
    }else{
        [_effectView removeFromSuperview];
        [self showTopBar];
        [self showBottomBar];
        [self showCenterButton];

    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer

{
    
    return YES;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    
}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _muenTable) {
        return ;
    }
    
    CGPoint point=scrollView.contentOffset;
    
    NSInteger height = [[textview stringByEvaluatingJavaScriptFromString:
                         @"document.body.scrollHeight"] integerValue];
    
    NSInteger heigh = point.y+kScreenHeight;
    NSLog(@"pointyyyyyyy:::%ld",(long)heigh);
    
    NSLog(@"webview height::::: %ld ",(long)height);
    
    [_commentTextView.commentTextInputView resignFirstResponder];
    if (scrollView.contentOffset.y > _oldOffset) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        
        [self hideBottomBar];
        [self hideTopBar];
        [self hideCenterButton];

    }else{
        [self showBottomBar];
        [self showTopBar];
        [self showCenterButton];

    }
    if (point.y == 0) {
        [self showBottomBar];
        [self showTopBar];
        [self showCenterButton];

    }
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
    
}
#pragma mark 显示隐藏上下工具栏动画
- (void)showBottomBar{
    
    [UIView animateWithDuration:0.35 animations:^{
        _foot.frame = CGRectMake(0, kScreenHeight-60, kScreenWidth, 60);
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hideBottomBar{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.foot.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 60);
    } completion:^(BOOL finished) {
    }];
    
}



- (void)showTopBar{


    _isShowToolBar = YES;
    [UIView animateWithDuration:0.35 animations:^{
        _head.frame = CGRectMake(0, 20, kScreenWidth, 88);
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hideTopBar{
    _isShowToolBar = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.head.frame = CGRectMake(0, -88, kScreenWidth, 88);
    } completion:^(BOOL finished) {
    }];
    
}
-(void)showCenterButton{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.leftButton.frame = CGRectMake(-10, kScreenHeight/2-25, 50, 50);
        self.rightButton.frame = CGRectMake(kScreenWidth - 40, kScreenHeight/2-25, 50, 50);
    } completion:^(BOOL finished) {
    }];
    
}
-(void)hideCenterButton{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.leftButton.frame = CGRectMake(-50, kScreenHeight/2-25, 50, 50);
        self.rightButton.frame = CGRectMake(kScreenWidth, kScreenHeight/2-25, 50, 50);
    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark 点击事件
-(void)share:(UIButton *)sender{

    
    NSURL *url = [NSURL URLWithString:@"http://m.weibo.cn/2747573813/profile?jumpfrom=weibocom"];
    
    _showComment = NO;
    
    [self sharewithtitle:@"足够吸引人的标题" andimages:@[[UIImage imageNamed:@"failed"]] andtext:@"足够吸引人的内容" andurl:url andtype:0];

}
-(void)backclick{
    
    if (_isPush) {
        
        [_muenTable removeFromSuperview];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).url = nil;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        ((AppDelegate *)[UIApplication sharedApplication].delegate).url = nil;
        _isPush = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
