//
//  SearchTextFile.m
//  enjoyReader3
//
//  Created by WangXy on 2016/9/29.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "SearchTextFile.h"

@implementation SearchTextFile

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame drawingLeft:(UIImageView *)icon{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    
    iconRect.origin.x += 9;// 右偏10
    
    return iconRect;
}


@end
