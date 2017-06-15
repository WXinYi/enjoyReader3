//
//  SystemMessageViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SysMessageTableViewCell.h"
@interface SystemMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"系统通知";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
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
    return 64;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    return header;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMessageTableViewCell *cell = [[SysMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"SysMessageTableViewCell" owner:nil options:nil] firstObject];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.nameLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    cell.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.timeLabel.dk_textColorPicker = DKColorPickerWithKey(TXTFOUR);
    cell.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;

}

-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
