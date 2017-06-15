//
//  SWRTableViewController.m
//  JianshuMyPage
//
//  Created by Weiran Shi on 2015-12-06.
//  Copyright (c) 2015 Vera Shi. All rights reserved.
//

#import "SWRTableViewController.h"
#import "SWRAvatarView.h"
#import "SWREditButton.h"
#import "UIView+Extension.h"
#import "SWRArticle.h"
#import "SWRTabButton.h"
#import "SWRTabBarView.h"
#import "ERSettingViewController.h"
#import "NewloginViewController.h"
#import "EditInfoViewController.h"
#import "FindViewController.h"
#import "ArticleContentViewController.h"
#import "MyWorksViewController.h"
#import "PersonalTableViewCell.h"
#import "AHKActionSheet.h"
#import "MyDraftViewController.h"
#import "MybooksViewController.h"
#import "MyMessageViewController.h"
@interface SWRTableViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SWRTabBarViewDelegate>
{
    CGFloat _tabBarViewInitialY;
    NSMutableArray *_allArticles;
    UIBarButtonItem *messageItem;
}

@property (nonatomic, strong) SWRAvatarView *avatarView;//头像
@property (nonatomic, strong) SWRTabBarView *tabBarView;//三个按钮
@property (weak, nonatomic) IBOutlet UIView *headerView;//整个上部分
//@property (nonatomic, strong) SWREditButton *editButton;//签到按钮
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;//昵称

@property (strong, nonatomic) IBOutlet UIView *fansView;
@property (strong, nonatomic) IBOutlet UILabel *fansLabel;
@property (strong, nonatomic) IBOutlet UILabel *fans;

@property (strong, nonatomic) IBOutlet UIView *zanView;
@property (strong, nonatomic) IBOutlet UILabel *zanLabel;
@property (strong, nonatomic) IBOutlet UILabel *zan;

@property (strong, nonatomic) IBOutlet UIView *jifenView;
@property (strong, nonatomic) IBOutlet UILabel *jifenLabel;
@property (strong, nonatomic) IBOutlet UILabel *jifen;

@property (strong, nonatomic) IBOutlet UIButton *nameBtn;//昵称后面的按钮

@end

@implementation SWRTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    if (_isFromComment) {
        UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
        self.navigationItem.leftBarButtonItems = @[settingItem];//,moonItem

        UIBarButtonItem *followItem = [UIBarButtonItem itemWithImage:@"guanzhu" hightImage:@"guanzhu" target:self action:@selector(followClick)];
        self.navigationItem.rightBarButtonItems = @[followItem];//,moonItem

    }
    [self avatarConfiguration];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.headerView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    
    self.jifenView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.jifenLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.jifen.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);

    self.fansView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.fansLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.fans.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);

    self.zanView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    self.zanLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.zan.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    self.nameLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);

    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationItem.title = nil;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:YES];
    [self addData];
    [self.tableView reloadData];
    if (!_isFromComment) {
        
        [self addtagers];
        
    }else{
        _nameBtn.hidden = YES;
    }
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"IMG_3101"] forBarMetrics:UIBarMetricsDefault ];
        [self.tableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#646464"]];
    }else{
        [self.tableView setSeparatorColor:[WXYClassMethodsViewController colorWithHexString:@"#e0e1e2"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault ];
    }
    
    
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-64-64);
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    if (_isFromComment) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 63, 0, 0);
    }else
    {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        
    }
    
    if (!ISLOGIN) {
        //TODO: 姓名之类的登录没登录有不同展示
    }else{
        
        //        _editButton.center = CGPointMake(self.view.width / 2, self.headerView.height - 100);
        _nameLabel.userInteractionEnabled = NO;
        //        [_editButton setTitle:@"马上登录" forState:0];
        
        _nameLabel.text = @"请登录";
    }
    
}


