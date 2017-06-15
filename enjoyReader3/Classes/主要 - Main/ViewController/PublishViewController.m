//
//  PublishViewController.m
//  enjoyReader3
//
//  Created by WangXy on 16/9/18.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "PublishViewController.h"
#import "TabbarTableViewCell.h"
#import "MyFMDB.h"
#import "draftSingle.h"
#import "WPViewController.h"
#import "HWPopTool.h"
#import "serializeView.h"
@interface PublishViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic,strong ) UITableView *chooseTableView;
@property (nonatomic,strong ) UIView *popView;
@property (nonatomic,strong ) NSArray *infoArray;
@property (nonatomic,strong ) UIView *contentView;
@property (nonatomic,strong ) serializeView *serialize;
@property (nonatomic,strong ) UIButton *havenBtn;
@property (nonatomic,strong ) UIButton *createBtn;
@property (nonatomic,assign ) BOOL open;//记录草稿是否展开

@end

@implementation PublishViewController
{
    NSData * fileData;
    UIButton *cancelBtn;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    [_chooseTableView removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    _open = NO;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 336, 420)];
    _contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [_contentView.layer setMasksToBounds:YES];
    [_contentView.layer setCornerRadius:8.0];
    
    //获取当前多少草稿
    _infoArray = [[MyFMDB instance] getAllBrandwithTestType:draftlist];
    
    //创建弹出视图  在屏幕外
    
    switch (_infoArray.count) {
        case 0:{
            _popView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenHeight, kScreenWidth-20, 237)];
            
            _chooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 173)];
            
            [_popView addSubview:_chooseTableView];
        }
            break;
        case 1:{
            
            _popView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenHeight, kScreenWidth-20, 332)];
            
            _chooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 270)];
            [_popView addSubview:_chooseTableView];
            
        }
            break;
        case 2:{
            
            _popView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenHeight, kScreenWidth-20, 382)];
            
            _chooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 320)];
            [_popView addSubview:_chooseTableView];
            
        }
            break;
            
        default:{
            
            _popView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenHeight, kScreenWidth-20, 432)];
            
            _chooseTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 370)];
            [_popView addSubview:_chooseTableView];
        }
            break;
    }

    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,kScreenHeight , kScreenWidth-20, 44)];
    cancelBtn.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 6.0;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn dk_setTitleColorPicker:DKColorPickerWithKey(TXTONE) forState:UIControlStateNormal];

    [self.view addSubview:cancelBtn];
    _chooseTableView.tableFooterView = [[UIView alloc] init];
    
    _chooseTableView.delegate = self;
    _chooseTableView.dataSource = self;
    _chooseTableView.separatorStyle = NO;
    _chooseTableView.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _popView.layer.masksToBounds = YES;
    _popView.layer.cornerRadius = 6.0;
    [self.view addSubview:_popView];

    [self movetoscreen];

}
//动画
-(void)movetoscreen{
    
    __block typeof(self) bself = self;
    
    [UIView animateWithDuration:0.35 animations:^{
        
        switch (bself.infoArray.count) {
            case 0:
                
                bself.popView.frame = CGRectMake(10, kScreenHeight-237, kScreenWidth-20, 237);
                _chooseTableView.frame = CGRectMake(0, 0, kScreenWidth-20, 173);
                break;
            case 1:
                
                bself.popView.frame = CGRectMake(10, kScreenHeight-332, kScreenWidth-20, 332);
                _chooseTableView.frame = CGRectMake(0, 0, kScreenWidth-20, 270);

                break;
            case 2:{
                
                bself.popView.frame = CGRectMake(10, kScreenHeight-382, kScreenWidth-20, 382);
                _chooseTableView.frame = CGRectMake(0, 0, kScreenWidth-20, 320);

            }
                break;
            default:{
                
                bself.popView.frame =CGRectMake(10, kScreenHeight-432, kScreenWidth-20, 432);
                _chooseTableView.frame = CGRectMake(0, 0, kScreenWidth-20, 370);

            }
                break;
        }
        cancelBtn.frame = CGRectMake(10,kScreenHeight-55 , kScreenWidth-20, 44);

          } completion:nil];
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _chooseTableView) {
        if (_infoArray.count>0) {
            
            return 2;
            
        }
        
        return 1;
        
    }
    
    return 1;
    
}
#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView == _chooseTableView) {
        if (section == 0) {
            return 3;
        }else{
            
            switch (_infoArray.count) {
                case 0:{
                    
                    return 0;
                    
                }
                    
                    break;
                    
                default:{
                    
                    return _infoArray.count+1;
                    
                }
                    
                    break;
            }
            
        }
    }else
        
        return 5;//todo:
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _chooseTableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {

                return 73;
                
            }else{
                
                return 50;
                
            }
        }else{
            if (indexPath.row == 0) {
                
                return 45;
                
            }else{
                
                return 50;
                
            }
            
        }

    }
    
    return 52;
        
    

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _chooseTableView) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20 , 73)];
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(32, 20, kScreenWidth-20, 18)];
                    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(56, 53, kScreenWidth-20, 12)];
                    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(34, 53, 14, 14)];
                    icon.image = [UIImage imageNamed:@"icon_tanhao"];
                    
                    label1.text = @"选择您要创作的类型";
                    label1.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
                    label2.text = @"请勿发布色情、政治等违反国家法律的内容";
                    label2.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);

                    label1.font = [UIFont fontWithName:@"Avenir" size:18.0f];
                    label2.font = [UIFont fontWithName:@"Avenir" size:12.0f];
                    label1.backgroundColor = [UIColor clearColor];
                    label2.backgroundColor = [UIColor clearColor];
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 72.5, kScreenWidth-20, 0.5)];
                    line.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
                    [headerView addSubview:line];
                    [headerView addSubview:icon];
                    [headerView addSubview:label1];
                    [headerView addSubview:label2];
                    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
                    
                    [cell.contentView addSubview:headerView];
                    
                    return cell;
                    
                }
                    break;
                case 1:{
                    TabbarTableViewCell  * cell =  (TabbarTableViewCell* )[tableView dequeueReusableCellWithIdentifier:@"Cell"];
                    
                    if (cell == nil) {
                        
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"TabbarTableViewCell" owner:self options:nil] firstObject];
                        
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.chooseIcon.image = [UIImage imageNamed:@"icon_wenzhang"];
                    cell.chooseLine.hidden = NO;
                    cell.chooseLine.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
                    cell.chooseTitle.text  = @"我要写文章";
                    cell.chooseTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
                    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
                    return cell;
                    
                }
                    break;
                case 2:{
                    TabbarTableViewCell  * cell =  (TabbarTableViewCell* )[tableView dequeueReusableCellWithIdentifier:@"Cell"];
                    
                    if (cell == nil) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"TabbarTableViewCell" owner:self options:nil] firstObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.chooseIcon.image = [UIImage imageNamed:@"icon_lianzai"];
                    cell.chooseLine.hidden = YES;
                    cell.chooseLine.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
                    cell.chooseTitle.text  = @"我要写连载";
                    cell.chooseTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
                    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);

                    return cell;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
        else{
            if (indexPath.row == 0) {
                
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *chooselabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 16, kScreenWidth-20, 17)];
                chooselabel.text = @"选择继续编辑草稿";
                chooselabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, kScreenWidth-20, 0.5)];
                lineView.dk_backgroundColorPicker =DKColorPickerWithKey(BG);
                UIView *uplineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 2)];
                uplineView.dk_backgroundColorPicker =DKColorPickerWithKey(BG);
                [cell.contentView addSubview:lineView];
                [cell.contentView addSubview:uplineView];
                [cell.contentView addSubview:chooselabel];
                cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
                return cell;
                
            }else{
                TabbarTableViewCell  * cell =  (TabbarTableViewCell* )[tableView dequeueReusableCellWithIdentifier:@"Cell"];
                
                if (cell == nil) {
                    
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TabbarTableViewCell" owner:self options:nil] firstObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.chooseIcon.image = [UIImage imageNamed:@"icon_coagao"];
                cell.chooseLine.hidden = NO;
                cell.chooseLine.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
                cell.chooseTitle.text  = [_infoArray[indexPath.row-1] objectForKey:@"title"];
                cell.chooseTitle.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
                cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
                return cell;
                
            }
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    UILabel *chooselabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-20, 14)];
    chooselabel.text = @"连载标题";
    chooselabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    self.createBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [cell.contentView addSubview:chooselabel];
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _chooseTableView) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    return ;
                    break;
                    
                case 1:{
                    WPViewController *publish = [[WPViewController alloc]init];
                    [self presentViewController:publish animated:YES completion:nil];
                }
                    break;
                case 2:{
                    //连载
                    [self creatserialize];
                }
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:{
                    
                    if (_infoArray.count>3 ) {
                        if (_open ==NO) {
                            __block typeof(self) bself = self;
                            _open =YES;
                            [UIView animateWithDuration:0.35 animations:^{
                                
                                bself.popView.frame = CGRectMake(10, kScreenHeight-552, kScreenWidth-20, 552);
                                bself.chooseTableView.frame =CGRectMake(0, 0, kScreenWidth-20, 490);
                                
                            } completion:nil];
                        }else{
                            _open = NO;
                            [self movetoscreen];
                            
                        }
                        
                    }
                    
                }
                    break;
                    
                default:{
                    WPViewController *publish = [[WPViewController alloc]init];
                    NSString *content = [NSString stringWithFormat:@"%@",[[draftSingle shareInstance] getDraftContentwithmd5str:[_infoArray[indexPath.row-1] objectForKey:@"md5string"]]];
                    publish.contentText = content;
                    publish.createString =[_infoArray[indexPath.row-1] objectForKey:@"createtime"];
                    publish.md5Str =[_infoArray[indexPath.row-1] objectForKey:@"md5string"];
                    publish.nameText = [_infoArray[indexPath.row-1] objectForKey:@"title"];
                    [self presentViewController:publish animated:YES completion:nil];
                }
                    break;
                    
            }
        }

    }
   
}
#pragma mark -
#pragma mark 创建连载弹出窗口
-(void)creatserialize{

    self.createBtn = [[UIButton alloc] initWithFrame:CGRectMake(48, 37, 104, 32)];
    [self.createBtn setTitle:@"创建连载作品" forState:UIControlStateNormal];
    [self.createBtn setBackgroundColor:THEMECOLOR];
    
    self.createBtn.titleLabel.font =[UIFont systemFontOfSize:13];
    [self.createBtn.layer setMasksToBounds:YES];
    [self.createBtn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.createBtn.layer setBorderWidth:1.0];//边框宽度
    [self.createBtn.layer setBorderColor:(THEMECOLOR).CGColor];
    [self.createBtn addTarget:self action:@selector(creatBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    self.havenBtn = [[UIButton alloc] initWithFrame:CGRectMake(186, 37, 104, 32)];
    [self.havenBtn setTitle:@"连载已有作品" forState:UIControlStateNormal];
    [self.havenBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    self.havenBtn.titleLabel.font =[UIFont systemFontOfSize:13];
    [self.havenBtn setBackgroundColor:[UIColor whiteColor]];
    
    [self.havenBtn.layer setMasksToBounds:YES];
    [self.havenBtn.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [self.havenBtn.layer setBorderWidth:1.0];//边框宽度
    [self.havenBtn.layer setBorderColor:(THEMECOLOR).CGColor];
    [self.havenBtn addTarget:self action:@selector(havenBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    //关闭button
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 10, 22, 22)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeBtn];
    
    _serialize = [[[NSBundle mainBundle] loadNibNamed:@"serializeView" owner:self options:nil] firstObject];
    _serialize.frame = CGRectMake(0, 84, 336, 336);
    _serialize.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _serialize.serializeScroll.pagingEnabled = YES;
    _serialize.serializeScroll.delegate = self;
    _serialize.serializeScroll.showsVerticalScrollIndicator = FALSE;
    _serialize.serializeScroll.showsHorizontalScrollIndicator = FALSE;
    [_serialize.introduceTextView.layer setMasksToBounds:YES];
    [_serialize.introduceTextView.layer setCornerRadius:5.0];//设置矩形四个圆角半径
    [_serialize.introduceTextView.layer setBorderWidth:1.0];//边框宽度
    [_serialize.introduceTextView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    _serialize.introduceTextView.dk_backgroundColorPicker =DKColorPickerWithKey(BG);
    _serialize.introduceTextView.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    _serialize.introduceTextView.delegate = self;
    [_contentView addSubview:_serialize];
    
    [_contentView addSubview:self.havenBtn];
    [_contentView addSubview:self.createBtn];
    
    _serialize.havenTableView.delegate = self;
    _serialize.havenTableView.dataSource = self;
    _serialize.havenTableView.dk_backgroundColorPicker =DKColorPickerWithKey(BBG);
    _serialize.havenTableView.tableFooterView = [[UIView alloc] init];
    //键盘相关
    _serialize.view1.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _serialize.view2.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    _serialize.line1.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _serialize.line2.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _serialize.coverLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    _serialize.nameLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    _serialize.introduceLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    _serialize.coverImage.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _serialize.worksNameField.dk_backgroundColorPicker =DKColorPickerWithKey(BG);
    _serialize.worksNameField.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到view上
    [_serialize addGestureRecognizer:tapGestureRecognizer];
    
    //封面
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage:)];
    [_serialize.coverImage addGestureRecognizer:tap];
    _serialize.coverImage.userInteractionEnabled = YES;

    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];

}
#pragma mark - 
#pragma mark 上传封面相关  及相关代理方法

-(void)uploadImage:(UITapGestureRecognizer*)tap{

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:NULL];
    

}
#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
        //	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    //	NSLog(@"保存头像！");
    //	[userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    	UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(45.0f, 60.0f)];//将图片尺寸改为80*80
//    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(45, 60)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    _serialize.coverImage.image = selfPhoto;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


-(void)closeBtnClick{

    [[HWPopTool sharedInstance] closeWithBlcok:nil];

}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_serialize.introduceTextView endEditing:YES];
    [_serialize.worksNameField endEditing:YES];
}
-(void)creatBtnClick:(UIButton*)button{
    
    [_serialize.introduceTextView endEditing:YES];
    [_serialize.worksNameField endEditing:YES];
    [self.havenBtn setBackgroundColor: [UIColor whiteColor]];
    [self.havenBtn setTitleColor:THEMECOLOR forState:0];
    [self.createBtn setBackgroundColor:THEMECOLOR];
    [self.createBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_serialize.serializeScroll setContentOffset:CGPointMake(0,0) animated:YES];
    
}
-(void)havenBtnClick:(UIButton*)button{
    
    [_serialize.introduceTextView endEditing:YES];
    [_serialize.worksNameField endEditing:YES];
    [_serialize.serializeScroll setContentOffset:CGPointMake(336,0) animated:YES];
    [self.createBtn setBackgroundColor: [UIColor whiteColor]];
    [self.createBtn setTitleColor:THEMECOLOR forState:0];

    [self.havenBtn setBackgroundColor:THEMECOLOR];
    [self.havenBtn setTitleColor:[UIColor whiteColor] forState:0];

}

