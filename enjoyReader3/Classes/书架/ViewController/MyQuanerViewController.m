//
//  BookShelfViewController.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/2.
//  Copyright © 2016年 王馨仪. All rights reserved.
//  书架控制器

#import "MyQuanerViewController.h"
#import "BookShelCell.h"
#import "AppDelegate.h"
#import "QuanViewController.h"

@interface MyQuanerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *bookShelfTableView;
@end

@implementation MyQuanerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadingFailure];
    [self loadTableView];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);

    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navLabel.text = @"我的圈儿";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.edgesForExtendedLayout=UIRectEdgeBottom;
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BBG);


}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [UIApplication sharedApplication].statusBarHidden = NO;
    
//    //导航栏相关
//    UIImage *imgLogin = [UIImage imageNamed:@"Navigation"];
//    imgLogin = [imgLogin stretchableImageWithLeftCapWidth:floorf(imgLogin.size.width/2) topCapHeight:floorf(imgLogin.size.height/2)];//拉伸图片
//    [self.navigationController.navigationBar setBackgroundImage:imgLogin forBarMetrics:UIBarMetricsDefault];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
   
}
-(void)loadTableView{
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line1.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self.view addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 3)];
    line2.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self.view addSubview:line2];
    
    _bookShelfTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 3.5, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    _bookShelfTableView.delegate =self;
    _bookShelfTableView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _bookShelfTableView.dataSource = self;
    
    _bookShelfTableView.tableFooterView = [[UIView alloc] init];
    _bookShelfTableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
         [self.view addSubview:_bookShelfTableView];
    
    [self loadinghide];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookShelCell  * cell =  (BookShelCell* )[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"BookShelCell" owner:self options:nil] firstObject];
    
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    
    cell.myBookName.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    
    cell.myBookName.text = @"假数据";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuanViewController*vc = [[QuanViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

@end
