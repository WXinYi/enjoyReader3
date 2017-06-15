//
//  E_WebViewControler.m
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "WebViewControler.h"


@implementation WebViewControler


- (id)initWithSelectString:(NSString *)selectString{
    
    if (self = [super init]) {
        /**
           stringByTrimmingCharactersInSet 过滤字符串中的特殊符号
         * whitespaceAndNewlineCharacterSet 去除空格
         */
        NSString *completeString = [selectString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//
        completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        _selectString = [completeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//对中文和一些特殊字符进行编码
        
        self.view.backgroundColor = [UIColor whiteColor];
        

    }
    return self;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [titleLbl setText:@"词霸"];
    [titleLbl setTextColor:[UIColor whiteColor]];
    titleLbl.font = [UIFont systemFontOfSize:20];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, 20, 60, 44);
    [backBtn setTitle:@" 返回" forState:0];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:_webView];
    

    
//    CGFloat progressBarHeight = 2.f;
   

    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.iciba.com/%@",_selectString]]];
    [_webView loadRequest:req];
    
}


- (void)backToFront{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}




@end
