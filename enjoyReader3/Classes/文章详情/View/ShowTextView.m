//
//  ShowTextView.m
//  enjoyReader3
//
//  Created by WangXy on 16/8/30.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ShowTextView.h"

@implementation ShowTextView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(flag:)];
        UIMenuItem *selectItem = [[UIMenuItem alloc] initWithTitle:@"哈哈哈" action:@selector(mySelect:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:flag,selectItem, nil]];
        
        
        //        self.text = @"hahahhahahahahahahhahaha";
        self.editable = NO;
        self.font = [UIFont systemFontOfSize:18];
    }
    return self;
}

- (void) mySelect: (id) sender {
    [self select:sender];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    NSLog(@"%",self.selectedRange);
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
