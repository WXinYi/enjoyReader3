//
//  ERBassViewController.h
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/2.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHUD.h"
@interface ERBassViewController : UIViewController

@property (nonatomic) JHUD *loadingHudView;

///**
// *  显示navigation
// */
//- (void)showNavigation;
///**
// *  隐藏navigation
// */
//- (void)hiddenNavigation;

/*! 显示自定义的HUD，一秒后自动消失，一行文字的时候 */
-(void)showCustomHudSingleLine:(NSString *)text;
//隐藏hud
-(void)hideCustomHud;

//显示加载中 页面底层的加载中

-(void)loadingCircleAnimation;
-(void)loadingCircleJoinAnimation;
-(void)loadingDotAnimation;
-(void)loadingCustomAnimations;
-(void)loadingGifAnimations;
-(void)loadingFailure;
-(void)loadingFailure2;
-(void)loadinghide;
/**
 *  显示暂无的图片，imgName就是要显示的图片的名字
 */
-(void)showEmptyImgViewWithImgName:(NSString *)imgName;
/**
 *  显示 暂无数据 的图片
 *
 *  @param title 文字描述
 */
-(void)showEmptyNoDataViewWithTitle:(NSString*)title;

/**
 *  隐藏暂无图片
 */
-(void)hiddenEmptyAllView;

- (void)positioningImage:(NSUInteger )type;

- (void)hiddenPositingImage;


//将时间戳转换成 年 月 日 时 分
-(NSString *)changeTimeToString:(NSString *)String;

/**
 *  调用分享
 *
 *  @param title  标题
 *  @param images 图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage。如: @"http://www.mob.com/images/logo_black.png" 或 @[@"http://www.mob.com/images/logo_black.png"]
 *  @param text   内容
 *  @param url    链接
 *  @param type   类型
 */
-(void)sharewithtitle:(NSString *)title andimages:(NSArray *)images andtext:(NSString*)text andurl:(NSURL*)url andtype:(NSUInteger ) type;



- (UIColor *) colorWithHexString: (NSString *)color;

@end
