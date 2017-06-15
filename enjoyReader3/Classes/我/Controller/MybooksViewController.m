//
//  MybooksViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/21.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "MybooksViewController.h"
#import "MyBooksTableViewCell.h"
#import "CollectedBooksViewController.h"
#import "ExtractViewController.h"
@interface MybooksViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MybooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"我的书架";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BBG);

    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
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
//    worktable.separatorStyle = UITableViewCellSeparatorStyleNone;
    worktable.tableFooterView = [UIView new];
    worktable.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [worktable setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
    }
    [self.view addSubview:worktable];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 180;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    MyBooksTableViewCell *bookcell = [[MyBooksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    bookcell = [[[NSBundle mainBundle] loadNibNamed:@"MyBooksTableViewCell" owner:nil options:nil] firstObject];
    bookcell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        bookcell.view1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        bookcell.view1.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        bookcell.view1.layer.shadowOpacity = YES;
        
        bookcell.view2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        bookcell.view2.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        bookcell.view2.layer.shadowOpacity = YES;
        
        bookcell.view3.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        bookcell.view3.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        bookcell.view3.layer.shadowOpacity = YES;
    }
    bookcell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return bookcell;



}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row%2 == 1) {
        CollectedBooksViewController *vc = [[CollectedBooksViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ExtractViewController *vc = [[ExtractViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    
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
