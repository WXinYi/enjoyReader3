//
//  NewloginViewController.m
//  Anhao
//
//  Created by 冯凯 on 15/5/20.
//  Copyright (c) 2015年 lianchuang. All rights reserved.
//

#import "NewloginViewController.h"
#import "KeyboardFromPerfInfo.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "WXYClassMethodsViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <SMS_SDK/SMSSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <AdSupport/ASIdentifierManager.h>

@interface NewloginViewController ()<UITextFieldDelegate,CAAnimationDelegate>
@property (nonatomic, strong) KeyboardFromPerfInfo *phonekeyboard;

@end

@implementation NewloginViewController
{
    NSTimer *loginTimer;
    NSInteger chageTag;
    UITapGestureRecognizer * tap;
    NSTimer *phoneTimer;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [phoneTimer invalidate];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    self.phonekeyboard = [[KeyboardFromPerfInfo alloc] initWithFrame:CGRectMake(0,kScreenHeight-216, kScreenWidth, 216)];

    _loginButton.enabled = YES;
    _phoneIdLabel.hidden = YES;
    self.phoneCode.enabled = YES;
    self.phoneTextField.tintColor = [UIColor blackColor];
    _phoneTextField.placeholder = @"请输入手机号";
    [_phoneTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.phoneTextField addTarget:self action:@selector(phoneTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    self.phoneIdTextField.tintColor = [UIColor blackColor];
    self.phoneIdTextField.placeholder = @"请输入短信验证码";
    [self.phoneIdTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneIdTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
//    BOOL  wexin = [WXApi isWXAppInstalled];
//    if (!wexin ){
//        self.weixinButton.hidden = YES;
//    }else{
//        self.weixinButton.hidden = NO;
//    }
    
//    if ([kPlatform isEqualToString:@"ios"]) {
//        self.sinaButton.hidden = NO;
//
//    }else{
//        self.sinaButton.hidden = YES;
//    }
    
    self.navigationController.navigationBarHidden = YES;
    
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.backgroundColor= [self colorWithHexString:@"#BA1B18"];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.userInteractionEnabled = YES;
    
    self.phoneTextField.delegate = self;
    self.phoneIdTextField.delegate = self;

    loginTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(loginAnimatin) userInfo:nil repeats:YES];
    [loginTimer setFireDate:[NSDate distantPast]];
    
    phoneTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(phoneTimer) userInfo:nil repeats:YES];
    [phoneTimer setFireDate:[NSDate distantFuture]];
    
    tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBroad)];
    tap.enabled = NO;
    [self.view addGestureRecognizer:tap];
    
    
    [self.qqButton setExclusiveTouch:YES];
    [self.weixinButton setExclusiveTouch:YES];
    [self.qqButton setExclusiveTouch:YES];

    
    
}
-(void)phoneTextFieldDidChange{

    if (self.phoneTextField.text.length>10) {
        self.phoneCode.enabled = YES;
        [self.phoneCode setImage:[UIImage imageNamed:@"dengluye_button_yanzhengma_liang"] forState:UIControlStateNormal];
    }else{
        self.phoneCode.enabled = YES;
        [self.phoneCode setImage:[UIImage imageNamed:@"dengluye_button_yanzhengma_buliang"] forState:UIControlStateNormal];
    
    }

}


//必须移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

int phoneIdcound = 0;

- (void)phoneTimer{
    
    //    isValidationPhone
    phoneIdcound++;
    int code = 60 - phoneIdcound;
    if (code < 1) {
        self.phoneCode.enabled = YES;
        self.phoneCode.hidden = NO;

        self.phoneIdLabel.hidden = YES;
    }else{
        self.phoneCode.enabled = NO;
        self.phoneIdLabel.text = [NSString stringWithFormat:@"倒计时:%d",code];
    }
    if (phoneIdcound == 60) {
        phoneIdcound = 0;
        [phoneTimer setFireDate:[NSDate distantFuture]];
        
    }
    
}
#pragma mark 登录

