//
//  ChooseExtractViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/30.
//  Copyright © 2016年 王馨仪. All rights reserved.
//选择摘录

#import "ChooseExtractViewController.h"
#import "ExtractTableViewCell.h"
@interface ChooseExtractViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;

@end

@implementation ChooseExtractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _navigationTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.chooseTableView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self.backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [self.chooseTableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [self.chooseTableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
    }
    
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
    return 112;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExtractTableViewCell *cell = [[ExtractTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"ExtractTableViewCell" owner:nil options:nil] firstObject];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    cell.timeLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}


-(void)popViewController{


    [self dismissViewControllerAnimated:YES completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
