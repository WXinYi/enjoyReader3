//
//  ClassMethodsViewController.m
//  EnjoyReader
//
//  Created by 王馨仪 on 16/5/20.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "ER3DESEncrypt.h"
#import "WXYClassMethodsViewController.h"

@interface WXYClassMethodsViewController ()

@end

@implementation WXYClassMethodsViewController

+ (WXYClassMethodsViewController *)shareInstance {
    static WXYClassMethodsViewController *userManager;
    if (userManager == nil) {
        userManager = [[WXYClassMethodsViewController alloc] init];
    }
    return userManager;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 获取用户是否登录
/**
 *  获取用户的登录状态
 *
 *  @return 无
 */
- (NSString *)getUserUid
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"SelfUidKey"] == nil){
        if ([[user objectForKey:@"SelfUidKey"] isKindOfClass:[NSNumber class]]) {
            NSString * string = [NSString stringWithFormat:@""];
            return string;
        }else{
            
            return @"";
        }
        return @"";
    }else{
        if ([[user objectForKey:@"SelfUidKey"] isKindOfClass:[NSNumber class]]) {
            NSString * userIsLogin = [NSString stringWithFormat:@"%@",[user objectForKey:@"SelfUidKey"]];
            return userIsLogin;
        }else{
            NSString * userIsLogin = [NSString stringWithFormat:@"%@",[user objectForKey:@"SelfUidKey"]];
            return userIsLogin;
        }
    }
}


//把多个json字符串转为一个json字符串
+(NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}

//json字符串转为数组
+ (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}



#pragma- mark 加解密的类
/**
 *  类方法加密
 *
 *  @param encrypt 加密的字符串，根据这个字符串加密
 *
 *  @return 返回加密的结果
 */
+ (NSString *)encrypt:(NSString *)encrypt;
{
    NSString * encryptKey = @"fengkai";
    
    ER3DESEncrypt *encryptCustomKey = [[ER3DESEncrypt alloc] initWithKey:encryptKey];
    
    return [encryptCustomKey encryptString:encrypt];
    
}

/**
 *  类方法解密
 *
 *  @param decode 解密的字符串，根据这个字符串解密
 *
 *  @return 返回解密的结果
 */
+ (NSString *)decode:(NSString *)decode
{
    NSString * decodeKey = @"fengkai";
    
    ER3DESEncrypt *encryptCustomKey = [[ER3DESEncrypt alloc] initWithKey:decodeKey];
    
    return [encryptCustomKey decryptString:decode];
}


/**
 *  MD5类方法
 *
 *  @param string 需要md5编码的NSString
 *
 *  @return 编码的NSString
 */
