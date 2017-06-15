//
//  CommentViewController.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/10.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTextView.h"
#import "CommentTableViewCell.h"
#import "XXXRoundMenuButton.h"
#import "SWRTableViewController.h"
#import "YZInputView.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *commentTableView;
@property (nonatomic ,strong)UIView *commentTextView;
@property (strong, nonatomic)  XXXRoundMenuButton *roundMenuBtn;
@property (strong ,nonatomic) YZInputView *imputView;
@property (nonatomic ,assign) CGFloat keyboardY;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    
    [self loadTableView];

}

-(void) viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    //导航栏相关
//    UIImage *imgLogin = [UIImage imageNamed:@"Navigation"];
//    
//    imgLogin = [imgLogin stretchableImageWithLeftCapWidth:floorf(imgLogin.size.width/2) topCapHeight:floorf(imgLogin.size.height/2)];//拉伸图片
//    
//    [self.navigationController.navigationBar setBackgroundImage:imgLogin forBarMetrics:UIBarMetricsDefault];
//    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

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
        
        _commentTextView.frame = CGRectMake(0, kScreenHeight-height-50-64, kScreenWidth, 50);
        
    } completion:^(BOOL finished) {
        
    }];

}

//当键盘隐藏时候，视图回到原定
-(void)keybaordhide:(NSNotification *)sender
{
    _commentTextView.frame = CGRectMake(0, kScreenHeight-64-50, kScreenWidth, 50);
}

-(void)loadTableView{

    _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-84) style:UITableViewStylePlain];
    
    _commentTableView.delegate = self;
    
    _commentTableView.dataSource = self;
    
    _commentTableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:_commentTableView];
    
    _commentTextView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50-64, kScreenWidth, 50)];
    
    _commentTextView.backgroundColor = [UIColor lightGrayColor];
    
    _imputView = [[YZInputView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-80, 30)];
    
    _imputView.placeholder = @"输入评论";
    _imputView.placeholderColor = [UIColor grayColor];
    // 监听文本框文字高度改变
    _imputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
        // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
        // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
        
//       _imputView.frame = textHeight + 10;
    };
    
    // 设置文本框最大行数
    _imputView.maxNumberOfLines = 4;
    
    [_commentTextView addSubview:_imputView];
    
    UIButton *DoneButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 20 , 40, 10)];
    [DoneButton setTitle:@"发送" forState:UIControlStateNormal];

    [DoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_commentTextView addSubview: DoneButton];
    
    [self.view addSubview:_commentTextView];

}
-(void)callCommentTextView:(UIButton *)sender{
    
    
    [_imputView becomeFirstResponder];
    _imputView.placeholderView.hidden = YES;
    _imputView.text = @"@hah";

}


-(void)iconClick:(id)tap{

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SWRTableViewController" bundle:nil];
    
    SWRTableViewController *me = [sb instantiateInitialViewController];
    
    me.isFromComment = YES;
    
    [self.navigationController pushViewController:me animated:YES];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier=@"tg";
    
    CommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {

        cell= [[[NSBundle mainBundle]loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] firstObject];
        
    }
    
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
    
    [cell.allCommentIcon addGestureRecognizer:iconTap];
    
    cell.allCommentIcon.userInteractionEnabled = YES;
    
    [cell.allCommentBtn addTarget:self action:@selector(callCommentTextView:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 99;

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

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
