//
//  SWRAvatarView.m
//  JianshuMyPage
//
//  Created by Weiran Shi on 2015-12-06.
//  Copyright (c) 2015 Vera Shi. All rights reserved.
//

#import "SWRAvatarView.h"

@interface SWRAvatarView ()
{
    CGFloat _avatarRadiusMax;
}

@property (nonatomic, strong) UIImageView *avatarView;

@end

const CGFloat maxScrollRange = 100;

@implementation SWRAvatarView

- (instancetype)initWithAvatar:(NSString *)avatar minRadius:(CGFloat)minRadius frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        _avatarView = [[UIImageView alloc] init];
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 69, 69)];
        NSURL *ava = [NSURL URLWithString:avatar];
        [iconImage sd_setImageWithURL:ava placeholderImage:[UIImage imageNamed: @"luyou.jpg"]];
        iconImage.layer.cornerRadius = iconImage.frame.size.width / 2;
        iconImage.clipsToBounds = YES;

        [_avatarView addSubview:iconImage];

        [self addSubview:_avatarView];
        
        _avatarView.image =[UIImage imageNamed:@"touxiangwaiquan"];
        _avatarRadiusMin = minRadius;
        _avatarRadiusMax = frame.size.height / 2;
    
    }
    
    return self;
}

- (void)scaleWhenScroll: (UIScrollView *)scrollView
{
    CGFloat delta = scrollView.contentOffset.y - (-4);
    CGFloat scale = 1 + (_avatarRadiusMin / _avatarRadiusMax - 1) * delta / maxScrollRange;
    CGFloat shiftY = (_avatarRadiusMin - _avatarRadiusMax) * delta / maxScrollRange;
    
    if (delta <= maxScrollRange && delta >= 0){
        
        self.transform = CGAffineTransformMake(scale, 0, 0, scale, 0, shiftY);
        
    }
}

- (void)layoutSubviews
{
    _avatarView.frame = self.bounds;
    _avatarView.contentMode = UIViewContentModeScaleAspectFit;
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
}@end
