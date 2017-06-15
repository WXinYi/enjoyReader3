//
//  SWRTabButton.m
//  JianshuMyPage
//
//  Created by Weiran Shi on 2015-12-10.
//  Copyright © 2015 Vera Shi. All rights reserved.
//

#import "SWRTabButton.h"
@interface SWRTabButton ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation SWRTabButton

- (instancetype)initWithButtonTitle:(NSString *)buttonTitle frame:(CGRect)frame
{
    [self setTitle:buttonTitle forState:UIControlStateNormal];
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
        CGSize size = [self.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f],NSFontAttributeName, nil]];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 50, size.width, 2)];
        _lineView.center = CGPointMake(self.frame.size.width/2, 49);
        _lineView.backgroundColor = [UIColor clearColor];
        [self addSubview:_lineView];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    }
    return self;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected){
        UIColor *tintRed = [UIColor colorWithRed:206/255.0 green:84/255.0 blue:70/255.0 alpha:0.9];
        [self setTitleColor:tintRed forState:UIControlStateSelected];
        self.lineView.backgroundColor = tintRed;
    }
    else{
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.lineView.backgroundColor = [UIColor clearColor];
    }

}


@end
