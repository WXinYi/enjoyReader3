//
//  detailBackView.h
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailBackView : UIView



@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView *authorIcon;
@property (strong, nonatomic) IBOutlet UILabel *authorName;

@property (strong, nonatomic) IBOutlet UIButton *authorFollowBtn;
@property (strong, nonatomic) IBOutlet UILabel *haveWatchLabel;

@property (strong, nonatomic) IBOutlet UIView *authorView;
@property (strong, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *authorViewWidth;

@end
