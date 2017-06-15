//
//  MessageViewController.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/2.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "FindViewController.h"
#import "H5ThreeTableViewCell.h"
#import "H5FourTableViewCell.h"
#import "HotBookTableViewCell.h"
#import "HomeHeaderView.h"
#import "ShowViewController.h"
@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navLabel.text = @"发现";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BBG);

    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self loadtableview];
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

-(void)loadtableview{


    UITableView *findTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    findTableView.delegate = self;
    findTableView.dataSource = self;
    findTableView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    findTableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);

    [self.view addSubview:findTableView];
    [self loadinghide];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 2) {
        return 5;
    }
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 1){
        return 114;
    }return 92;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return  53.0f;
    }
    return 0.1f;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 2) {
        HomeHeaderView *HeaderView =[[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:nil options:nil] firstObject];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 3)];
        view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        
        HeaderView.frame = CGRectMake(0, 3, kScreenWidth, 50);
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 53)];
        HeaderView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);

        [header addSubview:view];
        
        [header addSubview:HeaderView];
        HeaderView.headerIcon.image = [UIImage imageNamed:@"shouye_icon_remenshumu"];
        HeaderView.jumpImage.hidden = YES;
        HeaderView.headerTitle.text = @"热门书目";
        HeaderView.headerTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        HeaderView.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
        return header;

    }
    return nil;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 1){
    
        H5FourTableViewCell *cell = [[H5FourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"h5cell"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"H5FourTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        cell.view1.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        cell.view2.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        cell.view3.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        cell.view4.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        cell.label1.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        cell.label2.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        cell.label3.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        cell.label4.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        
        return cell;
    }
    HotBookTableViewCell *bookcell = [[HotBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bookcell"];
    bookcell = [[[NSBundle mainBundle] loadNibNamed:@"HotBookTableViewCell" owner:nil options:nil] firstObject];
    bookcell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    bookcell.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    bookcell.infoLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    bookcell.selectionStyle = UITableViewCellSelectionStyleNone;
    bookcell.lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    
    
    
    return bookcell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.section == 2) {
        
        ShowViewController*vc = [[ShowViewController alloc] init];
        vc.isPush = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

@end
