//
//  serializeView.m
//  enjoyReader3
//
//  Created by WangXy on 16/9/18.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "serializeView.h"

@implementation serializeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)updateViewConstraints{
    [self updateViewConstraints];

    self.viewWidth.constant = 2*kScreenWidth;
    self.secondViewLeading.constant = kScreenWidth;
}
@end
