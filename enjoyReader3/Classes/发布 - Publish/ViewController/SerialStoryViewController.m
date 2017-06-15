//
//  SerialStoryViewController.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/11.
//  Copyright © 2016年 王馨仪. All rights reserved.
//编辑连载信息控制器


#import "SerialStoryViewController.h"
#import "WPViewController.h"
#import "AHKActionSheet.h"
@interface SerialStoryViewController ()<UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *introTextView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UIButton *havenBtn;
@property (strong, nonatomic) IBOutlet UIButton *createBtn;

@end

@implementation SerialStoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [_createBtn addTarget:self action:@selector(pushToWP) forControlEvents:UIControlEventTouchUpInside];
    NSArray *array = [[NSArray alloc]init];
     array = self.navigationController.viewControllers; //array 里存放的就是所有进栈的view，退到哪一个，直接指定索引就可以了，要堆栈顺序指引
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(banckBtnClick:) name:@"backFromWP" object:nil];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changAvatar)];
    
    _coverImageView.userInteractionEnabled = YES;
    
    [_coverImageView addGestureRecognizer:avatarTap];

}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)changAvatar{
    
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:@"请选择上传方式"];
    
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
    [actionSheet addButtonWithTitle:@"我要使用相册"
                              image:[UIImage imageNamed:@"提示"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                //创建图片选择器
                                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                //设置代理
                                imagePicker.delegate = self;
                                //设置图片选择属性
                                imagePicker.allowsEditing = YES;
                                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                
                                [self presentViewController:imagePicker animated:YES completion:nil];
                                self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                            }];
    
    
    [actionSheet addButtonWithTitle:@"我要使用相机"
                              image:[UIImage imageNamed:@"提示"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                //创建图片选择器
                                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                //设置代理
                                imagePicker.delegate = self;
                                //设置图片选择属性
                                imagePicker.allowsEditing = YES;
                                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){//真机打开
                                    
                                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                    
                                }else{// 模拟器打开
                                    
                                    NSLog(@"模拟器打开");
                                    
                                    return;
                                    
                                }
                                
                                [self presentViewController:imagePicker animated:YES completion:nil];
                                self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                            }];
    
    [actionSheet show];

    
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *infoImage = info[UIImagePickerControllerEditedImage];
    self.coverImageView.image = infoImage;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)pushToWP{
    
    WPViewController *publish = [[WPViewController alloc]init];
    [self presentViewController:publish animated:YES completion:nil];

    

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (IBAction)havenBtnClick:(id)sender {
    
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:@"选择一本您要继续连载的小说"];
    
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
    
    
    [actionSheet addButtonWithTitle:@"小说1"
                              image:[UIImage imageNamed:@"忘备录-笔记"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                WPViewController *publish = [[WPViewController alloc]init];
                                [self presentViewController:publish animated:YES completion:nil];
                            }];
    
    [actionSheet addButtonWithTitle:@"小说2"
                              image:[UIImage imageNamed:@"忘备录-笔记"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                WPViewController *publish = [[WPViewController alloc]init];
                                [self presentViewController:publish animated:YES completion:nil];
                            }];
    [actionSheet addButtonWithTitle:@"小说3"
                              image:[UIImage imageNamed:@"忘备录-笔记"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                WPViewController *publish = [[WPViewController alloc]init];
                                [self presentViewController:publish animated:YES completion:nil];
                            }];
        
    [actionSheet show];

    
}

- (IBAction)banckBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
