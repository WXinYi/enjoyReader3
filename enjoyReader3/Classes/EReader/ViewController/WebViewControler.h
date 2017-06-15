//
//  E_WebViewControler.h
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NJKWebViewProgressView.h"
//#import "NJKWebViewProgress.h"
/**
 *  浏览器视图控制器
 */
@interface WebViewControler : UIViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
//    NJKWebViewProgressView *_progressView;
//    NJKWebViewProgress *_progressProxy;
    NSString *_selectString;

}

- (id)initWithSelectString:(NSString *)selectString;

@end
