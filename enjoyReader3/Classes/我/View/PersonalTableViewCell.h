//
//  PersonalTableViewCell.h
//  enjoyReader3
//
//  Created by WangXy on 16/9/21.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *Personalicon;
@property (strong, nonatomic) IBOutlet UILabel *personalTitle;
@property (strong, nonatomic) IBOutlet UILabel *personalInfo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleToInfoSize;
@property (strong, nonatomic) IBOutlet UIButton *writeBtn;

@end
