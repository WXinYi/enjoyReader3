//
//  QuanViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/28.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "QuanViewController.h"
#import "QuanTableViewCell.h"
#import "ReplyDetailViewController.h"
#import "quanChooseAlartView.h"
@interface QuanViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QuanViewController
{
    UIView *chooseBackgroundView;
    quanChooseAlartView*chooseView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BBG);

    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"作品名称";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self loadTableView];
    [self addChooseView];
    
    
}
-(void)addChooseView{

    chooseBackgroundView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    chooseBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonTapped)];
    
    [chooseBackgroundView addGestureRecognizer:cancelTap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:chooseBackgroundView];
    
    chooseBackgroundView.hidden = YES;
    
    chooseView = [[NSBundle mainBundle] loadNibNamed:@"quanChooseAlartView" owner:nil options:nil][0];
    chooseView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 262);

    chooseView.backgroundColor = [UIColor clearColor];
    
    [chooseBackgroundView addSubview:chooseView];
    
}

-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)loadTableView{
    
    UITableView *worktable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    worktable.delegate = self;
    worktable.dataSource = self;
    worktable.tableFooterView = [UIView new];
    worktable.separatorStyle =UITableViewCellSeparatorStyleNone;
    worktable.tag = 500;
    worktable.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self.view addSubview:worktable];
}
//根据tag判断是哪个tableview，小于1k的是总tableview   通过constant和heightforcell 配合改变cell高度
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 235;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuanTableViewCell *cell = [[QuanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"QuanTableViewCell" owner:nil options:nil] firstObject];
    
    cell.nameAndTime.dk_textColorPicker =DKColorPickerWithKey(TXTTHREE);
    cell.zanBtn.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.commentBtn.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    cell.replyTable.tag = indexPath.section+1000;
    cell.replyTable.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [cell.arrarBtn addTarget:self action:@selector(arrarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.contentHeight.constant = 70;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyDetailViewController *vc = [[ReplyDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
   
}
-(void)arrarBtnClick:(UIButton *)sender{
    
    chooseBackgroundView.hidden = NO;

    [UIView animateWithDuration:0.35 animations:^{
        
        chooseView.frame = CGRectMake(0, kScreenHeight-262, kScreenWidth, 262);

    } completion:^(BOOL finished) {

    }];

}
-(void)cancelButtonTapped{

    [UIView animateWithDuration:0.35 animations:^{
         chooseView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 262);
    } completion:^(BOOL finished) {
        chooseBackgroundView.hidden = YES;

    }];

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
