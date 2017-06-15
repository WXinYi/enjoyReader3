//
//  NewloginViewController.h
//  Anhao
//
//  Created by 冯凯 on 15/5/20.
//  Copyright (c) 2015年 lianchuang. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface NewloginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

- (IBAction)phoneid:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *phoneIdTextField;
@property (strong, nonatomic) IBOutlet UILabel *phoneIdLabel;
@property (strong, nonatomic) IBOutlet UIButton *qqButton;
@property (strong, nonatomic) IBOutlet UIButton *weixinButton;
@property (strong, nonatomic) IBOutlet UIButton *sinaButton;
@property (strong, nonatomic) IBOutlet UIButton *phoneCode;
- (IBAction)back:(UIButton *)sender;
- (IBAction)qq:(UIButton *)sender;
- (IBAction)weixin:(UIButton *)sender;
- (IBAction)sina:(UIButton *)sender;
/**
 *  QQ
 */
/**
 *  QQ权限
 */
@property (strong, nonatomic) NSArray * permissions;
/**
 *  QQ的userID
 */
@property (nonatomic,strong) NSString * qqUserId;
/**
 *  第三方登录的id
 */
@property (strong, nonatomic) NSString * otherid;
/**
 *  微信的code
 */
@property (strong, nonatomic) NSString * weixinCode;
/**
 *  微信的token
 */
@property (strong, nonatomic) NSString * access_token;
/**
 *  微信的openid
 */
@property (strong, nonatomic) NSString * openid;

@property (strong, nonatomic) NSString * codeBaseString;

@property (assign, nonatomic) BOOL isCode;

@end
