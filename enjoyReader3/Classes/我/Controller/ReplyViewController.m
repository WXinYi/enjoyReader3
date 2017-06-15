//
//  CommentViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/26.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ReplyViewController.h"
#import "ReplyTableViewCell.h"
#import "ReplyDetailViewController.h"
@interface ReplyViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"评论";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);

    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self loadTableView];
    
    
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
    
    UITableView *worktable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    worktable.delegate = self;
    worktable.dataSource = self;
    worktable.tableFooterView = [UIView new];
    worktable.separatorStyle =UITableViewCellSeparatorStyleNone;
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
    }
    worktable.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self.view addSubview:worktable];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 199;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyTableViewCell *cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyTableViewCell" owner:nil options:nil] firstObject];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.nameLabe.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    cell.timeLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    cell.commentLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.replyView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.replyLine.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.CommentHeight.constant = 36;
    cell.viewHeight.constant =77;
    cell.contentHeight.constant = 33;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ReplyDetailViewController *vc = [[ReplyDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

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
