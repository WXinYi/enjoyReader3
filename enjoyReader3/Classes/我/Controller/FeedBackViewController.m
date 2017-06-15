//
//  FeedBackViewController.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *FeedBacktextView;
@property (strong, nonatomic) IBOutlet UILabel *Placeholder;
@property (strong, nonatomic) IBOutlet UILabel *zishuLabel;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"public_back" hightImage:@"public_back" target:self action:@selector(CommentBack)];
    self.navigationItem.leftBarButtonItems = @[settingItem];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 35, 15);
    [right addTarget:self action:@selector(feedBackEvent) forControlEvents:UIControlEventTouchUpInside];
    [right setTitle:@"提交" forState:UIControlStateNormal];
    right.titleLabel.font =[UIFont systemFontOfSize:15];
//    [right setTitleColor:[WXYClassMethodsViewController colorWithHexString:@"#ba1c18"] forState:UIControlStateNormal];
    [right dk_setTitleColorPicker:DKColorPickerWithKey(TXTONE) forState:UIControlStateNormal];

    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
    [self.view addSubview:lineView];
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.text = @"意见反馈";
    navLabel.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    _FeedBacktextView.layer.borderColor = [WXYClassMethodsViewController colorWithHexString:@"#7d7d7d"].CGColor;
    _FeedBacktextView.layer.borderWidth = 0.5;
    _FeedBacktextView.layer.masksToBounds = YES;
    _FeedBacktextView.layer.cornerRadius = 5;
    _FeedBacktextView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    _FeedBacktextView.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    _FeedBacktextView.delegate = self;
    _Placeholder.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
    _zishuLabel.dk_textColorPicker = DKColorPickerWithKey(TXTTHREE);
}

-(void)feedBackEvent{


}

-(void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length >0) {
        _Placeholder.hidden =YES;

    }else{
        _Placeholder.hidden =NO;

    }

}
-(void)CommentBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
