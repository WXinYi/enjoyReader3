//
//  ArticleContentViewController.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/5.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ArticleContentViewController.h"
#import <WordPressShared/WPFontManager.h>
#import "WPStyleGuide.h"
#import "WPEditorView.h"
#import "detailBackView.h"
#import "CommentTextView.h"
#import "commentFootView.h"
#import "CommentViewController.h"
#import "SWRTableViewController.h"
#import "AppDelegate.h"

@interface ArticleContentViewController ()<WPEditorViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic ,strong) UITableView *mainTableView;
@property (nonatomic ,strong) WPEditorView *editorView;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic,assign) BOOL isWebViewshow;
@property (nonatomic,assign) NSInteger webHeight;
@property (nonatomic ,strong) detailBackView *head;
@property (nonatomic,strong ) commentFootView *foot;
@property (nonatomic ,assign) CGFloat oldOffset;
@property (nonatomic ,assign) CGFloat keyboardY;
@property (nonatomic ,assign) BOOL isShowToolBar;
@property (nonatomic ,strong)CommentTextView *commentTextView;//输入评论的视图

@end

@implementation ArticleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadingCircleJoinAnimation];
    
    [self addWebView];
//    [self makeTableView];
    [self addheadView];
    
    [self becomeFirstResponder];
    //    添加金句按钮
    UIMenuItem *menuItem1 = [[UIMenuItem alloc]initWithTitle:@"添加金句"action:@selector(addToTemplate:)];
    UIMenuItem *menuItem2 = [[UIMenuItem alloc]initWithTitle:@"分享"action:@selector(addToTemplate:)];

    UIMenuController*menu = [UIMenuController sharedMenuController];
    
    [menu setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,nil]];
    
    [menu setMenuVisible:YES animated:YES];
}
//长按菜单
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if(action ==@selector(addToTemplate:)) {
        
        NSString* selection = [self.editorView.webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
        
        if(selection.length>0) {
            
            return YES;
            
        }else{
            
            return NO;
            
        }
    }
    
    return NO;
}
//长按菜单按钮点击事件
-(void)addToTemplate:(UIMenuController*)sender{
    
    NSString* selection = [self.editorView.webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    
    NSLog(@"selection===%@",selection);
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    _isShowToolBar = YES;
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
                                  initWithTarget:self action:@selector(tapAction:)];
    
    //开启交互
    self.view.userInteractionEnabled=YES;
    //添加手势到视图

    [self.view addGestureRecognizer:tapp];
    
    _isWebViewshow = NO;

}
//点击手势方法
-(void)tapAction:(UITapGestureRecognizer *)sender
{
        [self.view endEditing:YES];
    
}
//当键盘出现时，调用此方法
-(void)keyboardwill:(NSNotification *)sender
{
    //获取键盘高度
    NSDictionary *dict=[sender userInfo];
    NSValue *value=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardrect = [value CGRectValue];
    int height=keyboardrect.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _commentTextView.frame = CGRectMake(0, kScreenHeight-height-93, kScreenWidth, 93);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

//当键盘隐藏时候，视图回到原定
-(void)keybaordhide:(NSNotification *)sender
{
    _commentTextView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 93);
}


