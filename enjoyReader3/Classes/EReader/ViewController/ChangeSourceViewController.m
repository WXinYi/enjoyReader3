//
//  ChangeSourceViewController.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/13.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ChangeSourceViewController.h"
#import "ChangeSourceTableViewCell.h"
#import "BookSource.h"
#import "Chapter.h"
#import "BookInfo.h"
#import "ReaderScrollViewController.h"
#import "ArticleContentViewController.h"
//#import "UMMobClick/MobClick.h"

@interface ChangeSourceViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    UITableView *sourceTable;
    NSArray *sourceArr;//获取所有源
}
@end

@implementation ChangeSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
    
    NSString *cpContent = [NSMutableString stringWithContentsOfFile:[[BookSource shareInstance] getSourceInfoPath] encoding:NSUTF8StringEncoding error:NULL];//内容
    
    cpContent = [WXYClassMethodsViewController decode:cpContent];
    
    sourceArr = [WXYClassMethodsViewController stringToJSON:cpContent];
    
    
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)loadUI{


    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
//    navView.backgroundColor =THEMECOLOR;
    navView.backgroundColor = [UIColor blackColor];
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 37)];
    titleLable.text= @"选择来源";
    titleLable.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
    titleLable.textColor = [UIColor whiteColor];
    
//                                                   text:@"选择来源" font: [UIFont fontWithName:@"Arial-BoldItalicMT" size:20] textColor:[UIColor whiteColor] backgroundColor:nil numberOfLines:1 lineSpacing:0];
    titleLable.textAlignment = 1 ;
    
    [navView addSubview:titleLable];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 20, 20)];
    
    [backButton setImage:[UIImage imageNamed:@"public_back"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:backButton];
    
    [self.view addSubview:navView];
    
     sourceTable= [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-60) style:UITableViewStylePlain];
    sourceTable.tableFooterView = [[UIView alloc]init];
    sourceTable.delegate = self;
    sourceTable.dataSource = self;
    
    [self.view addSubview:sourceTable];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return sourceArr.count;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = COLOR(241, 241, 241, 1.0);
    UILabel *headerLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth, 10)];
    headerLable.text = @"搜索到以下来源：";
    headerLable.textColor = [UIColor grayColor];
    headerLable.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:13];
    
    //加一条分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29.5, kScreenWidth, 0.5)];
    
    lineView.backgroundColor = [UIColor grayColor];
    
    [headerView addSubview:lineView];
    
    [headerView addSubview:headerLable];
    return headerView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChangeSourceTableViewCell  * cell =  (ChangeSourceTableViewCell* )[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChangeSourceTableViewCell" owner:self options:nil] firstObject];
        
    }
    
    cell.SourceName.text = [NSString stringWithFormat:@"%@",[sourceArr[indexPath.row] objectForKey:@"name"]];
    
    NSString *updated = [sourceArr[indexPath.row] objectForKey:@"updated"];
    
    updated = [updated substringToIndex:10];
    
    cell.updated.text = [NSString stringWithFormat:@"更新时间：%@",updated];
    
    cell.last_chapter.text = [NSString stringWithFormat:@"最新章节：%@",[sourceArr[indexPath.row] objectForKey:@"last_chapter"]];
    
    if (sourceArr.count ==1||[[sourceArr[indexPath.row] objectForKey:@"id"] isEqualToString:[[BookSource shareInstance] getSourceID]]) {
        cell.nowSource.hidden = NO;
    }else{
        cell.nowSource.hidden =YES;
    }
    cell.nowSource.text = @"当前选择";
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 73;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //选择的源的id
    NSString *catalog_id = [NSString stringWithFormat:@"%@",[sourceArr[indexPath.row] objectForKey:@"id"]];
    
    NSString *catalog_title = [NSString stringWithFormat:@"%@",[sourceArr[indexPath.row] objectForKey:@"name"]];

    NSString *PlatformUrl = [NSString stringWithFormat:@"%@%@",KBASSUrl,Kbook];
    
    NSDictionary *params = @{@"request_type":@"3",@"catalog_id":catalog_id};
    
    [XYNetworking POST:PlatformUrl params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *ret = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ret"]];
        if ([ret isEqualToString:@"0"]) {
            
            
            //创建目录信息文件
            NSString *tr= [NSString stringWithFormat:@"%@/%@",[[BookInfo siged] getBookPath],catalog_id];
            
            NSMutableArray * chapterArr = [[NSMutableArray alloc]init];
            
            [chapterArr addObjectsFromArray:[[[responseObject objectForKey:@"data"] objectForKey:@"catalog"] objectForKey:@"chapters"]];
            
            for (int i = 0; i < chapterArr.count; i ++) {
                
                if (![[chapterArr[i] objectForKey:@"unreadble"]isEqualToString:@"False"]) {
                    [chapterArr removeObjectAtIndex:i];
                }
            }
            
//            NSString *contents = [NSString stringWithFormat:@"%@",chapterArr];
            
            
            [FileOperation createFileNamed:catalog_id inDirectory:[[BookInfo siged] getBookPath]];
            
            [FileOperation createFileNamed:@"chaptersInfo.txt" inDirectory:tr andContentArray:chapterArr];

            

            ReaderScrollViewController *loginvctrl = [[ReaderScrollViewController alloc] init];
            loginvctrl.isFromHome = YES;
           
            //存  源id
            [[BookSource shareInstance] SourceID:catalog_id];

            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        [HUDView showMsg:@"网络错误，请稍后尝试" inView:self.view];
        
    }];
    
}

-(void)leftButtonClick{

    [self dismissViewControllerAnimated:YES completion:nil];

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
