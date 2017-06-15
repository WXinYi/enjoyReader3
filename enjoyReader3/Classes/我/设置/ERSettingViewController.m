//
//  SYSettingViewController.m
//  EnjoyReader2
//
//  Created by 王馨仪 on 16/7/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ERSettingViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "SettingAboutController.h"
#import "SystemSetCell.h"
#import "FeedBackViewController.h"
#import <MessageUI/MessageUI.h>
@interface ERSettingViewController ()<MFMailComposeViewControllerDelegate>
{
    UIButton *logoutBtn;
}
// 记录当前tableView的所有数组
@property (nonatomic, strong) NSMutableArray *groups;
@property(nonatomic,strong)UIAlertView * reminderAlert;//清除缓存提示框
@property (nonatomic,strong)UIAlertView *logoutAlert;//退出登录提示
//保存缓存
@property (nonatomic,strong) NSString *saveCaching;

@end

@implementation ERSettingViewController

//懒加载
- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

//设置分组样式
- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];//,moonItem
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"设置";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);

    //退出登录
    CGFloat x = kScreenWidth/2-63.5;
    CGFloat y =kScreenHeight-64-71;
    logoutBtn= [[UIButton alloc]init];
    logoutBtn.frame = CGRectMake(x, y, 127 , 33);
    [logoutBtn setTitle:@"退出登录" forState:0];
    [logoutBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    logoutBtn.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    logoutBtn.layer.masksToBounds = YES;
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.borderWidth = 0.5;
    logoutBtn.layer.borderColor = THEMECOLOR.CGColor;
    [logoutBtn addTarget:self action:@selector(logoutClict:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    logoutBtn.hidden = NO;
    
    
    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
    _saveCaching = [NSString stringWithFormat:@"%.2fMB",size];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [self.tableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [self.tableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
    }
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
   
}

-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void) viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)logoutClict:(UIButton *)sender{

    self.logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定要退出登录吗？" delegate: self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil ];
    [self.logoutAlert show];

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

}
#pragma mark - alertViewDelegate  清除缓存
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
 
    if (alertView == self.reminderAlert &&buttonIndex == 0 )
    {
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
        CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
        _saveCaching = [NSString stringWithFormat:@"%.2fMB",size];
        [self.tableView reloadData];
        
    }
    if (alertView == self.logoutAlert &&buttonIndex == 0) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        logoutBtn.hidden = YES;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 38;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
    header.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 100, 14)];
    titlelabel.font = [UIFont systemFontOfSize:14];
    titlelabel.textColor = [WXYClassMethodsViewController colorWithHexString:@"#d38d8c"];
    

    if (section == 0) {
        titlelabel.text = @"通用设置";
    }else{
    titlelabel.text = @"更多";
        
    }
    [header addSubview:titlelabel];
    return header;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return 1;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SystemSetCell * cell =  (SystemSetCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetCell" owner:self options:nil] firstObject];
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.SetTitleLable.text = @"清除缓存";
        cell.SetStateLable.text = _saveCaching;


    }else{
        NSArray *secondArray  = nil;
        
        secondArray = @[@"用户评分",@"意见反馈",@"分享应用",@"关于我们"];
        
        cell.SetTitleLable.text = secondArray[indexPath.row];
        cell.SetStateLable.text = nil;

    }
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    cell.SetStateLable.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.SetTitleLable.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == 0) {

    if ([selectedCell.textLabel.text isEqualToString:@"0.00 M"]) {
        
    }else{
        self.reminderAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定要清除缓存吗？" delegate: self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil ];
        [self.reminderAlert show];
        
    }
    }else{
        if (indexPath.row == 0) {
            //TODO: 更换appid
            NSString* str = [NSString stringWithFormat:@""];//itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1124270439
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            

        }
       else if (indexPath.row == 1){
           
          //意见反馈
           FeedBackViewController *vc = [[FeedBackViewController alloc] init];
           [self.navigationController pushViewController:vc  animated:YES];
       }
   
       else if (indexPath.row == 2){
        
        NSString *textToShare = @"瞬息指尖，趣阅人生";
        
        UIImage *imageToShare = [UIImage imageNamed:@"icon"];
        
        NSURL *urlToShare = [NSURL URLWithString:@""]; //https://itunes.apple.com/us/app/yue-lai-ke-zhan/id1124270439?l=zh&ls=1&mt=8
        
        NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                                
                                                                                applicationActivities:nil];
        
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                             
                                             UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
        
        [self presentViewController:activityVC animated:TRUE completion:nil];
        
       
       }else{
        
        SettingAboutItem *phoneItem = [SettingAboutItem itemWithTitle:@"版权投诉和举报快速通道" detail:@"" handler:^(SettingAboutItem *item) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[item.detail stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        
        SettingAboutItem *emailItem = [SettingAboutItem itemWithTitle:@"客服邮箱" detail:@"enjoyreader_support@163.com" handler:^(SettingAboutItem *item) {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (!mailClass) {
                return;
            }
            if (![mailClass canSendMail]) {
                return;
            }
            MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
            mailPicker.mailComposeDelegate = self;
            //添加收件人
            NSArray *toRecipients = [NSArray arrayWithObject:item.detail];
            [mailPicker setToRecipients: toRecipients];
            [self.navigationController presentViewController:mailPicker animated:YES completion:nil];
        }];
        
        SettingAboutItem *wechatItem = [SettingAboutItem itemWithTitle:@"官方微信" detail:@"阅来客栈 (EnjoyReader)" handler:^(SettingAboutItem *item) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"复制成功" message:@"已经将微信服务号复制到剪贴板，可以去微信里面关注哇!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [controller addAction:cancelAction];
            [self presentViewController:controller animated:YES completion:nil];
        }];
        
        NSArray *items = @[phoneItem,emailItem,wechatItem];
        
        SettingAboutController *vc = [[SettingAboutController alloc] initWithLogo:[UIImage imageNamed:@"icon"] introduce:@"＊如果您遇到问题，请直接联系我们enjoyreader_support@163.com，我们会在2个工作日内尽快回复。考虑到我们无法回复您的评论，请尽量不要在苹果商店评价区提问。非常感谢您的支持！\n" items:items];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    
    }
    
    
    }
}

@end
