//
//  SettingAboutController.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/15.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "SettingAboutController.h"
#import "SettingHeaderCell.h"
#import "SettingAboutController.h"
#import <MessageUI/MessageUI.h>
static NSString *kaboutCellIdentifier = @"kaboutCellIdentifier";

@interface SettingAboutController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIImage *logo;
@property (strong, nonatomic) NSString *introduce;
@property (strong, nonatomic) NSArray  *items;

@end

@implementation SettingAboutController

+ (instancetype)viewControllerWithLogo:(UIImage *)logo
                             introduce:(NSString *)introduce
                                 items:(NSArray<SettingAboutItem *> *)items{
    return [[self alloc] initWithLogo:logo
                            introduce:introduce
                                items:items];
}

- (instancetype)initWithLogo:(UIImage *)logo
                   introduce:(NSString *)introduce
                       items:(nonnull NSArray<SettingAboutItem *> *)items{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.logo      = logo;
        self.introduce = introduce;
        self.items     = items;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
//    //左按钮--返回
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:nil hightImage:nil target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"关于我们";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self setupUI];
    
}
-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}

- (void)setupUI{
    self.tableView.tableFooterView    = [[UIView alloc] init];
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:[SettingHeaderCell class] forCellReuseIdentifier:[SettingHeaderCell cellIdentifier]];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [self.tableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [self.tableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.items.count > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section == 0?1:self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SettingHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:[SettingHeaderCell cellIdentifier]];
        if (!cell) {
            cell = [[SettingHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SettingHeaderCell cellIdentifier]];
        }
        [cell configWithLogo:self.logo introduce:self.introduce];
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);

        return cell;
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kaboutCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kaboutCellIdentifier];
    }
    SettingAboutItem *item         = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text       = item.title;
    cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    cell.textLabel.font       = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    cell.detailTextLabel.text = item.detail;
    cell.detailTextLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    cell.accessoryType        = item.handler ? UITableViewCellAccessoryNone : UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
    
}

-(void)backClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row == 0) {
            
            NSString *urlText = [NSString stringWithFormat:@"http://www.enjoyreader.cn/complaint.html"];
                                 
            [[ UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
            
        }
        if (indexPath.row == 1) {
            
            NSMutableString *mailUrl = [[NSMutableString alloc]init];
            //添加收件人
            NSArray *toRecipients = [NSArray arrayWithObject: @"enjoyreader_support@163.com"];
            [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
            //添加抄送
            NSArray *ccRecipients = [[NSArray alloc]init];
            [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
            //添加密送
            NSArray *bccRecipients = [[NSArray alloc]init];
            [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
            //添加主题
            [mailUrl appendString:@" "];
            //添加邮件内容
            [mailUrl appendString:@""];
            NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
        }
        else{
            
         
        }



}
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