-(void)addheadView{

    _commentTextView = [[[NSBundle mainBundle] loadNibNamed:@"CommentTextView" owner:nil options:nil] firstObject];
    _commentTextView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 93);
    
    [self.view addSubview:_commentTextView];
    _head = [[[NSBundle mainBundle] loadNibNamed:@"detailBackView" owner:nil options:nil] firstObject];
    _head.frame = CGRectMake(0, 20, kScreenWidth, 77);
    [_head.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _head.authorIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
    [_head.authorIcon addGestureRecognizer:iconTap];
    
    _head.authorName.userInteractionEnabled = YES;
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
    [_head.authorName addGestureRecognizer:nameTap];

    [self.view addSubview:_head];

    _foot =[[[NSBundle mainBundle] loadNibNamed:@"commentFootView" owner:nil options:nil] lastObject];
    _foot.frame = CGRectMake(0, kScreenHeight-42, kScreenWidth, 42);
    [_foot.allCommentBtn addTarget:self action:@selector(toMoreComment:) forControlEvents:UIControlEventTouchUpInside];
    [_foot.commontBtn addTarget:self action:@selector(callCommentTextView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_foot];
    
    
}
-(void)iconClick:(id)tap{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SWRTableViewController" bundle:nil];
    SWRTableViewController *me = [sb instantiateInitialViewController];
    me.isFromComment = YES;
    [self.navigationController pushViewController:me animated:YES];
    
}

-(void)toMoreComment:(UIButton *)sender{
    
    CommentViewController *vc = [[CommentViewController alloc]init];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)callCommentTextView:(UIButton *)sender{

    [UIView animateWithDuration:0.35 animations:^{
        _commentTextView.frame = CGRectMake(0, kScreenHeight-93, kScreenWidth, 93);
    } completion:^(BOOL finished) {
        [_commentTextView.commentTextInputView becomeFirstResponder];
    }];

}
-(void)addWebView{

    self.editorView = [[WPEditorView alloc]init];
    self.editorView.delegate = self;
    self.editorView.autoresizesSubviews = YES;
    self.editorView.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0.0, 30.0, kScreenWidth, kScreenHeight-20);
    self.editorView.frame = frame;
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHidenToolBar)];
    
    //点击的次数
    singleRecognizer.delegate =self;
    
    [self.view addGestureRecognizer:singleRecognizer];
    self.editorView.webView.userInteractionEnabled = YES;
    [self.view addSubview:self.editorView];
}

-(void)showOrHidenToolBar{

    if (_isShowToolBar) {
        [self hideTopBar];
        [self hideBottomBar];
        
        
    }else{
        
        [self showTopBar];
        [self showBottomBar];
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
    
    
    CGPoint point=scrollView.contentOffset;
    
    NSInteger height = [[self.editorView.webView stringByEvaluatingJavaScriptFromString:
                         @"document.body.scrollHeight"] integerValue];

    NSInteger heigh = point.y+kScreenHeight;
    NSLog(@"pointyyyyyyy:::%ld",(long)heigh);

    NSLog(@"webview height::::: %ld ",(long)height);
    
    [_commentTextView.commentTextInputView resignFirstResponder];
    if (scrollView.contentOffset.y > _oldOffset) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        
        [self hideBottomBar];
        [self hideTopBar];
    }else{
        [self showBottomBar];
        [self showTopBar];
    }
    if (point.y == 0) {
        [self showBottomBar];
        [self showTopBar];
    }
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
    
}
#pragma mark 显示隐藏上下工具栏动画
- (void)showBottomBar{

    [UIView animateWithDuration:0.35 animations:^{
        _foot.frame = CGRectMake(0, kScreenHeight-42, kScreenWidth, 42);
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hideBottomBar{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.foot.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 42);
    } completion:^(BOOL finished) {
    }];
    
}
- (void)showTopBar{
    _isShowToolBar = YES;
    [UIView animateWithDuration:0.35 animations:^{
        _head.frame = CGRectMake(0, 20, kScreenWidth, 77);
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hideTopBar{
    _isShowToolBar = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.head.frame = CGRectMake(0, -77, kScreenWidth, 77);
    } completion:^(BOOL finished) {
    }];
    
}
#pragma mark - Getters and Setters
- (NSString*)titleText
{
    return [self.editorView title];
}

- (void)setTitleText:(NSString*)titleText
{
    [self.editorView.titleField setText:titleText];
    [self.editorView.sourceViewTitleField setText:titleText];
}
- (NSString*)bodyText
{
    return [self.editorView contents];
}

- (void)setBodyText:(NSString*)bodyText
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"html"];
    NSString *htmlParam = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.editorView.contentField setHtml:htmlParam];
    NSInteger height = [[self.editorView.webView stringByEvaluatingJavaScriptFromString:
                         @"document.body.scrollHeight"] integerValue];
    //弹簧效果
    
    [[[self.editorView.webView subviews] objectAtIndex:0] setBounces:NO];
    self.editorView.webView.scrollView.delegate = self;
        
    self.editorView.webView.scrollView.showsVerticalScrollIndicator = YES;
    
    self.editorView.webView.scrollView.showsHorizontalScrollIndicator = FALSE;

    _webHeight = height;
}



