//
//  ShowWebView.m
//  enjoyReader3
//
//  Created by WangXy on 16/8/30.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ShowWebView.h"

@implementation ShowWebView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(flag:)];
        UIMenuItem *selectItem = [[UIMenuItem alloc] initWithTitle:@"哈哈哈" action:@selector(mySelect:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:flag,selectItem, nil]];
        
        
    }
    return self;
}

- (void) mySelect: (id) sender {
    [self select:sender];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(flag:)) {
        return YES;
    }
    if (action == @selector(mySelect:)) {
        return [super canPerformAction:@selector(select:) withSender:sender];
    }
    
    
    return NO; 
}

- (void)flag:(id)sender{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (pasteBoard.string != nil) {
        NSLog(@"%@", pasteBoard.string);
    }
}

@end
