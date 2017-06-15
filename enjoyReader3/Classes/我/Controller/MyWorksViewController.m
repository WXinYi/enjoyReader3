//
//  MyWorksViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/21.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "MyWorksViewController.h"
#import "PersonalTableViewCell.h"
#import "MySerializationViewController.h"
@interface MyWorksViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"我的作品";
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
-(void)loadTableView{

    UITableView *worktable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    worktable.delegate = self;
    worktable.dataSource = self;
    worktable.separatorInset = UIEdgeInsetsMake(0, 63, 0, 0);
    worktable.tableFooterView = [[UIView alloc] init];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
        
    }else{
        
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
        
    }
    worktable.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self.view addSubview:worktable];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 46;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 66;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *contentview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    contentview.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    NSArray *titleArray = [NSArray arrayWithObjects:@"连载作品",@"已发表文章", nil];
    NSArray *iconarray = [NSArray arrayWithObjects:@"icon_2lianzaizuopin40-40",@"icon_2wenzhang40-40",nil];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    line.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [contentview addSubview:line];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 20, 20)];
    iconImage.image = [UIImage imageNamed:iconarray[section]];
    [contentview addSubview:iconImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 18, 100, 16)];
    titleLabel.text = titleArray[section];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    [contentview addSubview:titleLabel];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 45.5, kScreenWidth, 0.5)];
    lineview.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [contentview addSubview:lineview];
    return contentview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalTableViewCell *cell = [[PersonalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil] firstObject];
    cell.personalTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    cell.personalInfo.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.writeBtn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        //连载
        
        MySerializationViewController *vc = [[MySerializationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
    
        
    
    }
}


-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
