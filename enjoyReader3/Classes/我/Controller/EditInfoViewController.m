//
//  editInfoViewController.m
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/27.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "EditInfoViewController.h"
#import "editInfoCell.h"


@interface EditInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"修改昵称";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self.view addSubview:line];
    
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIBarButtonItem* messageItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    messageItem.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = messageItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"IMG_3101"] forBarMetrics:UIBarMetricsDefault ];
        [self.tableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [self.tableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault ];
    }
}
-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)done{

    if ([self.titleStr isEqualToString:@"修改签名"]) {
        
    }else{
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    editInfoCell *cell = (editInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
      cell = [[[NSBundle mainBundle] loadNibNamed:@"editInfoCell" owner:self options:nil] firstObject];
    if ([self.title isEqualToString:@"修改签名"]) {
       
        cell.edieTextFile.placeholder = @"请输入您的签名";
        

    }else{
        cell.edieTextFile.placeholder = @"请输入您的昵称";

    
    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    if (_textfilestr.length>0) {
        cell.edieTextFile.text = _textfilestr;
    }
    [cell.edieTextFile becomeFirstResponder];
    return cell;
}



@end
