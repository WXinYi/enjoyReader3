//
//  SearchViewViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/29.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "SearchViewViewController.h"
#import "SearchTextFile.h"

@interface SearchViewViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)SearchTextFile *searchBarTextFiled;
@end

@implementation SearchViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    searchView.backgroundColor = [UIColor yellowColor];
    
    UIImage *searchImage = [UIImage imageNamed:@"shouye_icon_sousuo"];
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:searchImage];
    searchImageView.frame = CGRectMake(0, 0, 20, 20);
    
    _searchBarTextFiled = [[SearchTextFile alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth-60, 30) drawingLeft:searchImageView];
    _searchBarTextFiled.layer.masksToBounds = YES;
    _searchBarTextFiled.layer.cornerRadius = 15;
    _searchBarTextFiled.backgroundColor = [WXYClassMethodsViewController colorWithHexString:@"#ececec"];
    _searchBarTextFiled.delegate = self;
    _searchBarTextFiled.returnKeyType = UIReturnKeySearch;
    _searchBarTextFiled.placeholder = @"搜索连载、文章";
    [searchView addSubview:_searchBarTextFiled];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popHome)];
    
    [rightItem setTintColor:[WXYClassMethodsViewController colorWithHexString:@"ba1c18"]];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.titleView = _searchBarTextFiled;
    
    [self.navigationItem setHidesBackButton:TRUE animated:NO];
   
    [self loadeTableView];
    
}
-(void)loadeTableView{
   
    UITableView *worktable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    worktable.delegate = self;
    worktable.dataSource = self;
    worktable.separatorInset = UIEdgeInsetsMake(0, 19, 0, 0);
    worktable.tableFooterView = [UIView new];
    worktable.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    worktable.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self.view addSubview:worktable];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    
    line.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    UILabel *titleLble = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, 100, 16)];
    titleLble.text = @"热门搜索";
    titleLble.font = [UIFont systemFontOfSize:16];
    titleLble.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    [line addSubview:titleLble];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5)];
    bottomLine.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [line addSubview:bottomLine];
    return line;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str = [NSString stringWithFormat:@"%ld 贝加尔湖畔",indexPath.row+1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
    if (indexPath.row<3) {
        [attriString addAttribute:NSForegroundColorAttributeName  //文字颜色
                            value:[WXYClassMethodsViewController colorWithHexString:@"#ba1c18"]
                            range:NSMakeRange(0, 1)];
        
    }else{
        [attriString addAttribute:NSForegroundColorAttributeName  //文字颜色
                            value:[WXYClassMethodsViewController colorWithHexString:@"#999999"]
                            range:NSMakeRange(0, 1)];
    
    }
    [attriString addAttribute:NSForegroundColorAttributeName  //文字颜色
                        value:[WXYClassMethodsViewController colorWithHexString:@"#999999"]
                        range:NSMakeRange(1, str.length-1)];
    

    [attriString addAttribute:NSFontAttributeName             //文字字体
                               value:[UIFont systemFontOfSize:15]
                               range:NSMakeRange(0, str.length)];
    cell.textLabel.attributedText = attriString;

    //改变this的字体，value必须是一个CTFontRef
    return cell;

}

-(void)popHome{
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view endEditing:YES];

    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];

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
