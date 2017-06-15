//
//  ShowViewController.h
//  enjoyReader3
//
//  Created by WangXy on 16/8/30.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowViewController : ERBassViewController
@property BOOL blockActionMenu;
@property (nonatomic, strong) NSURL *sourceURL;//链接地址
@property (nonatomic, assign) BOOL isPush;//是否是push

@end