- (UIColor *)placeholderColor {
    if (!_placeholderColor) {
        
        return [UIColor lightGrayColor];
        
    }
    return _placeholderColor;
}

- (void)customizeAppearance
{
    self.editorView.backgroundColor = [UIColor whiteColor];
    self.placeholderColor = [WPStyleGuide grey];

    [WPFontManager merriweatherBoldFontOfSize:16.0];
    [WPFontManager merriweatherBoldItalicFontOfSize:16.0];
    [WPFontManager merriweatherItalicFontOfSize:16.0];
    [WPFontManager merriweatherLightFontOfSize:16.0];
    [WPFontManager merriweatherRegularFontOfSize:16.0];
    
    self.editorView.sourceViewTitleField.font = [WPFontManager merriweatherBoldFontOfSize:24.0];
//    self.editorView.sourceContentDividerView.backgroundColor = [WPStyleGuide greyLighten30];
   
}
#pragma mark - WPEditorViewDelegate

- (void)editorTextDidChange:(WPEditorView*)editorView
{
    
}

- (void)editorTitleDidChange:(WPEditorView *)editorView
{
    
}
- (void)editorViewDidFinishLoading:(WPEditorView*)editorView{


}
- (void)editorViewDidFinishLoadingDOM:(WPEditorView*)editorView
{
    
    [self.editorView disableEditing];
    //临时数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"html"];
    NSString *htmlParam = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self setTitleText:@"I'm editing a post!一二三四我六七八九十"];
    [self setBodyText:htmlParam];
    [self loadinghide];
    _isWebViewshow =YES;

}

- (void)editorView:(WPEditorView*)editorView
      fieldCreated:(WPEditorField*)field
{
    if (field == self.editorView.titleField) {
        
        [field setMultiline:NO];
        [field setPlaceholderColor:self.placeholderColor];
        [field setPlaceholderText:self.titlePlaceholderText];

    } else if (field == self.editorView.contentField) {
        
        [field setMultiline:YES];
        [field setPlaceholderText:self.bodyPlaceholderText];
        [field setPlaceholderColor:self.placeholderColor];
    }
    
}

- (void)editorView:(WPEditorView*)editorView
      fieldFocused:(WPEditorField*)field
{

}

- (void)editorView:(WPEditorView*)editorView sourceFieldFocused:(UIView*)view
{
    
}

- (BOOL)editorView:(WPEditorView*)editorView
        linkTapped:(NSURL *)url
             title:(NSString*)title
{
           [[UIApplication sharedApplication] openURL:url];
    return YES;
}

- (void)editorView:(WPEditorView*)editorView
       imageTapped:(NSString *)imageId
               url:(NSURL *)url
         imageMeta:(WPImageMeta *)imageMeta
{
    
}

- (BOOL)editorView:(WPEditorView*)editorView
       imageTapped:(NSString *)imageId
               url:(NSURL *)url
{
        return YES;
}

- (void)editorView:(WPEditorView*)editorView
       videoTapped:(NSString *)videoId
               url:(NSURL *)url
{

}

- (void)editorView:(WPEditorView*)editorView
     imageReplaced:(NSString *)imageId
{
    
}

- (void)editorView:(WPEditorView*)editorView
     videoReplaced:(NSString *)videoId
{
    
}

- (void)editorView:(WPEditorView *)editorView videoPressInfoRequest:(NSString *)videoPressID
{
    
}

- (void)editorView:(WPEditorView *)editorView mediaRemoved:(NSString *)mediaID
{
    
    
}

- (void)editorView:(WPEditorView*)editorView stylesForCurrentSelection:(NSArray*)styles
{
   
}

- (void)editorView:(WPEditorView *)editorView imagePasted:(UIImage *)image
{
    
}
-(void)back{

//    if (_isPush) {

        [self.navigationController popViewControllerAnimated:YES];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).url = nil;
        
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).url = nil;
//
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