-(void)followClick{
//关注按钮

}
-(void)CommentBack{
    _avatarView.hidden = YES;

    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];

    _avatarView.hidden = NO;

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!_isFromComment) {
        if (section == 0) {
            return 4;
        }
        return 1;
    }else{
    //他人个人页面
        
        return 4;
    
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isFromComment && section == 1) {
        return 0.1f;
    }else
        return 10;
        
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    UIView *view = [[UIView alloc] init];
    view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    view.frame = CGRectMake(0, 0, kScreenWidth, 10);
    return view;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isFromComment) {
        if (indexPath.section == 0) {
            NSArray *iconarray = [NSArray arrayWithObjects:@"icon_zuopin_",@"icon_caogao_",@"icon_shujia_",@"icon_xiaoxi_", nil];
            NSArray *titleArray = [NSArray arrayWithObjects:@"我的作品",@"我的草稿",@"我的书架",@"我的消息", nil];
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 20, 20)];
            iconImage.image = [UIImage imageNamed:iconarray[indexPath.row]];
            [cell.contentView addSubview:iconImage];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 18, 100, 15)];
            titleLabel.text = titleArray[indexPath.row];
            titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
            titleLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:titleLabel];
            
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-26, 18, 11, 11)];
            arrow.image = [UIImage imageNamed:@"jump"];
            [cell.contentView addSubview:arrow];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 20, 20)];
        iconImage.image = [UIImage imageNamed:@"icon_shezhi_"];
        [cell.contentView addSubview:iconImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 18, 100, 15)];
        titleLabel.text = @"设置";
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
        titleLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-26, 18, 11, 11)];
        arrow.image = [UIImage imageNamed:@"jump"];
        [cell.contentView addSubview:arrow];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }else
        //他人个人页面
        
        if (indexPath.row == 0) {
            NSArray *titleArray = [NSArray arrayWithObjects:@"连载作品",@"已发表文章", nil];
            NSArray *iconarray = [NSArray arrayWithObjects:@"icon_2lianzaizuopin40-40",@"icon_2wenzhang40-40",nil];
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 20, 20)];
            iconImage.image = [UIImage imageNamed:iconarray[indexPath.section]];
            [cell.contentView addSubview:iconImage];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 18, 100, 16)];
            titleLabel.text = titleArray[indexPath.section];
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
            [cell.contentView addSubview:titleLabel];
            
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            line1.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
            
            [cell.contentView addSubview:line1];
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kScreenWidth, 0.5)];
            line2.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
            
            [cell.contentView addSubview:line2];
            cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            PersonalTableViewCell *cell = [[PersonalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.writeBtn.hidden = YES;
            cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
            cell.personalTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
            cell.personalInfo.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
            return cell;
            
            
        
        
        
        }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isFromComment) {
        return 50;
    }else
        if (indexPath.row == 0) {
            return 50;
        }else
            return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_isFromComment) {
        
    }else{
    //我的
        if (indexPath.section == 0) {
            
            switch (indexPath.row) {
                case 0:{
                    //我的作品
                    MyWorksViewController *vc = [[MyWorksViewController alloc] init];
                    _avatarView.hidden = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case 1:{
                //我的草稿
                
                    MyDraftViewController *vc = [[MyDraftViewController alloc] init];
                    _avatarView.hidden = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case 2:{
                    
                    MybooksViewController *vc = [[MybooksViewController alloc] init];
                    _avatarView.hidden = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                default:{
                    MyMessageViewController *vc = [[MyMessageViewController alloc] init];
                    _avatarView.hidden = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
            }
            
            
            
            
        }else{
        
            ERSettingViewController *setting = [[ERSettingViewController alloc] init];
            _avatarView.hidden = YES;
            [self.navigationController pushViewController:setting animated:YES];
        }

    }

}





-(void)addtagers{

    
    UITapGestureRecognizer * nametap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editname:)];
    _nameLabel.userInteractionEnabled = YES;
    [_nameLabel addGestureRecognizer:nametap];
    _nameBtn.userInteractionEnabled = YES;
    [_nameBtn addGestureRecognizer:nametap];

}

-(void)editname:(id)sender{

    EditInfoViewController *vc = [[EditInfoViewController alloc]init];
    vc.titleStr = @"修改昵称";
    vc.textfilestr = _nameLabel.text;
    
    _avatarView.hidden = YES;

    [self.navigationController pushViewController:vc animated:YES];

}

//设置按钮事件处理
- (void)messageItemClick
{
    
    if (ISLOGIN) {
        
        FindViewController *setting = [[FindViewController alloc] init];
        _avatarView.hidden = YES;
        [self.navigationController pushViewController:setting animated:YES];
    }else{
        [self login];
    }
   
    
}


- (void)addCustomTabBar
{
    CGFloat tabBarViewH = 50;
    
    _headerView.height = _headerView.height+tabBarViewH;
    SWRTabBarView *tabBarView = [[SWRTabBarView alloc] initWithFrame:CGRectMake(0, self.headerView.height -tabBarViewH, self.view.width, tabBarViewH)];
    _tabBarView.backgroundColor = [UIColor whiteColor];
    NSArray *buttonArr = @[@"我的作品"];

    if (_isFromComment) {
        buttonArr = @[@"他的作品"];

    }
    
    tabBarView.buttonArr = buttonArr;
    
    [self.headerView addSubview:tabBarView];
    _tabBarView = tabBarView;
    _tabBarViewInitialY = tabBarView.y;
    tabBarView.delegate = self;
}
- (void)menuHeaderButtonClicked:(UIButton *)button{
   
    if (button.tag==1000) {
    //我的投稿
        
    }else if (button.tag == 1001){
    //我的回复
    
    }else{
    //我的赞
        
        
        
    }
    
    
    
}
- (void)addData
{
    //表单内容
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"articles" ofType:@"plist"]];
    _allArticles = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array){
        SWRArticle *article = [[SWRArticle alloc] initWithDict: dict];
        [_allArticles addObject:article];
    }
}


