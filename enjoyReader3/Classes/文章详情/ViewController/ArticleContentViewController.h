//
//  ArticleContentViewController.h
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/5.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERBassViewController.h"
#import "WPEditorField.h"
#import <WordPressComAnalytics/WPAnalytics.h>

@interface ArticleContentViewController : ERBassViewController
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *titlePlaceholderText;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, copy) NSString *bodyPlaceholderText;
@property (nonatomic, strong) NSURL *sourceURL;//链接地址
@property (nonatomic, assign) BOOL isPush;//是否是push
@end