- (void)login:(UIButton *)button
{
    if ([self.phoneTextField.text length] == 0 || [self.phoneIdTextField.text length] == 0){
        if ([self.phoneTextField.text length] == 0) {
            
            [HUDView showMsg:@"请输入手机号" inView:self.view];
            
        }else{
            
            [HUDView showMsg:@"请输入验证码" inView:self.view];

        }
    }else{
    
        [SVProgressHUD showWithStatus:@"正在登录"];
        [SMSSDK commitVerificationCode:self.phoneIdTextField.text phoneNumber:self.phoneTextField.text zone:@"86" result:^(NSError *error)
         {
             if (!error)
             {
                 
                 [HUDView showMsg:@"登录成功" inView:self.view];
                 NSString *PlatformUrl = [NSString stringWithFormat:@"%@",KREGISTER];
                 NSString *um = [NSString stringWithFormat:@"%@",self.phoneTextField.text];
                 NSDictionary * params = @{@"Im":@"1",@"um":um};
                 [XYNetworking POST:PlatformUrl params:params success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGIN];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     
                     
                 } fail:^(NSURLSessionDataTask *task, NSError *error) {
                     [SVProgressHUD dismiss];
                     
                     [HUDView showMsg:@"登录失败，请重新尝试" inView:self.view];

                     
                 }];
                 
                 
             }
             else
             {
                 
                 [HUDView showMsg:@"验证失败，请重新尝试" inView:self.view];
                 
            }
         }];
    
    
    
    
    
    }

}
- (void)hiddenKeyBroad
{
    tap.enabled = NO;
    if (iPhone4) {
        [UIView animateWithDuration:0.3 animations:^{
            
//            self.view.top = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
    if (chageTag == 10) {
        if (![WXYClassMethodsViewController isValidateMobile:self.phoneTextField.text] && [self.phoneTextField.text length] != 0) {
            [HUDView showMsg:@"请输入手机号码" inView:self.view];
        }else if ( [self.phoneTextField.text length] == 0){

        }
    }else{
        if (![WXYClassMethodsViewController isValidateMobile:self.phoneTextField.text] && [self.phoneTextField.text length] != 0) {
            [HUDView showMsg:@"请输入手机号码" inView:self.view];
        }else if ( [self.phoneTextField.text length] == 0) {

        }
    }
    [self.phoneTextField resignFirstResponder];
    [self.phoneIdTextField resignFirstResponder];

}
- (void)loginAnimatin
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.delegate = self;
    theAnimation.duration = 0.07;
    theAnimation.repeatCount=1;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = YES;
    
    theAnimation.fromValue = [NSNumber numberWithFloat:0];
    theAnimation.toValue = [NSNumber numberWithFloat:-4];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.qqButton.layer addAnimation:theAnimation forKey:@"SHOW"];
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.weixinButton.layer addAnimation:theAnimation forKey:@"SHOW"];
        
    });dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sinaButton.layer addAnimation:theAnimation forKey:@"SHOW"];
        
    });
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (iPhone4) {
        [UIView animateWithDuration:0.3 animations:^{
            
//            self.view.top = -60;
        } completion:^(BOOL finished) {
            
        }];
    }
    tap.enabled = YES;
    if ([self.phoneTextField isEqual:textField]) {
        chageTag = 10;
    }
    if ([self.phoneIdTextField isEqual:textField]) {
        chageTag = 11;
        if ([self.phoneTextField.text length] == 0) {
            
        }else if ([self.phoneTextField.text length] != 0 && ![WXYClassMethodsViewController isValidateMobile:self.phoneTextField.text]){
            
            [HUDView showMsg:@"请输入手机号码" inView:self.view];
        }else{
            
        }
    }
    return YES;
}


- (void)changeKeyboardTypeAnother {
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)phoneid:(UIButton *)sender
{
    if ([self.phoneTextField.text length] == 0) {
        [HUDView showMsg:@"请输入手机号码" inView:self.view];
    }else if ([self.phoneTextField.text length] != 0 && ![WXYClassMethodsViewController isValidateMobile:self.phoneTextField.text]){
        
        [HUDView showMsg:@"请输入正确的手机号码" inView:self.view];
    }else{
        [phoneTimer setFireDate:[NSDate distantPast]];
        [self.phoneIdTextField becomeFirstResponder];
        self.isCode = YES;
        self.phoneCode.hidden = YES;
        self.phoneIdLabel.hidden = NO;
        self.codeBaseString = self.phoneTextField.text;
        sender.enabled = NO;
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error)
            {
                
            }else{
                [HUDView showMsg:@"获取验证码失败" inView:self.view];
                self.phoneCode.enabled = YES;
                self.phoneIdLabel.text = @"获取验证码";
                phoneIdcound = 0;
            }
            
            
        }];

    }
}

#pragma - mark 字符串转字典
/**
 *  字符串转字典
 *
 *  @param JSONString JSON字符串
 *
 *  @return 字典
 */
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

- (IBAction)back:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)qq:(UIButton *)sender{

    //例如QQ的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             NSLog(@"rawData = %@",user.rawData);

         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}
- (IBAction)weixin:(UIButton *)sender{

    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             NSLog(@"rawData = %@",user.rawData);

         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}
- (IBAction)sina:(UIButton *)sender{
    
    
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             NSLog(@"icon = %@",user.icon);
             NSLog(@"url = %@",user.url);
             NSLog(@"aboutMe = %@",user.aboutMe);
             NSLog(@"verifyType = %ld",(long)user.verifyType);
             NSLog(@"birthday = %@",user.birthday);
             NSLog(@"followerCount = %ld",(long)user.followerCount);
             NSLog(@"friendCount = %ld",(long)user.friendCount);
             NSLog(@"shareCount = %ld",(long)user.shareCount);
             NSLog(@"regAt = %f",user.regAt);
             NSLog(@"level = %ld",(long)user.level);
             NSLog(@"rawData = %@",user.rawData);
             NSLog(@"works = %@",user.works);
             NSLog(@"educations = %@",user.educations);
             NSLog(@"%@",user.credential);

             NSLog(@"rawData = %@",user.rawData);

         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];

}
-(UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end