#pragma mark - 
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    if (scrollView == _serialize.serializeScroll) {
        if (targetContentOffset->x >= 336) {
            [self havenBtnClick:_havenBtn];
        }else{
            [self creatBtnClick:_createBtn];
        }
    }

}

#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length>144) {
        [HUDView showMsg:@"最多只能输入144个字" inView:textView];
    }

}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.35 animations:^{
        
        _contentView.transform = CGAffineTransformMakeTranslation(0, -94);

    } completion:nil];
}
- (void)textViewDidEndEditing:(UITextView *)textView{

    [UIView animateWithDuration:0.35 animations:^{
        
        _contentView.transform = CGAffineTransformMakeTranslation(0, 0);
        
    } completion:nil];

}

-(void)cancelClick{
    
    __block typeof(self) bself = self;
    
    [UIView animateWithDuration:0.35 animations:^{
        switch (bself.infoArray.count) {
            case 0:
                
                bself.popView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 237);
                
                break;
            case 1:
                
                bself.popView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 332);
                
                break;
            case 2:{
                
                bself.popView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 382);
                
            }
                break;
                
            default:{
                
                bself.popView.frame =CGRectMake(10, kScreenHeight, kScreenWidth-20, 432);
                
            }
                break;
        }
        cancelBtn.frame = CGRectMake(10,kScreenHeight , kScreenWidth-20, 44);

    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil];

    }];

}
-(void)hideTableview{

    __block typeof(self) bself = self;
    
    [UIView animateWithDuration:0.35 animations:^{
        
        switch (bself.infoArray.count) {
                
            case 0:
                
                bself.popView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 237);
                
                break;
            case 1:
                
                bself.popView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 332);
                
                break;
            case 2:{
                
                bself.popView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, 382);
                
            }
                break;
            default:{
                
                bself.popView.frame =CGRectMake(10, kScreenHeight, kScreenWidth-20, 432);
                
            }
                break;
        }
        
    } completion:^(BOOL finished) {
        
        
    }];


}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        
        return NO;
        
    }
    
    return YES;
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
