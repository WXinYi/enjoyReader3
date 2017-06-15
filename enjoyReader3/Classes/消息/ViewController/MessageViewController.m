//
//  MessageViewController.m
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/2.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadingGifAnimations];
    
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