+ (NSString *)md5:(NSString *)string
{
    const char *ptr = [string UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", md5Buffer[i]];
    
    return output;
}

#pragma -mark UTF8的转换
/**
 *  UTF8转换
 *
 *  @param input UTF8的字符串
 *
 *  @return UTF8的转换结果
 */
+ (NSString *)encodeURL:(NSString *) input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    if (outputStr) {
        return outputStr;
    }
    return @"";
}
#pragma - mark 颜色的转换
/**
 *  类方法  获取颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
#pragma - mark 验证邮箱
/**
 *  邮箱是否正确
 *
 *  @param email 邮箱
 *
 *  @return YES or NO
 */
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)validateIDCardNumber:(NSString *)cid {
    cid = [cid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger length = 0;
    if (!cid) {
        return NO;
    }else {
        length = cid.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [cid substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [cid substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:cid
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, cid.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [cid substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:cid
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, cid.length)];
            
            
            if(numberofMatch >0) {
                int S = ([cid substringWithRange:NSMakeRange(0,1)].intValue + [cid substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([cid substringWithRange:NSMakeRange(1,1)].intValue + [cid substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([cid substringWithRange:NSMakeRange(2,1)].intValue + [cid substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([cid substringWithRange:NSMakeRange(3,1)].intValue + [cid substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([cid substringWithRange:NSMakeRange(4,1)].intValue + [cid substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([cid substringWithRange:NSMakeRange(5,1)].intValue + [cid substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([cid substringWithRange:NSMakeRange(6,1)].intValue + [cid substringWithRange:NSMakeRange(16,1)].intValue) *2 + [cid substringWithRange:NSMakeRange(7,1)].intValue *1 + [cid substringWithRange:NSMakeRange(8,1)].intValue *6 + [cid substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[cid substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
  }

/**
 *  校验手机号码
 *
 *  @param mobile 手机号码
 *
 *  @return Yes or No
 */
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15(1-3,5-0)，18  176 177  178   147   145开头，八个 \d 数字字符
    NSString *regex = @"^((13[0-9])|(147)|(145)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phoneTest evaluateWithObject:mobile];
}


//+(UIColor *)colorWithHexString:(NSString *)color{
//    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
//    
//    // String should be 6 or 8 characters
//    if ([cString length] < 6) {
//        return [UIColor clearColor];
//    }
//    
//    // strip 0X if it appears
//    if ([cString hasPrefix:@"0X"])
//        cString = [cString substringFromIndex:2];
//    if ([cString hasPrefix:@"#"])
//        cString = [cString substringFromIndex:1];
//    if ([cString length] != 6)
//        return [UIColor clearColor];
//    
//    // Separate into r, g, b substrings
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//    
//    //r
//    NSString *rString = [cString substringWithRange:range];
//    
//    //g
//    range.location = 2;
//    NSString *gString = [cString substringWithRange:range];
//    
//    //b
//    range.location = 4;
//    NSString *bString = [cString substringWithRange:range];
//    
//    // Scan values
//    unsigned int r, g, b;
//    [[NSScanner scannerWithString:rString] scanHexInt:&r];
//    [[NSScanner scannerWithString:gString] scanHexInt:&g];
//    [[NSScanner scannerWithString:bString] scanHexInt:&b];
//    
//    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
//}

//
///**
// * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
// */
//+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
//{
//    NSDate *date8 = [WXYClassMethodsViewController getCustomDateWithHour:fromHour];
//    NSDate *date23 = [WXYClassMethodsViewController getCustomDateWithHour:toHour];
//    
////    NSDate *currentDate = [NSDate date];
//    
//    
//    NSString *urlString = @"https://www.baidu.com";
//    
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    
//    // 实例化NSMutableURLRequest，并进行参数配置
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    
//    [request setURL:[NSURL URLWithString: urlString]];
//    
//    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//    
//    [request setTimeoutInterval: 2];
//    
//    [request setHTTPShouldHandleCookies:FALSE];
//    
//    [request setHTTPMethod:@"GET"];
//    
//    
//    
//    NSHTTPURLResponse *response;
//    
//    [NSURLConnection sendSynchronousRequest:request
//     
//                          returningResponse:&response error:nil];
//    
//    
//    
//    // 处理返回的数据
//    
//    //    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    
//    
//    
//    MyNSLog("response is %@",response);
//    
//    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
//    
//    date = [date substringFromIndex:5];
//    
//    date = [date substringToIndex:[date length]-4];
//    
//    
//    
//    
//    
//    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
//    
//    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    
//    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
//    
//    
//    
//    NSDate *currentDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
//    
//    
//    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
//    {
//        MyNSLog("该时间在 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
//        return YES;
//    }
//    return NO;
//}
//
///**
// * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
// * @param hour 如hour为“8”，就是上午8:00（本地时间）
// */
//+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
//{
//    //获取当前时间
//    NSDate *currentDate = [NSDate date];
//    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
//    
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    
//    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
//    
//    //设置当天的某个点
//    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
//    [resultComps setYear:[currentComps year]];
//    [resultComps setMonth:[currentComps month]];
//    [resultComps setDay:[currentComps day]];
//    [resultComps setHour:hour];
//    
//    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    return [resultCalendar dateFromComponents:resultComps];
//}
//

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
