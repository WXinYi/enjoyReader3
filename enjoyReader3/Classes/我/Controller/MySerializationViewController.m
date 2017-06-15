//
//  MySerializationViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/26.
//  Copyright © 2016年 王馨仪. All rights reserved.
//我的连载目录

#import "MySerializationViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
@interface MySerializationViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@end

@implementation MySerializationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)loadTableView{
    
    UITableView *worktable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    worktable.delegate = self;
    worktable.dataSource = self;
    worktable.tableFooterView = [UIView new];
    worktable.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    worktable.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
    }

    [self.view addSubview:worktable];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *iconarr  = [NSArray arrayWithObjects:@"xie_icon_open",@"xie_icon_open", nil];
    NSArray *titleArr  = [NSArray arrayWithObjects:@"修改作品信息",@"目录", nil];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    lineview.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
   
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconarr[section]]];
    icon.frame = CGRectMake(15, 21, 18, 20);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 23, 200, 17)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    titleLabel.text = titleArr[section];
    
    [header addSubview:lineview];
    [header addSubview:icon];
    [header addSubview:titleLabel];
    if (section == 1) {
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kScreenWidth, 0.5)];
        line2.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
        [header addSubview:line2];
        
    }
    return header;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MGSwipeTableCell *cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"标题";
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.delegate = self; //optional
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        cell.rightButtons = @[
                              [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"4fabu_yejianmoshi"] backgroundColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"] insets:UIEdgeInsetsMake(0, 0, 0, 0) callback:^BOOL(MGSwipeTableCell *sender) {
                                  NSLog(@"444");
                                  return YES;
                              }],
                              [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"3shanchu_yejianmoshi"] backgroundColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"] insets:UIEdgeInsetsMake(0, 1, 0, 1) callback:^BOOL(MGSwipeTableCell *sender) {
                                  NSLog(@"333");
                                  return YES;
                              }],
                              [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"2xiayi_yejianmoshi"] backgroundColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"] insets:UIEdgeInsetsMake(0, 1, 0, 1) callback:^BOOL(MGSwipeTableCell *sender) {
                                  NSLog(@"222");
                                  return YES;
                              }],
                              [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"1shangyi_yejianmoshi"] backgroundColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"] insets:UIEdgeInsetsMake(0, 1, 0, 1) callback:^BOOL(MGSwipeTableCell *sender) {
                                  NSLog(@"111");
                                  return YES;
                              }]
                              
                              ];
    }else{
        cell.rightButtons = @[
                              [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"4fabu"] backgroundColor:[UIColor whiteColor] insets:UIEdgeInsetsMake(0, 1, 0, 1) callback:^BOOL(MGSwipeTableCell *sender) {
                                  NSLog(@"444");
                                  return YES;
                              }],
                              [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"3shanchu"] backgroundColor:[UIColor whiteColor] insets:UIEdgeInsetsMake(0, 1, 0, 1) callback:^BOOL(MGSwipeTableCell *sender) {
                                  NSLog(@"333");
                                  return YES;
                              }],
                              [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"2xiayi"] backgroundColor:[UIColor whiteColor] insets:UIEdgeInsetsMake(0, 1, 0, 1) callback:^BOOL(MGSwipeTableCell *sender) {
                                  NSLog(@"222");
                                  return YES;
                              }],
                              [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"1shangyi"] backgroundColor:[UIColor whiteColor] insets:UIEdgeInsetsMake(0, 1, 0, 1) callback:^BOOL(MGSwipeTableCell *sender) {
                                  NSLog(@"111");
                                  return YES;
                              }]
                              
                              ];
    }   

    cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    return cell;
    
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
