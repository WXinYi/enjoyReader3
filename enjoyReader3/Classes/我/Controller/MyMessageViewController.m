//
//  MyMessageViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/22.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MessageTableViewCell.h"
#import "SystemMessageViewController.h"
#import "ReplyViewController.h"
@interface MyMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"我的消息";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
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
//    worktable.separatorStyle = UITableViewCellSeparatorStyleNone;
    worktable.tableFooterView = [UIView new];
    worktable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
        return 2;
    }return 5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 6;
    }
    return 38;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *header1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
        header1.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        return header1;
    }
    
    UIView *header2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
    header2.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    UILabel *headerlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 50, 14)];
    headerlabel.text = @"消息";
    headerlabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    headerlabel.font = [UIFont systemFontOfSize:14];
    headerlabel.textAlignment = NSTextAlignmentLeft;
    [header2 addSubview:headerlabel];
    
    return header2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 52;
    }
    return 105;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        NSArray *titleArray = [NSArray arrayWithObjects:@"评论",@"系统通知", nil];
        NSArray *iconarray = [NSArray arrayWithObjects:@"icon_2lianzaizuopin40-40",@"icon_2wenzhang40-40",nil];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 20, 20)];
        iconImage.image = [UIImage imageNamed:iconarray[indexPath.row]];
        [cell.contentView addSubview:iconImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 18, 100, 15)];
        titleLabel.text = titleArray[indexPath.row];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-27, 20, 12, 12)];
        arrow.image = [UIImage imageNamed:@"jump"];
        [cell.contentView addSubview:arrow];
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else{
    
        MessageTableViewCell *cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        cell.nameLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        cell.timeLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
        cell.messageView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        cell.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ReplyViewController *vc =[[ReplyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
        //系统通知
            SystemMessageViewController *vc = [[SystemMessageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
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