-(void)login{

    
    NewloginViewController * loginViewController = nil;
    if (iPhone4) {
        loginViewController = [[NewloginViewController alloc]initWithNibName:@"NewloginViewController4" bundle:[NSBundle mainBundle]];
        
    }else if (iPhone5){
        loginViewController = [[NewloginViewController alloc]initWithNibName:@"NewloginViewController5" bundle:[NSBundle mainBundle]];
        
    }else if (iPhone6){
        loginViewController = [[NewloginViewController alloc]initWithNibName:@"NewloginViewController6" bundle:[NSBundle mainBundle]];
    }else{
        loginViewController = [[NewloginViewController alloc]initWithNibName:@"NewloginViewController6+" bundle:[NSBundle mainBundle]];
    }
    
    [self presentViewController:loginViewController animated:YES completion:nil];
    

}

- (void)avatarConfiguration
{
    CGFloat avatarRadiusMin = 16;
    CGFloat avatarHW = 81;
    CGFloat avatarX = self.view.center.x - avatarHW / 2;
    CGFloat avatarY = 44 - avatarHW / 2;
    
    SWRAvatarView *avatarView = [[SWRAvatarView alloc] initWithAvatar:@"luyou.jpg" minRadius:avatarRadiusMin frame:CGRectMake(avatarX, avatarY, avatarHW, avatarHW)];
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changAvatar)];
    [avatarView addGestureRecognizer:avatarTap];
    [self.navigationController.navigationBar addSubview:avatarView];
    _avatarView = avatarView;


}



-(void)changAvatar{

    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:@"您要更换头像？"];
    
    actionSheet.blurTintColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    actionSheet.blurRadius = 8.0f;
    actionSheet.buttonHeight = 50.0f;
    actionSheet.cancelButtonHeight = 50.0f;
    actionSheet.animationDuration = 0.5f;
    actionSheet.cancelButtonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    actionSheet.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    actionSheet.selectedBackgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    UIFont *defaultFont = [UIFont fontWithName:@"Avenir" size:17.0f];
    actionSheet.buttonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                          NSForegroundColorAttributeName : [UIColor whiteColor] };
    actionSheet.disabledButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                  NSForegroundColorAttributeName : [UIColor grayColor] };
    actionSheet.destructiveButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                     NSForegroundColorAttributeName : [UIColor redColor] };
    actionSheet.cancelButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                NSForegroundColorAttributeName : [UIColor whiteColor] };
    [actionSheet addButtonWithTitle:@"我要更换头像"
                              image:[UIImage imageNamed:@"提示"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                //创建图片选择器
                                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                //设置代理
                                imagePicker.delegate = self;
                                //设置图片选择属性
                                imagePicker.allowsEditing = YES;
                                
                                [self presentViewController:imagePicker animated:YES completion:nil];
                                self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                            }];
    
    
    
    [actionSheet show];




}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取图片
    UIImage *infoImage = info[UIImagePickerControllerEditedImage];

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning{
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_avatarView scaleWhenScroll:scrollView];
    [_tabBarView shiftWhenScroll:scrollView headerViewHeight:self.headerView.height initialPositionY:_tabBarViewInitialY];
    CGFloat sectionHeaderHeight = 40;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0,0,0);
        
    } else if(scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight,0,0,0);
        
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}
@end
