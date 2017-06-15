//
//  HomeHeaderView.h
//  enjoyReader3
//
//  Created by WangXy on 16/9/5.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *headerIcon;
@property (strong, nonatomic) IBOutlet UILabel *headerTitle;
@property (strong, nonatomic) IBOutlet UIImageView *jumpImage;
@property (strong, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) IBOutlet UIButton *HeaderBtn;
@end
