//
//  ReplyDetailViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/26.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ReplyDetailViewController.h"
#import "ReplyDetailCellTableViewCell.h"
#import "CommentDetailTableViewCell.h"
#import "CommentTextView.h"
@interface ReplyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic ,strong) CommentTextView *commentTextView;//输入评论的视图
@property (nonatomic ,assign) BOOL showComment;

@end

@implementation ReplyDetailViewController
{
    UIView *replyview;
    UITextField *replytextfiled;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:@"icon_diandiandian" hightImage:@"icon_diandiandian" target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"评论详情";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self loadTableView];
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
    
    
   
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"IMG_3101"] forBarMetrics:UIBarMetricsDefault ];
        
    }else{
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault ];
    }
}
-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)loadTableView{
    
    UITableView *worktable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-64) style:UITableViewStyleGrouped];
    worktable.delegate = self;
    worktable.dataSource = self;
    worktable.tableFooterView = [UIView new];
    worktable.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    worktable.separatorInset = UIEdgeInsetsMake(0, 61, 0, 0);

    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
    }

    [self.view addSubview:worktable];
    
    replyview = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-64, kScreenWidth, 64)];
    replyview.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    replytextfiled = [[UITextField alloc] initWithFrame:CGRectMake(15, 14, kScreenWidth-30, 35)];
    replytextfiled.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    replytextfiled.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    replytextfiled.placeholder = @"评论：";
    replytextfiled.borderStyle = UITextBorderStyleRoundedRect;
    replytextfiled.userInteractionEnabled = NO;
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    commentBtn.backgroundColor = [UIColor clearColor];
    [commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [replyview addSubview:commentBtn];
    [replyview addSubview:replytextfiled];
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [replyview addSubview:line];
    [self.view addSubview:replyview];
    
    _commentTextView = [[[NSBundle mainBundle] loadNibNamed:@"CommentTextView" owner:nil options:nil] firstObject];
    _commentTextView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 118);
    _commentTextView.dk_backgroundColorPicker =DKColorPickerWithKey(BBG);
    _commentTextView.commentTextInputView.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    _commentTextView.commentTextInputView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _commentTextView.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _commentTextView.sendBtn.backgroundColor = [WXYClassMethodsViewController colorWithHexString:@"#cd7776"];
    [self.view addSubview:_commentTextView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 139;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 129;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ReplyDetailCellTableViewCell *header = [[ReplyDetailCellTableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 126)];
    header = [[[NSBundle mainBundle] loadNibNamed:@"ReplyDetailCellTableViewCell" owner:nil options:nil] firstObject];
    header.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    header.nameLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    header.timeLabel.dk_textColorPicker = DKColorPickerWithKey(TXTFOUR);
    header.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    header.zanBtn.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTFOUR);
    header.replyBtn.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTFOUR);
    header.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CommentDetailTableViewCell *cell = [[CommentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentDetailTableViewCell" owner:nil options:nil] firstObject];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.nameTimeLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)commentClick{

    self.showComment = YES;
    [_commentTextView.commentTextInputView becomeFirstResponder];


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
            
            _commentTextView.frame = CGRectMake(0, kScreenHeight-height-118-64, kScreenWidth, 118);
            
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
//点击手势方法
-(void)tapAction:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
