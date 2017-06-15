//
//  ClassMethodsViewController.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/5/20.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXYClassMethodsViewController : UIViewController
+ (WXYClassMethodsViewController *)shareInstance;

//判断用户是否登录
- (NSString *)getUserUid;

//把多个json字符串转为一个json字符串
+ (NSString *)objArrayToJSON:(NSArray *)array;

//json字符串转为数组
+(NSArray *)stringToJSON:(NSString *)jsonStr;


/**
 *  UFT8转换
 *
 *  @param input 需要转化的NSString
 *
 *  @return 转化的NSString
 */
+ (NSString *)encodeURL:(NSString *)input;
/**
 *  加密的类方法
 *
 *  @param encrypt 需要加密的NSString
 *
 *  @return 加密的NSString
 */
+ (NSString *)encrypt:(NSString *)encrypt;
/**
 *  解密的类方法
 *
 *  @param decode 需要解密的NSString
 *
 *  @return 解密的NSString
 */
+ (NSString *)decode:(NSString *)decode;

/**
 *  MD5类方法
 *
 *  @param string 需要md5编码的NSString
 *
 *  @return 编码的NSString
 */
+ (NSString *)md5:(NSString *)string;

/**
 *  NSString获取颜色
 *
 *  @param color 颜色的字符串的值
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
/**
 *  邮箱是否正确
 *
 *  @param email 邮箱
 *
 *  @return YES or NO
 */
+ (BOOL) validateEmail:(NSString *)email;
/**
 *  校验身份证的合法性
 *
 *  @param value 身份证号
 *
 *  @return Yes or No
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;
/**
 *  校验手机号码
 *
 *  @param value 手机号码
 *
 *  @return Yes or No
 */
+(BOOL) isValidateMobile:(NSString *)mobile;
/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
//+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;


@end
