//
//  E_ScrollViewController.h
//  E_Reader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  放置阅读页的控制器
 */
@interface ReaderScrollViewController : UIViewController

@property (nonatomic ,strong) NSString *Content;
@property (nonatomic ,strong) NSArray *chapterArr;
@property (nonatomic ,assign) BOOL isFromHome;

@end
